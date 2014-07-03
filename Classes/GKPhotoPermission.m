//
//  GKPhotoPermission.m
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKPhotoPermission.h"

@import AssetsLibrary;

@implementation GKPhotoPermission

#pragma mark -
#pragma mark States

- (BOOL)isAuthorized {
    return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized;
}

- (BOOL)isUnAuthorized {
    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    return  status == ALAuthorizationStatusDenied || status == ALAuthorizationStatusRestricted;
}

- (BOOL)isUndetermined {
    return [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined;
}

#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library enumerateGroupsWithTypes:ALAssetsGroupAll usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
       
        *stop = YES;
        completion(YES, nil);
        
    } failureBlock:^(NSError *error) {
        
        completion(NO, [NSError errorWithDomain:@"GKPhotoPermission" code:2 userInfo:nil]);
        
    }];
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)deniedAlertMessageString {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Photos", @""), self.appName];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Photos.OS8", @""), self.appName];
}

- (NSString *)firstAlertMessageString {
    return NSLocalizedString(@"Permission.Access.Photos", @"");
}

- (void)_checkPermissionStringAvailable {
    
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if (!dict[@"NSCameraUsageDescription"]) {
        
        NSAssert(NO, @"You must add \"NSCameraUsageDescription\" to your Info.plist");
    }
}
@end
