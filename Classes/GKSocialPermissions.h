//
//  GKSocialPermissions.h
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "GKPermission.h"

@import Accounts;
@interface GKSocialPermissions : GKPermission
- (instancetype)initWithAccountType:(NSString *)accountType;
@end
