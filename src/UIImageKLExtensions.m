//
//  UIImageKLExtensions.m
//  keylime
//
//  Created by Jesse Curry on 12/16/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "UIImageKLExtensions.h"


@implementation UIImage ( KLExtensions )
- (UIImage*)thumbnailWithMaximumSize: (CGSize)maxSize
{
    CGSize size = [self size];
	CGFloat wRatio = 0;
	CGFloat hRatio = 0;
	CGFloat ratio = 0;
    
	wRatio = maxSize.width / size.width;
	hRatio = maxSize.height / size.height;
	ratio = MIN( wRatio, hRatio );
	
	CGRect rect = CGRectMake( 0.0, 
							 0.0, 
							 ratio * size.width, 
							 ratio * size.height );
    
    UIGraphicsBeginImageContext( rect.size );
    [self drawInRect: rect];
    
	return UIGraphicsGetImageFromCurrentImageContext();	
}
@end
