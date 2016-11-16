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
- (void)getSiteInfo:(NSString *)RTNum{
    
    NSString *url = @"http://www.ripta.com/";
    __block NSString *fullstring = [url stringByAppendingString:RTNum];
    
 [[[NSURLSession sharedSession]dataTaskWithURL:[NSURL URLWithString:fullstring] completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error){
        if (error) {
            NSLog(@"Check it");
        }
     
     NSString *dataString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
     NSLog(@"Data string format : %@", dataString);
     
     NSRange Stoprange = [dataString rangeOfString:@"sched-table"];
     NSString *subString = [[dataString substringFromIndex:NSMaxRange(Stoprange)] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     
     NSRange Timerange = [dataString rangeOfString:@"tbody"];
     NSString *substring2 = [[dataString substringFromIndex:NSMaxRange(Timerange)]stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
     
    
     NSMutableArray *LabelNames = [[NSMutableArray alloc]init];
     NSString *LabelName = nil;
     
     NSScanner *scanner = [NSScanner scannerWithString:subString];
     //Grabs everything after sched-label and throws it in array
     
     while (![scanner isAtEnd]) {
         [scanner scanUpToString:@"sched-label" intoString:nil];
         NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'<>"];
         
         [scanner scanUpToCharactersFromSet:charset intoString:nil];
         [scanner scanCharactersFromSet:charset intoString:nil];
         [scanner scanUpToCharactersFromSet:charset intoString:&LabelName];
         [LabelNames addObject:LabelName];
         
     }
     
     //Removes the duuplcates in the array by changing it to an ordered set
     NSArray *NoDups = [[NSOrderedSet orderedSetWithArray:LabelNames]array];
     NSLog(@"Non Duplicated Label Names ; %@", NoDups);
     
     
     
     NSScanner *scanner3 = [NSScanner scannerWithString:subString];
     NSString *TBodyTimes;
     while (![scanner3 isAtEnd]) {
         [scanner3 scanUpToString:@"<tbody>" intoString:nil];
         [scanner3 scanString:@"<tbody>" intoString:nil];
         [scanner3 scanUpToString:@"</tbody>" intoString:&TBodyTimes];
     }
     //NSLog(@"TBody Object : %@", TBodyTimes);
     
     
     //Loading scanner with substring2 b/c TbodyTimes doesnt load everytime
     
     NSString *time = nil;
     NSMutableArray *TimeTable = [[NSMutableArray alloc]init];
     NSScanner *scanner4 = [NSScanner scannerWithString:substring2];
     while (![scanner4 isAtEnd]) {
         [scanner4 scanUpToString:@"td" intoString:nil];
         NSCharacterSet *charset = [NSCharacterSet characterSetWithCharactersInString:@"\"'<>/tdrah"];
         
         [scanner4 scanUpToCharactersFromSet:charset intoString:nil];
         [scanner4 scanCharactersFromSet:charset intoString:nil];
         [scanner4 scanUpToCharactersFromSet:charset intoString:&time];
         [TimeTable addObject:time];
         //[scanner scanUpToString:@"span" intoString:nil];
     }
    // NSLog(@"Clear Times : %@", TimeTable);
     
     int AllTimesCount = (int)TimeTable.count;
    
     NSMutableArray *arrayindexes = [NSMutableArray array];
     
     for (int x = 1; x < AllTimesCount; x++){
         
         if ([[TimeTable objectAtIndex:x] isEqualToString:@"-"]) {
             
             x++;
             
         
         if ([[TimeTable objectAtIndex:x] isEqualToString:[TimeTable objectAtIndex:x-1]]) {
             [arrayindexes addObject:[NSNumber numberWithInteger:x]];
         }
             
         }
     }
     NSLog(@"Index : %@", arrayindexes);
     
     for (int x = (int)arrayindexes.count - 1; x > 0; x--) {
         [TimeTable removeObjectAtIndex:((NSNumber *)[arrayindexes objectAtIndex:x]).integerValue];
         
     }
     
     
     NSMutableArray *ArrayOfArrays = [NSMutableArray array];
     
     unsigned long remainingItems = [TimeTable count];
     unsigned long j = 0;
     
     while (remainingItems) {
         NSRange range = NSMakeRange(j, MIN([NoDups count], remainingItems));
         NSArray *subArray = [TimeTable subarrayWithRange:range];
         [ArrayOfArrays addObject:subArray];
         remainingItems = remainingItems - range.length;
         j = j + range.length;
         
     }
    
     
     [ArrayOfArrays addObject:NoDups];
     
      NSLog(@"Array of Arrays : %@", ArrayOfArrays);
     
     
     NSMutableArray *aryItems = [NSMutableArray new];
     
    
     
     NSRange beginning = [dataString rangeOfString:@"var stops"];
     if (beginning.location != NSNotFound) {
         dataString = [dataString substringFromIndex:beginning.location+beginning.length];
         
         NSRange ending = [dataString rangeOfString:@"</script>"];
         if (ending.location != NSNotFound) {
             dataString = [dataString substringToIndex:ending.location];
             
             for (NSString *line in [dataString componentsSeparatedByString:@"\n"]) {
                 NSMutableDictionary *dictTemp = [NSMutableDictionary new];
                 beginning = [line rangeOfString:@"\""];
                 if (beginning.location != NSNotFound) {
                     NSString *name = [line substringFromIndex:beginning.location+beginning.length];
                     ending = [name rangeOfString:@"\""];
                     if (ending.location != NSNotFound) {
                         name = [name substringToIndex:ending.location];
                         [dictTemp setObject:name forKey:@"name"];
                         beginning = [line rangeOfString:@"\","];
                         if (beginning.location != NSNotFound) {
                             NSString *coordinates = [line substringFromIndex:beginning.location+beginning.length];
                             ending = [coordinates rangeOfString:@",\""];
                             if (ending.location != NSNotFound) {
                                 coordinates = [coordinates substringToIndex:ending.location];
                                 NSArray *aryTemp = [coordinates componentsSeparatedByString:@","];
                                 if ([aryTemp count] == 2) {
                                     [dictTemp setObject:[aryTemp objectAtIndex:0] forKey:@"latitude"];
                                     [dictTemp setObject:[aryTemp objectAtIndex:1] forKey:@"longitude"];
                                 }
                             }
                         }
                     }
                 }
                 [aryItems addObject:dictTemp];
             }
         }
     }
     
     
     NSLog(@"Array Items : %@", aryItems);
     [ArrayOfArrays insertObject:aryItems atIndex:0];
     
     
     if ([_delegate respondsToSelector:@selector(requestHandler:didScrapeSite:)]) [_delegate requestHandler:self didScrapeSite:ArrayOfArrays];
     
     
     
     
     
 }]resume] ;
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
