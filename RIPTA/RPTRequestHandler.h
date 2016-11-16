//
//  RPTRequestHandler.h
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CLLocation.h>

@class RPTRequestHandler, RPTBus;
@protocol RPTRequestHandlerDelegate <NSObject>
@optional
- (void)requestHandler:(RPTRequestHandler*)request didFindBusses:(NSArray <RPTBus *> *)busses;
- (void)requestHandler:(RPTRequestHandler*)request didNotFindBussesWithError:(NSError *)error;
- (void)requestHandler:(RPTRequestHandler *)request didScrapeSite:(NSArray *)siteInfo;

@end

@interface RPTRequestHandler : NSObject
@property (nonatomic, retain) id<RPTRequestHandlerDelegate> delegate;
/*
 * SharedHandler to be used at all times
 *
 */
+ (RPTRequestHandler*)sharedHandler;

/*
 * Method used to get busses
 *
 */
- (void)getBusses;
<<<<<<< HEAD
- (void)getSiteInfo:(NSString *)RTNum;


=======

/*
 * Method used to order busses
 *
 */
- (NSArray <RPTBus *> *)orderBusses:(NSArray <RPTBus *> *)busses byMethod:(NSComparisonResult (^)(RPTBus *bus1, RPTBus *bus2))method;

/*
 * Method used to order busses based on location
 *
 */
- (NSArray <RPTBus *> *)orderBusses:(NSArray <RPTBus *> *)busses withLocation:(CLLocation*)coordinate;

/*
 * Method used to get bus schedule
 *
 */
- (void)getScheduleForBusWithRoute:(NSString*)route;
>>>>>>> 4d6e5921e7d3cb10c31b84cd51d1fef335cf1637
@end
