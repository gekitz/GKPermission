//
//  GKNotificationPermission.h
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKPermission.h"

@import UIKit;

extern NSString *const kUserEnabledNotification;
extern NSString *const kUserErrorNotification;

@interface GKNotificationPermission : GKPermission
- (instancetype)initWithUserNotificationSettings:(UIUserNotificationSettings *)settings;
@end
