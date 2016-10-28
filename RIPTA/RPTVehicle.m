//
//  RPTVehicle.m
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTVehicle.h"
#import "RPTTrip.h"
#import "RPTPosition.h"

@implementation RPTVehicle
- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super init];
    if (self) {
        _trip = [[RPTTrip alloc] initWithJSON:[json objectForKey:@"trip"]];
        _position = [[RPTPosition alloc] initWithJSON:[json objectForKey:@"position"]];
        _currentStopSequence = [json objectForKey:@"current_stop_sequence"];
        _currentStatus = [json objectForKey:@"current_status"];
        _timeStamp = [json objectForKey:@"time_stamp"];
        _congestionLevel = [json objectForKey:@"congestion_level"];
        _stopID = [json objectForKey:@"stop_id"];
        _identifer = [json objectForKey:@"id"];
        _label = [json objectForKey:@"label"];
        _licensePlate = [json objectForKey:@"license_plate"];
    }
    return self;
}
@end
