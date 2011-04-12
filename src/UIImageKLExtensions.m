//
//  UIImageKLExtensions.m
//  keylime
//
//  Created by Jesse Curry on 12/16/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "UIImageKLExtensions.h"


@implementation UIImage ( KLExtensions )
+ (UIImage*)imageWithColor: (UIColor*)color
{
	CGRect rect = CGRectMake( 0.0f, 0.0f, 1.0f, 1.0f );
	UIGraphicsBeginImageContext( rect.size );
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	CGContextSetFillColorWithColor( context, color.CGColor );
	CGContextFillRect( context, rect );
	
	UIImage* theImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return theImage;
}

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

- (UIImage*)imageWithTint: (UIColor*)theColor
{
	UIGraphicsBeginImageContext( self.size );
	
	CGContextRef ctx = UIGraphicsGetCurrentContext();
	CGRect area = CGRectMake( 0, 0, self.size.width, self.size.height );
	
	CGContextScaleCTM( ctx, 1, -1 );
	CGContextTranslateCTM( ctx, 0, -area.size.height );
	
	CGContextSaveGState( ctx );
	CGContextClipToMask( ctx, area, self.CGImage );
	
	[theColor set];
	CGContextFillRect( ctx, area );
	
	CGContextRestoreGState( ctx );
	
	CGContextSetBlendMode( ctx, kCGBlendModeMultiply );
	
	CGContextDrawImage( ctx, area, self.CGImage );
	
	UIImage* tintedImage = UIGraphicsGetImageFromCurrentImageContext();
	
	UIGraphicsEndImageContext();
	
	return tintedImage;
}

- (UIImage*)imageScaledToSizeWithSameAspectRatio: (CGSize)targetSize
{
	CGSize imageSize = self.size;
	CGFloat width = imageSize.width;
	CGFloat height = imageSize.height;
	CGFloat targetWidth = targetSize.width;
	CGFloat targetHeight = targetSize.height;
	CGFloat scaleFactor = 0.0;
	CGFloat scaledWidth = targetWidth;
	CGFloat scaledHeight = targetHeight;
	CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
	
	if ( CGSizeEqualToSize(imageSize, targetSize) == NO )
	{
		CGFloat widthFactor = targetWidth / width;
		CGFloat heightFactor = targetHeight / height;
		
		if ( widthFactor > heightFactor )
		{
			scaleFactor = widthFactor; // scale to fit height
		}
		else
		{
			scaleFactor = heightFactor; // scale to fit width
		}
		
		scaledWidth  = width * scaleFactor;
		scaledHeight = height * scaleFactor;
		
		// center the image
		if ( widthFactor > heightFactor )
		{
			thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
		}
		else if ( widthFactor < heightFactor )
		{
			thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
		}
	}
	
	CGImageRef imageRef = [self CGImage];
	CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
	CGColorSpaceRef colorSpaceInfo = CGImageGetColorSpace(imageRef);
	
	if ( bitmapInfo == kCGImageAlphaNone )
	{
		bitmapInfo = kCGImageAlphaNoneSkipLast;
	}
	
	CGContextRef bitmap;
	
	if ( self.imageOrientation == UIImageOrientationUp || self.imageOrientation == UIImageOrientationDown )
	{
		bitmap = CGBitmapContextCreate(NULL, targetWidth, targetHeight, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
	}
	else
	{
		bitmap = CGBitmapContextCreate(NULL, targetHeight, targetWidth, CGImageGetBitsPerComponent(imageRef), CGImageGetBytesPerRow(imageRef), colorSpaceInfo, bitmapInfo);
	}
	
	// In the right or left cases, we need to switch scaledWidth and scaledHeight,
	// and also the thumbnail point
	if ( self.imageOrientation == UIImageOrientationLeft )
	{
		thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
		CGFloat oldScaledWidth = scaledWidth;
		scaledWidth = scaledHeight;
		scaledHeight = oldScaledWidth;
		
		CGContextRotateCTM ( bitmap, 1.57079633 );
		CGContextTranslateCTM (bitmap, 0, -targetHeight);
	}
	else if ( self.imageOrientation == UIImageOrientationRight )
	{
		thumbnailPoint = CGPointMake(thumbnailPoint.y, thumbnailPoint.x);
		CGFloat oldScaledWidth = scaledWidth;
		scaledWidth = scaledHeight;
		scaledHeight = oldScaledWidth;
		
		CGContextRotateCTM ( bitmap, -1.57079633 );
		CGContextTranslateCTM (bitmap, -targetWidth, 0);
	}
	else if ( self.imageOrientation == UIImageOrientationUp )
	{
		// NOTHING
	}
	else if ( self.imageOrientation == UIImageOrientationDown )
	{
		CGContextTranslateCTM (bitmap, targetWidth, targetHeight);
		CGContextRotateCTM ( bitmap, -3.14159265 );
	}
	
	CGContextDrawImage(bitmap, CGRectMake(thumbnailPoint.x, thumbnailPoint.y, scaledWidth, scaledHeight), imageRef);
	CGImageRef ref = CGBitmapContextCreateImage(bitmap);
	UIImage* newImage = [UIImage imageWithCGImage: ref];
	
	CGContextRelease(bitmap);
	CGImageRelease(ref);
	
	return newImage;
}

@end
