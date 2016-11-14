//
//  RPTRequestHandler.m
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTRequestHandler.h"
#import "RPTBus.h"

@implementation RPTRequestHandler
+ (RPTRequestHandler *)sharedHandler {
    static dispatch_once_t p = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

#pragma mark - API
- (void)getBusses {
    [[[NSURLSession sharedSession] dataTaskWithURL:[NSURL URLWithString:@"http://realtime.ripta.com:81/api/vehiclepositions?format=json"] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            if ([_delegate respondsToSelector:@selector(requestHandler:didNotFindBussesWithError:)]) [_delegate requestHandler:self didNotFindBussesWithError:[[NSError alloc] initWithDomain:@"error.ripta.api" code:9 userInfo:@{
                                                                                                                                                                                                                                   NSLocalizedDescriptionKey : @"Network connection not found",
                                                                                                                                                                                                                                   }]];
        }
        
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (error) {
            if ([_delegate respondsToSelector:@selector(requestHandler:didNotFindBussesWithError:)]) [_delegate requestHandler:self didNotFindBussesWithError:[[NSError alloc] initWithDomain:@"error.ripta.api" code:9 userInfo:@{
                                                                                                                                                                                                                                   NSLocalizedDescriptionKey : @"JSON could not decrypt",
                                                                                                                                                                                                                                   }]];
        }
        
        NSMutableArray *aryBusses = [NSMutableArray new];
        for (NSDictionary *feedEntity in json[@"entity"]) {
            RPTBus *bus = [[RPTBus alloc] initWithJSON:feedEntity];
            [aryBusses addObject:bus];
        }
        if ([_delegate respondsToSelector:@selector(requestHandler:didFindBusses:)]) [_delegate requestHandler:self didFindBusses:aryBusses];
    }] resume];
}
- (NSArray <RPTBus *> *)orderBusses:(NSArray<RPTBus *> *)busses byMethod:(NSComparisonResult (^)(RPTBus *, RPTBus *))method {
    return [busses sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        return method(obj1, obj2);
    }];
}
- (NSArray <RPTBus *> *)orderBusses:(NSArray <RPTBus *> *)busses withLocation:(CLLocation*)coordinate {
    NSMutableArray <RPTBus *> *aryTemp = [busses mutableCopy];
    
    for (NSInteger x = 0; x < [busses count]; x++) {
        for (NSInteger y = x+1; y < [busses count]; y++) {
            if ([coordinate distanceFromLocation:[[CLLocation alloc] initWithLatitude:[aryTemp objectAtIndex:x].position.coordinate.latitude longitude:[aryTemp objectAtIndex:x].position.coordinate.longitude]] > [coordinate distanceFromLocation:[[CLLocation alloc] initWithLatitude:[aryTemp objectAtIndex:y].position.coordinate.latitude longitude:[aryTemp objectAtIndex:y].position.coordinate.longitude]]) {
                RPTBus *tempBus = [aryTemp objectAtIndex:x];
                [aryTemp replaceObjectAtIndex:x withObject:[aryTemp objectAtIndex:y]];
                [aryTemp replaceObjectAtIndex:y withObject:tempBus];
            }
        }
    }
    
    return aryTemp;
}
@end
