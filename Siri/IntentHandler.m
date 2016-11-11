//
//  IntentHandler.m
//  Siri
//
//  Created by Brian Olencki on 11/10/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "IntentHandler.h"

@interface IntentHandler () <INListRideOptionsIntentHandling, INGetRideStatusIntentResponseObserver>

@end

@implementation IntentHandler
- (id)handlerForIntent:(INIntent *)intent {
    // This is the default implementation.  If you want different objects to handle different intents,
    // you can override this and return the handler you want for that particular intent.
    
    return self;
}

#pragma mark - INListRideOptionsIntentHandling
- (void)handleListRideOptions:(INListRideOptionsIntent *)intent completion:(void (^)(INListRideOptionsIntentResponse * _Nonnull))completion {

}
@end
