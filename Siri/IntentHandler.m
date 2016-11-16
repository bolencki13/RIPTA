//
//  IntentHandler.m
//  Siri
//
//  Created by Brian Olencki on 11/10/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "IntentHandler.h"
#import "RPTRequestHandler.h"
#import "RPTLocationManager.h"

typedef void (^Completion)(INListRideOptionsIntentResponse * _Nonnull);

@interface IntentHandler () <INListRideOptionsIntentHandling, INGetRideStatusIntentResponseObserver, RPTRequestHandlerDelegate>
@property (nonatomic, copy) Completion complete;
@property (nonatomic, copy) INListRideOptionsIntent *intent;
@end

@implementation IntentHandler
- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    
    return self;
}

#pragma mark - INListRideOptionsIntentHandling
- (void)handleListRideOptions:(INListRideOptionsIntent *)intent completion:(void (^)(INListRideOptionsIntentResponse * _Nonnull))completion {
    self.intent = intent;
    self.complete = completion;
    
    [[RPTRequestHandler sharedHandler] setDelegate:self];
    [[RPTRequestHandler sharedHandler] getBusses];
}

#pragma mark - RPTRequestHandlerDelegate
- (void)requestHandler:(RPTRequestHandler *)request didFindBusses:(NSArray<RPTBus *> *)busses {
    
    __block NSDictionary *dictBusses;
    dictBusses = @{
                   @"Busses" : [[RPTRequestHandler sharedHandler] orderBusses:busses withLocation:self.intent.pickupLocation.location],
                   };
    self.complete([[INListRideOptionsIntentResponse alloc] initWithCode:INListRideOptionsIntentResponseCodeSuccess userActivity:nil]);
}
- (void)requestHandler:(RPTRequestHandler *)request didNotFindBussesWithError:(NSError *)error {
    self.complete([[INListRideOptionsIntentResponse alloc] initWithCode:INListRideOptionsIntentResponseCodeFailureRequiringAppLaunchServiceTemporarilyUnavailable userActivity:nil]);
}
@end
