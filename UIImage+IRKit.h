//
//  UIImage+IRKit.h
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (IRKit)

- (UIImage *)makeCornerRoundImage;
- (UIImage *)makeThumbnailOfSize:(CGSize)size;

@end