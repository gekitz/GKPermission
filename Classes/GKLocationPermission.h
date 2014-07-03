//
//  GKLocationPermission.h
//  GKPermission
//
//  Created by Georg Kitz on 01/07/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GKPermission.h"

typedef NS_ENUM(NSInteger, GKLocationPermissionType) {
    GKLocationPermissionTypeAlways,
    GKLocationPermissionTypeWhenInUse
};

@interface GKLocationPermission : GKPermission
- (instancetype)initWithType:(GKLocationPermissionType)type;
@end
