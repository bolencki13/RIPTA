//
//  RPTRequestHandler.h
//  RIPTA
//
//  Created by Brian Olencki on 10/27/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RPTRequestHandler, RPTBus;
@protocol RPTRequestHandlerDelegate <NSObject>
@optional
- (void)requestHandler:(RPTRequestHandler*)request didFindBus:(NSArray <RPTBus *> *)busses;
- (void)requestHandler:(RPTRequestHandler*)request didNotFindBussesWithError:(NSError *)error;
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
@end
