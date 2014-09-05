//
//  UIImage+IRKit.m
//  IRKit for ProWidgets
//
//  Created by kinda on 15.04.2014.
//  Copyright (c) 2014 kinda. All rights reserved.
//

@implementation UIImage (IRKit)

- (UIImage *)makeThumbnailOfSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, UIScreen.mainScreen.scale);
    // draw scaled image into thumbnail context
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *newThumbnail = UIGraphicsGetImageFromCurrentImageContext();        
    // pop the context
    UIGraphicsEndImageContext();
    
    return newThumbnail;
}

- (UIImage *)makeCornerRoundImage
{
    CALayer *imageLayer = [CALayer layer];
    imageLayer.frame = CGRectMake(0, 0, 120, 120);
    imageLayer.contents = (id)self.CGImage;
    imageLayer.masksToBounds = YES;
    imageLayer.cornerRadius = 25.0f;

    UIGraphicsBeginImageContext(imageLayer.frame.size);
    [imageLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *roundedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return roundedImage;
}

@end