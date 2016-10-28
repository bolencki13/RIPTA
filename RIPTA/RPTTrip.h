//
//  RPTTrip.h
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RPTTrip : NSObject
@property (nonatomic, retain, readonly) NSString *identifier;
@property (nonatomic, retain, readonly) NSDate *startTime;
@property (nonatomic, retain, readonly) NSDate *startDate;
@property (nonatomic, retain, readonly) NSString *scheduleRelationship;
@property (nonatomic, retain, readonly) NSString *routeID;
- (instancetype)initWithJSON:(NSDictionary*)json;
@end
