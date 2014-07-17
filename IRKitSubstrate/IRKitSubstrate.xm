//
//  IRKitSubstrate.xm
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import "../Headers.h"
#import <objcipc/objcipc.h>

static inline UIImage * MakeCornerRoundImage(UIImage *image)
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, 120, 120);
    imageLayer.contents = (id)image.CGImage;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = 25.0f;

    UIGraphicsBeginImageContext(imageLayer.frame.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return roundedImage;
}

static inline __attribute__((constructor)) void init()
{
    @autoreleasepool {
        [OBJCIPC registerIncomingMessageFromSpringBoardHandlerForMessageName:@"IRKitSimple" handler:^NSDictionary *(NSDictionary *dict) {
            NSString *action = dict[@"action"];
            if ([action isEqualToString:@"get_signal"]) {
                IRSignals *_signals = [[%c(IRSignals) alloc] init];
                [_signals loadFromStandardUserDefaultsKey:@"signals"];
                
                NSMutableArray *asDictionary = [NSMutableArray array];
                NSMutableArray *images = [NSMutableArray array];
                for (unsigned int i = 0; i < [_signals countOfSignals]; i++) {
                    IRSignal *_signal =  [_signals objectInSignalsAtIndex:i];
                    asDictionary[i] = [_signal asDictionary];
                    NSString *type = asDictionary[i][@"custom"][@"type"];

                    UIImage *image = [UIImage new];
                    if ([type isEqualToString:@"preset"]) {
                        NSString *name = asDictionary[i][@"custom"][@"name"];
                        image = [UIImage imageNamed:[NSString stringWithFormat:@"btn_icon_120_%@", name]];
                        
                    } else if ([type isEqualToString:@"album"]) {
                        NSString *dir = asDictionary[i][@"custom"][@"dir"];
                        if ([dir hasPrefix:@"/var/mobile/Applications/"]) {
                            dir = [[dir componentsSeparatedByString:@"/"] lastObject];
                        }
                        NSString *path = [NSString stringWithFormat:@"%@/%@/120.png", [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"], dir];
                        image = MakeCornerRoundImage([UIImage imageWithContentsOfFile:path]);
                    }
                    NSData *data = [[[NSData alloc] initWithData:UIImagePNGRepresentation(image)] autorelease];
                    images[i] = data;
                }
                return @{ @"asDictionary" : [asDictionary copy], @"images" : images };

            } else if ([action isEqualToString:@"send_signal"]) {
                IRSignals *_signals = [[%c(IRSignals) alloc] init];
                [_signals loadFromStandardUserDefaultsKey:@"signals"];
                IRSignal *_signal =  [_signals objectInSignalsAtIndex:[dict[@"index"] intValue]];

                [_signal sendWithCompletion:^(NSError *error) {
                    NSLog( @"sent with error: %@", error );
                    return @{ @"success": @(NO) };
                }];
                return @{ @"success": @(YES) };
            }
            
            return nil;
        }];
    }
}