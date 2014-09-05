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

@interface SBApplication
- (NSBundle *)bundle;
- (NSString *)displayName;
- (id)containerPath;
- (id)path;
@end

@interface SBApplicationController
+ (id)sharedInstance;
- (id)allApplications;
- (id)allDisplayIdentifiers;
- (SBApplication *)applicationWithDisplayIdentifier:(id)displayIdentifier;
@end

@interface CUICommonAssetStorage
- (id)allAssetKeys;
- (id)allRenditionNames;
@end

@interface CUIStructuredThemeStore
- (CUICommonAssetStorage *)themeStore;
@end

@interface CUICatalog
- (CUIStructuredThemeStore *)_themeStore;
@end

@interface _UIAssetManager
+ (_UIAssetManager *)assetManagerForBundle:(NSBundle *)bundle;
- (CUICatalog *)_catalog;
- (UIImage *)imageNamed:(NSString *)name;
@end

@interface UIImage (Private)
+ (UIImage *)_applicationIconImageForBundleIdentifier:(NSString *)bundleIdentifier format:(int)format scale:(CGFloat)scale;
@end

@interface IRSignals : NSObject
- (id)data;
- (id)init;
- (id)objectAtIndex:(unsigned int)index;
- (id)objectInSignalsAtIndex:(unsigned int)index;
- (void)loadFromData:(id)data;
- (void)setSignals:(id)signals;
- (id)signals;
- (void)insertObject:(id)object inSignalsAtIndex:(unsigned int)index;
- (void)addSignalsObject:(id)object;
- (unsigned int)indexOfSignal:(id)signal;
- (unsigned int)countOfSignals;
- (void)saveToStandardUserDefaultsWithKey:(id)key;
- (void)removeObjectFromSignalsAtIndex:(unsigned int)index;
- (void)loadFromStandardUserDefaultsKey:(id)key;
@end

@interface IRSignal : NSObject
- (id)hostname;
- (void)setFormat:(id)format;
- (id)format;
- (void)setHostname:(id)hostname;
- (void)setFrequency:(id)frequency;
- (id)frequency;
- (id)name;
- (void)setName:(id)name;
- (void)setData:(id)data;
- (id)data;
- (id)initWithDictionary:(id)dictonary;
- (id)init;
- (void)encodeWithCoder:(id)coder;
- (id)initWithCoder:(id)coder;
- (id)peripheral;
- (id)asPublicDictionary;
- (void)inflateFromDictionary:(id)dictonary;
- (id)asDictionary;
- (void)setPeripheral:(id)peripheral;
- (id)custom;
- (void)sendWithCompletion:(id)completion;
- (void)setCustom:(id)custom;
@end
