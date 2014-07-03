//
//  GKContactPermission.m
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKContactPermission.h"

@import AddressBook;

@interface GKContactPermission ()
@end

@implementation GKContactPermission

#pragma mark -
#pragma mark States

- (BOOL)isAuthorized {
    return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized;
}

- (BOOL)isUnAuthorized {
    ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
    return  status == kABAuthorizationStatusDenied || status == kABAuthorizationStatusRestricted;
}

- (BOOL)isUndetermined {
    return ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined;
}

#pragma mark -
#pragma mark Permission Check

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    
    void (^addressBookCompletion)(bool, CFErrorRef) = ^(bool granted, CFErrorRef error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (granted) {
                completion(YES, nil);
            } else {
                completion(NO, [NSError errorWithDomain:@"GKContactPermission" code:6 userInfo:nil]);
            }
        });
    };
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    ABAddressBookRequestAccessWithCompletion(addressBook, addressBookCompletion);
}

#pragma mark -
#pragma mark Overriden Strings

- (NSString *)appName {
    return [[NSBundle mainBundle] infoDictionary][@"CFBundleName"];
}

- (NSString *)deniedAlertMessageString {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Contact", @""), self.appName];
}

- (NSString *)deniedAlertMessageStringOS8 {
    return [NSString stringWithFormat:NSLocalizedString(@"Permission.Denied.Contact.OS8", @""), self.appName];
}

- (NSString *)firstAlertMessageString {
    return NSLocalizedString(@"Permission.Access.Contact", @"");
}

- (void)_checkPermissionStringAvailable {
    
    NSDictionary *dict = [NSBundle mainBundle].infoDictionary;
    if (!dict[@"NSContactsUsageDescription"]) {
        
        NSAssert(NO, @"You must add \"NSContactsUsageDescription\" to your Info.plist");
    }
}

@end
