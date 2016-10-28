//
//  RPTPosition.m
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTPosition.h"

@implementation RPTPosition
- (instancetype)initWithJSON:(NSDictionary*)json {
    self = [super init];
    if (self) {
        _coordinate = CLLocationCoordinate2DMake([[json objectForKey:@"latitude"] integerValue], [[json objectForKey:@"longitude"] integerValue]);
        _bearing = [[json objectForKey:@"bearing"] integerValue];
        _odometer = [[json objectForKey:@"odometer"] floatValue];
        _speed = [[json objectForKey:@"speed"] floatValue];
    }
    return self;
}
@end
