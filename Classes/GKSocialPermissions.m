//
//  GKSocialPermissions.m
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKSocialPermissions.h"

@interface GKSocialPermissions ()
@property (nonatomic, strong) ACAccountStore *accountStore;
@property (nonatomic, strong) ACAccountType *accountType;
@property (nonatomic, assign) BOOL alreadyAskedOnce;
@end

@implementation GKSocialPermissions

#pragma mark -
#pragma mark Init Methods

- (instancetype)initWithAccountType:(NSString *)accountType {
    if (self = [super init]) {
        self.accountStore = [ACAccountStore new];
        self.accountType = [self.accountStore accountTypeWithAccountTypeIdentifier:accountType];
    }
    return self;
}

#pragma mark -
#pragma mark States

- (BOOL)isAuthorized {
    return [self.accountType accessGranted];
}

- (BOOL)isUnAuthorized {
    return self.alreadyAskedOnce && ![self.accountType accessGranted];
}

- (BOOL)isUndetermined {
    return [self.accountType accessGranted];
}

- (BOOL)alreadyAskedOnce {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:self.accountType.identifier];
}

- (void)setAlreadyAskedOnce:(BOOL)alreadyAskedOnce {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:alreadyAskedOnce forKey:self.accountType.identifier];
    [defaults synchronize];
}

#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    
    void(^accountCompletion)(BOOL, NSError *) = ^(BOOL granted, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
           
            NSLog(@"Error %@", error);
            completion(granted, error);
            
            self.alreadyAskedOnce = YES;
        });
    };
    
    [self.accountStore requestAccessToAccountsWithType:self.accountType options:nil completion:accountCompletion];
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)deniedAlertMessageString {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Twitter", @""), self.appName];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Twitter.OS8", @""), self.appName];
}

- (NSString *)firstAlertMessageString {
    return NSLocalizedString(@"Permission.Access.Twitter", @"");
}

- (void)_checkPermissionStringAvailable {
    //Not used for Social permission
}

@end
