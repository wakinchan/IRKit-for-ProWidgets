//
//  Headers.h
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#define RELEASE(x) [x release], x = nil;

@interface SpringBoard
- (void) launchApplicationWithIdentifier: (NSString*)identifier suspended: (BOOL)suspended;
@end

@interface IRSignals : NSObject
- (id)data;
- (id)init;
- (id)objectAtIndex:(unsigned int)arg1;
- (id)objectInSignalsAtIndex:(unsigned int)arg1;
- (void)loadFromData:(id)arg1;
- (void)setSignals:(id)arg1;
- (id)signals;
- (void)insertObject:(id)arg1 inSignalsAtIndex:(unsigned int)arg2;
- (void)addSignalsObject:(id)arg1;
- (unsigned int)indexOfSignal:(id)arg1;
- (unsigned int)countOfSignals;
- (void)saveToStandardUserDefaultsWithKey:(id)arg1;
- (void)removeObjectFromSignalsAtIndex:(unsigned int)arg1;
- (void)loadFromStandardUserDefaultsKey:(id)arg1;
@end

@interface IRSignal : NSObject
- (id)hostname;
- (void)setFormat:(id)arg1;
- (id)format;
- (void)setHostname:(id)arg1;
- (void)setFrequency:(id)arg1;
- (id)frequency;
- (id)name;
- (void)setName:(id)arg1;
- (void)setData:(id)arg1;
- (id)data;
- (id)initWithDictionary:(id)arg1;
- (id)init;
- (void)encodeWithCoder:(id)arg1;
- (id)initWithCoder:(id)arg1;
- (id)peripheral;
- (id)asPublicDictionary;
- (void)inflateFromDictionary:(id)arg1;
- (id)asDictionary;
- (void)setPeripheral:(id)arg1;
- (id)custom;
- (void)sendWithCompletion:(id)arg1;
- (void)setCustom:(id)arg1;
@end
