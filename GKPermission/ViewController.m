//
//  ViewController.m
//  GKPermission
//
//  Created by Georg Kitz on 30/06/14.
//  Copyright (c) 2014 Aurora Apps. All rights reserved.
//

#import "ViewController.h"

#import "GKPhotoPermission.h"
#import "GKLocationPermission.h"
#import "GKContactPermission.h"
#import "GKSocialPermissions.h"
#import "GKNotificationPermission.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSArray *array;
@property (nonatomic, assign) IBOutlet UITableView *tableView;
@property (nonatomic, strong) GKPhotoPermission *photoPermission;
@property (nonatomic, strong) GKLocationPermission *locationPermission;
@property (nonatomic, strong) GKContactPermission *contactPermission;
@property (nonatomic, strong) GKSocialPermissions *twitterPermission;
@property (nonatomic, strong) GKNotificationPermission *notificationPermission;
@end

@implementation ViewController
            
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.array = @[@"Photos Permission", @"Always Location Permission", @"Contacts", @"Twitter", @"Notifications"];
    
    self.photoPermission = [GKPhotoPermission new];
    self.locationPermission = [[GKLocationPermission alloc] initWithType:GKLocationPermissionTypeAlways];
    self.contactPermission = [GKContactPermission new];
    self.twitterPermission = [[GKSocialPermissions alloc] initWithAccountType:ACAccountTypeIdentifierTwitter];
    self.notificationPermission = [[GKNotificationPermission alloc] init];
    
    self.tableView.contentInset = UIEdgeInsetsMake(20, 0, 0, 0);
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.array.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = self.array[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0: {
            [self _checkPhotoPermissions];
        } break;
        case 1: {
            [self _checkAlwaysLocationPermission];
        } break;
        case 2: {
            [self _checkContactPermission];
        } break;
        case 3: {
            [self _checkTwitterPermission];
        } break;
        case 4: {
            [self _checkNotificationPermission];
        }
            
        default:
            break;
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark -
#pragma mark Private Methods

- (void)_checkPhotoPermissions {
    [self.photoPermission authorize:^(BOOL authorized, NSError *error) {
        NSLog(@"Photo Granted %d, Error %@", authorized, error);
    }];
}

- (void)_checkAlwaysLocationPermission {
    [self.locationPermission authorize:^(BOOL authorized, NSError *error) {
        NSLog(@"Location Granted %d, Error %@", authorized, error);
    }];
}

- (void)_checkContactPermission {
    [self.contactPermission authorize:^(BOOL authorized, NSError *error) {
        NSLog(@"Contact Granted %d, Error %@", authorized, error);
    }];
}

- (void)_checkTwitterPermission {
    [self.twitterPermission authorize:^(BOOL authorized, NSError *error) {
        NSLog(@"Twitter Granted %d, Error %@", authorized, error);
    }];
}

- (void)_checkNotificationPermission {
    [self.notificationPermission authorize:^(BOOL authorized, NSError *error) {
        NSLog(@"Notification Granted %d, Error %@", authorized, error);
    }];
}

@end
