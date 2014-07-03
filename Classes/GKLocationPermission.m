//
//  GKLocationPermission.m
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKLocationPermission.h"

@import CoreLocation;

@interface GKLocationPermission () <CLLocationManagerDelegate>
@property (nonatomic, assign) GKLocationPermissionType type;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, copy) GKPermissionCompletion completionBlock;
@end

@implementation GKLocationPermission

#pragma mark -
#pragma mark Init

- (instancetype)initWithType:(GKLocationPermissionType)type {
    self.type = type;
    return [self init];
}

- (void)_checkPermissionStringAvailable {
    
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if (self.type == GKLocationPermissionTypeAlways && !dict[@"NSLocationAlwaysUsageDescription"]) {
        
        NSAssert(NO, @"You must add \"NSLocationAlwaysUsageDescription\" to your Info.plist");
        
    } else if (self.type == GKLocationPermissionTypeWhenInUse && !dict[@"NSLocationWhenInUseUsageDescription"]){
        
        NSAssert(NO, @"You must add \"NSLocationWhenInUseUsageDescription\" to your Info.plist");
    }
}

#pragma mark -
#pragma mark States

- (BOOL)isAuthorized {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    if (self.type == GKLocationPermissionTypeAlways) {
        return status == kCLAuthorizationStatusAuthorizedAlways;
    } else {
        return status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusAuthorizedAlways;
    }
}

- (BOOL)isUnAuthorized {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return status == kCLAuthorizationStatusRestricted || status == kCLAuthorizationStatusDenied;
}

- (BOOL)isUndetermined {
    
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    return status == kCLAuthorizationStatusNotDetermined;
}

#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    
    self.completionBlock = completion;
    
    self.manager = [CLLocationManager new];
    self.manager.delegate = self;
    
    if (self.type == GKLocationPermissionTypeAlways) {
        [self.manager requestAlwaysAuthorization];
    } else {
        [self.manager requestWhenInUseAuthorization];
    }
}

#pragma mark -
#pragma mark CLLocationManager Delegate

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    
    switch (status) {
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted: {
            self.completionBlock(NO, [NSError errorWithDomain:@"GKLocationPermission" code:3 userInfo:nil]);
            break;
        }
        case kCLAuthorizationStatusAuthorizedWhenInUse:
        case kCLAuthorizationStatusAuthorizedAlways: {
            self.completionBlock(YES, nil);
            break;
        }
        
        case kCLAuthorizationStatusNotDetermined: {
            //DO NOTHING
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)deniedAlertMessageString {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Locations", @""), self.appName];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Locations.OS8", @""), self.appName];
}

- (NSString *)firstAlertMessageString {
    return NSLocalizedString(@"Permission.Access.Locations", @"");
}
@end
