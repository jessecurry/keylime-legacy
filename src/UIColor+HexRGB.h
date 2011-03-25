//
//  UIColor+HexRGB.h
//  keylime
//
//  Created by Jesse Curry on 3/25/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIColor (UIColor_HexRGB)
+ (UIColor*)colorWithRGB: (NSUInteger)rgbValue
                   alpha: (CGFloat)alpha;

+ (UIColor*)colorWithRGB: (NSUInteger)rgbValue;
@end
