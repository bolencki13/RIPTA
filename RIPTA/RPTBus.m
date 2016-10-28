//
//  RPTBus.m
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTBus.h"

@implementation RPTBus
- (instancetype)initWithJSON:(NSDictionary *)json {
    self = [super initWithJSON:json];
    if (self) {
        [self setValue:[json objectForKey:@"id"] forKey:@"_identifer"];
        _deleted = [[json objectForKey:@"is_deleted"] boolValue];
    }
    return self;
}
@end
