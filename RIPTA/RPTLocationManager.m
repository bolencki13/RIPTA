//
//  RPTLocationManager.m
//  RIPTA
//
//  Created by Brian Olencki on 10/28/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTLocationManager.h"

@interface RPTLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, copy) Success success;
@property (nonatomic, copy) Failed failed;
@end

@implementation RPTLocationManager
+ (RPTLocationManager *)sharedManager {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}
- (instancetype)init {
    self = [super init];
    if (self) {
        _locationManager = [[CLLocationManager alloc] init];
        _locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
        [_locationManager requestWhenInUseAuthorization];
    }
    return self;
}
- (void)getUserLocation:(void (^const)(CLLocation *))success error:(void (^const)(NSError *))failed {
    self.success = success;
    self.failed = failed;

    _locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    if (self.failed) self.failed(error);
}
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    [_locationManager stopUpdatingLocation];
    CLLocation *location = [locations lastObject];
    if (self.success) self.success(location);
}
@end
