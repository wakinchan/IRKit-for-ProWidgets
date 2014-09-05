//
//  IRKitSubstrate.xm
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

+%config(generator=internal)

#import "../Headers.h"
#import <objcipc/objcipc.h>

static inline __attribute__((constructor)) void init()
{
    @autoreleasepool {
        [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"IRKitSimple" handler:^NSDictionary *(NSDictionary *dict) {
            NSString *action = dict[@"action"];
            if ([action isEqualToString:@"get_signal"]) {
                IRSignals *signals = [[%c(IRSignals) alloc] init];
                [signals loadFromStandardUserDefaultsKey:@"signals"];

                NSMutableArray *data = [NSMutableArray array];
                for (unsigned int index = 0; index < [signals countOfSignals]; index++) {
                    IRSignal *signal =  [signals objectInSignalsAtIndex:index];
                    data[index] = [signal asDictionary];
                }
                return @{ @"dict": [data copy] };

            } else if ([action isEqualToString:@"send_signal"]) {
                IRSignals *signals = [[%c(IRSignals) alloc] init];
                [signals loadFromStandardUserDefaultsKey:@"signals"];
                IRSignal *signal =  [signals objectInSignalsAtIndex:[dict[@"index"] intValue]];

                [signal sendWithCompletion:^(NSError *error) {
                    NSLog( @"sent with error: %@", error );
                    return @{ @"success": @(NO) };
                }];
                return @{ @"success": @(YES) };
            }
            
            return nil;
        }];
    }
}