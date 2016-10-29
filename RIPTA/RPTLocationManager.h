//
//  RPTLocationManager.h
//  RIPTA
//
//  Created by Brian Olencki on 10/28/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef void (^Success)(CLLocation *location);
typedef void (^Failed)(NSError *error);

@interface RPTLocationManager : NSObject
@property (nonatomic, retain, readonly) CLLocationManager *locationManager;
+ (RPTLocationManager*)sharedManager;
- (void)getUserLocation:(Success)success error:(Failed)failed;
@end
