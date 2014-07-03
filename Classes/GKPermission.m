//
//  GKBasePermission.m
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKPermission.h"
#import <GKBlocks/UIAlertView+GKBlockAddition.h>

@implementation GKPermission

- (instancetype)init {
    if (self = [super init]) {
        [self _checkPermissionStringAvailable];
    }
    return self;
}

- (void)_checkPermissionStringAvailable {
    NSAssert(NO, @"_checkPermissionStringAvailable needs to be implemented by subclass");
}

#pragma mark -
#pragma mark Public Method

- (void)authorize:(GKPermissionCompletion)completion {
    
    NSAssert(completion, @"Completion Handler Must Be Not Nil");
    
    if (self.isAuthorized) {
        
        completion(YES, nil);
        return;
    }
    
    if (self.isUnAuthorized) {
        
        [self _showPreviouslyDeniedDialog];
        return;
    }
    
    [self _authorize:completion];
}

#pragma mark -
#pragma mark Private

- (void)_showPreviouslyDeniedDialog {
    
    UIAlertView *alertView = nil;
    if (NSClassFromString(@"UIAlertAction")) {
        
        void(^alertBlock)(UIAlertView *, NSInteger) = ^(UIAlertView *alertView, NSInteger buttonIndex){
            
            if (alertView.cancelButtonIndex == buttonIndex) {
                return ;
            }
            
            NSURL *URL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:URL];
        };
        
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Permission.Information", @"")
                                               message:[self deniedAlertMessageStringOS8]
                                                 block:alertBlock
                                     cancelButtonTitle:NSLocalizedString(@"Permission.NotNow", @"")
                                     otherButtonTitles:NSLocalizedString(@"Permission.Yes", @""), nil];
        
    } else {
        
        alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Permission.Information", @"")
                                               message:[self deniedAlertMessageString]
                                                 block:nil
                                     cancelButtonTitle:NSLocalizedString(@"Permission.Ok", @"")
                                     otherButtonTitles: nil];
    }
    
    [alertView show];
    
}

- (void)_authorize:(GKPermissionCompletion)completion {
    
    __weak typeof(self) weakSelf = self;
    void(^alertBlock)(UIAlertView *, NSInteger) = ^(UIAlertView *alertView, NSInteger buttonIndex){
        
        if (alertView.cancelButtonIndex == buttonIndex) {
            completion(NO, [NSError errorWithDomain:@"GKPermission" code:1 userInfo:nil]);
            return ;
        }
        
        [weakSelf performRealPermissionCheck:completion];
    };
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Permission.Information", @"")
                                                        message:[self firstAlertMessageString]
                                                          block:alertBlock
                                              cancelButtonTitle:NSLocalizedString(@"Permission.NotNow", @"")
                                              otherButtonTitles:NSLocalizedString(@"Permission.Yes", @""), nil];
    [alertView show];
    
}

- (void)performRealPermissionCheck:(GKPermissionCompletion)completion {
    NSAssert(NO, @"DeniedAlertMessageString must be overriden in SubClass");
}

#pragma mark -
#pragma mark GKPermissionProtocol

- (NSString *)deniedAlertMessageString {
    NSAssert(NO, @"DeniedAlertMessageString must be overriden in SubClass");
    return nil;
}

- (NSString *)deniedAlertMessageStringOS8 {
    NSAssert(NO, @"deniedAlertMessageStringOS8 must be overriden in SubClass");
    return nil;
}

- (NSString *)firstAlertMessageString {
    NSAssert(NO, @"firstAlertMessageString must be overriden in a Subclass");
    return nil;
}

@end
