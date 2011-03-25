//
//  UIImageKLExtensions.h
//  keylime
//
//  Created by Jesse Curry on 12/16/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIImage ( KLExtensions )
/**
 creates a thumbnail from the receiver
 
 @param     maxSize a CGSize representing the maximum size of the returned thumbnail.
 
 @returns   UIImage constrained to the maxSize.
 */
- (UIImage*)thumbnailWithMaximumSize: (CGSize)maxSize;
@end
