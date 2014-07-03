//
//  GKNotificationPermission.m
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKNotificationPermission.h"

static NSString *const kUserDefaults = @"permission.user.defaults.key";

NSString *const kUserEnabledNotification = @"notification.user.enabled";
NSString *const kUserErrorNotification = @"notification.user.error";

#pragma mark -
#pragma mark Permission Handling OS7
#pragma mark -

@interface GKNotificationPermissionOS7 : GKPermission
@property (nonatomic, assign) UIRemoteNotificationType types;
@property (nonatomic, assign) BOOL alreadyAskedOnce;
@property (nonatomic, copy) GKPermissionCompletion completion;
@end

@implementation GKNotificationPermissionOS7

#pragma mark -
#pragma mark Init Methods

- (instancetype)initWithRemoteNotificationTypes:(UIRemoteNotificationType)types {
    if (self = [super init]) {
        
        self.types = types;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(_handleEnabledNotification:) name:kUserEnabledNotification object:nil];
        [center addObserver:self selector:@selector(_handleErrorNotification:) name:kUserErrorNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark States

- (BOOL)alreadyAskedOnce {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:kUserDefaults];
}

- (void)setAlreadyAskedOnce:(BOOL)alreadyAskedOnce {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:alreadyAskedOnce forKey:kUserDefaults];
    [defaults synchronize];
}

- (BOOL)isAuthorized {
    UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
    return type != UIRemoteNotificationTypeNone;
}

- (BOOL)isUnAuthorized {
    return self.alreadyAskedOnce && !self.isAuthorized;
}

- (BOOL)isUndetermined {
    return !self.isAuthorized;
}


#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    
    self.completion = completion;
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:self.types];
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)deniedAlertMessageString {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Notification", @""), self.appName];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Notification.OS8", @""), self.appName];
}

- (NSString *)firstAlertMessageString {
    return NSLocalizedString(@"Permission.Access.Notification", @"");
}

- (void)_checkPermissionStringAvailable {
    //Nothing TODO in this case
}

#pragma mark -
#pragma mark Notifications

- (void)_handleEnabledNotification:(NSNotification *)notification {
    self.completion(YES, nil);
    self.alreadyAskedOnce = YES;
}

- (void)_handleErrorNotification:(NSNotification *)notification {
    NSError *error = notification.userInfo[kUserErrorNotification];
    
    if (error.code != 3000) {
        //3000 means that the apns-entitlements is missing
        self.alreadyAskedOnce = YES;
    }
    
    self.completion(NO, error);
}

@end

#pragma mark -
#pragma mark Permission Handling OS8
#pragma mark -

@interface GKNotificationPermissionOS8 : GKPermission
@property (nonatomic, strong) UIUserNotificationSettings *settings;
@property (nonatomic, assign) BOOL alreadyAskedOnce;
@property (nonatomic, copy) GKPermissionCompletion completion;
@end

@implementation GKNotificationPermissionOS8

#pragma mark -
#pragma mark Init Methods

- (instancetype)initWithUserNotificationSettings:(UIUserNotificationSettings *)settings {
    if (self = [super init]) {
        
        self.settings = settings;
        
        NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
        [center addObserver:self selector:@selector(_handleEnabledNotification:) name:kUserEnabledNotification object:nil];
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark -
#pragma mark States

- (BOOL)alreadyAskedOnce {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:kUserDefaults];
}

- (void)setAlreadyAskedOnce:(BOOL)alreadyAskedOnce {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:alreadyAskedOnce forKey:kUserDefaults];
    [defaults synchronize];
}

- (BOOL)isAuthorized {
    UIUserNotificationSettings *settings = [[UIApplication sharedApplication] currentUserNotificationSettings];
    return settings.types != UIUserNotificationTypeNone;
}

- (BOOL)isUnAuthorized {
    return self.alreadyAskedOnce && !self.isAuthorized;
}

- (BOOL)isUndetermined {
    return !self.isAuthorized;
}


#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    
    self.completion = completion;
    [[UIApplication sharedApplication] registerUserNotificationSettings:self.settings];
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)deniedAlertMessageString {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Notification", @""), self.appName];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Notification.OS8", @""), self.appName];
}

- (NSString *)firstAlertMessageString {
    return NSLocalizedString(@"Permission.Access.Notification", @"");
}

- (void)_checkPermissionStringAvailable {
    //Nothing TODO in this case
}

#pragma mark -
#pragma mark Notifications

- (void)_handleEnabledNotification:(NSNotification *)notification {
    
    //TODO handle iOS7
    UIUserNotificationSettings *settings = notification.userInfo[kUserEnabledNotification];
    if (settings.types == UIUserNotificationTypeNone) {
        
        self.completion(NO, [NSError errorWithDomain:@"TRNotificationPermission" code:6 userInfo:nil]);
        
    } else {
        self.completion(YES, nil);
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    }
    self.alreadyAskedOnce = YES;
}

- (void)_handleErrorNotification:(NSNotification *)notification {
    self.alreadyAskedOnce = YES;
}

@end

#pragma mark -
#pragma mark PermissionsWrapper
#pragma mark -

@implementation GKNotificationPermission {
    GKPermission *_permission;
}

#pragma mark -
#pragma mark Init Methods

- (instancetype)initWithRemoteNotificationType:(UIRemoteNotificationType)types {
    if (self = [super init]) {
        _permission = [[GKNotificationPermissionOS7 alloc] initWithRemoteNotificationTypes:types];
    }
    return self;
}

- (instancetype)initWithUserNotificationSettings:(UIUserNotificationSettings *)settings {
    if (self = [super init]) {
        _permission = [[GKNotificationPermissionOS8 alloc] initWithUserNotificationSettings:settings];
    }
    return self;
}

- (instancetype)init {
    if (self = [super init]) {
        
        if (NSClassFromString(@"UIAlertAction")) {
            
            UIUserNotificationType types = UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound;
            UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
            _permission = [[GKNotificationPermissionOS8 alloc] initWithUserNotificationSettings:settings];
            
        } else {
            
            UIRemoteNotificationType types = UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound;
            _permission = [[GKNotificationPermissionOS7 alloc] initWithRemoteNotificationTypes:types];
        }
    }
    return self;
}

#pragma mark -
#pragma mark States

- (BOOL)isAuthorized {
    return _permission.isAuthorized;
}

- (BOOL)isUnAuthorized {
    return _permission.isUnAuthorized;
}

- (BOOL)isUndetermined {
    return _permission.isUndetermined;
}

#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    [_permission performRealPermissionCheck:completion];
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)deniedAlertMessageString {
    return [_permission deniedAlertMessageString];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [_permission deniedAlertMessageStringOS8];
}

- (NSString *)firstAlertMessageString {
    return [_permission firstAlertMessageString];
}

- (void)_checkPermissionStringAvailable {
    //Nothing TODO in this case
}

@end
