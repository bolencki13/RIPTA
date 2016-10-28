//
//  RPTVehicle.h
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPTTrip, RPTPosition;
@interface RPTVehicle : NSObject
@property (nonatomic, retain, readonly) RPTTrip *trip;
@property (nonatomic, retain, readonly) RPTPosition *position;
@property (nonatomic, retain, readonly) NSString *currentStopSequence;
@property (nonatomic, retain, readonly) NSString *currentStatus;
@property (nonatomic, retain, readonly) NSString *timeStamp;
@property (nonatomic, retain, readonly) NSString *congestionLevel;
@property (nonatomic, retain, readonly) NSString *stopID;
@property (nonatomic, retain, readonly) NSString *identifer;
@property (nonatomic, retain, readonly) NSString *label;
@property (nonatomic, retain, readonly) NSString *licensePlate;
- (instancetype)initWithJSON:(NSDictionary*)json;
@end
