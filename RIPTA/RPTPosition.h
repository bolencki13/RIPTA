//
//  RPTPosition.h
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>
#import <CoreGraphics/CGBase.h>

@interface RPTPosition : NSObject
@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, readonly) NSInteger bearing;
@property (nonatomic, readonly) CGFloat odometer;
@property (nonatomic, readonly) CGFloat speed;
- (instancetype)initWithJSON:(NSDictionary*)json;
@end
