//
//  RPTTrip.m
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTTrip.h"

@implementation RPTTrip
- (instancetype)initWithJSON:(NSDictionary*)json {
    self = [super init];
    if (self) {
        _identifier = [json objectForKey:@"trip_id"];
        _startTime = [self dateFromString:[json objectForKey:@"start_time"] withFormat:@"HH:mm:ss"];
        _startDate = [self dateFromString:[json objectForKey:@"start_date"] withFormat:@"yyyymmdd"];
        _scheduleRelationship = [json objectForKey:@"schedule_relationship"];
        _routeID = [json objectForKey:@"route_id"];
    }
    return self;
}
- (NSDate*)dateFromString:(NSString*)string withFormat:(NSString*)format {
    NSDateFormatter *dateFormat1 = [[NSDateFormatter alloc] init];
    [dateFormat1 setDateFormat:format];
    return [dateFormat1 dateFromString:string];
}
@end
