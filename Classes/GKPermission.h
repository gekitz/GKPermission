//
//  GKBasePermission.h
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GKPermissionProtocol <NSObject>

@required

- (NSString *)deniedAlertMessageString;
- (NSString *)deniedAlertMessageStringOS8;

- (NSString *)firstAlertMessageString;

@end

typedef void(^GKPermissionCompletion)(BOOL authorized, NSError *error);

@interface GKPermission : NSObject <GKPermissionProtocol>

@property (nonatomic, readonly) BOOL isAuthorized;
@property (nonatomic, readonly) BOOL isUnAuthorized;
@property (nonatomic, readonly) BOOL isUndetermined;

- (void)authorize:(GKPermissionCompletion)completion;

/*
 * @method performRealPermissionCheck
 * Subclasses need to override this method and implement
 * it with the logic needed to for the permission check
 */
- (void)performRealPermissionCheck:(GKPermissionCompletion)completion;
@end