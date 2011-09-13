//
//  UIColor+HexRGB.m
//  keylime
//
//  Created by Jesse Curry on 3/25/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "UIColor+HexRGB.h"


@implementation UIColor (UIColor_HexRGB)
+ (UIColor*)colorWithRGB: (NSUInteger)rgbValue
                   alpha: (CGFloat)alpha
{
    CGFloat red = (((rgbValue & 0xFF0000) >> 16)) / 255.0;
    CGFloat green = (((rgbValue & 0xFF00) >> 8)) / 255.0;
    CGFloat blue = ((rgbValue & 0xFF)) / 255.0;
    
    return (UIColor*)[[self class] colorWithRed: red    
										  green: green
										   blue: blue
										  alpha: alpha];
}

+ (UIColor*)colorWithRGB: (NSUInteger)rgbValue
{
    return [[self class] colorWithRGB: rgbValue
                                alpha: 1.0];
}

@end
