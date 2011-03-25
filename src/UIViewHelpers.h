//
//  UIViewHelpers.h
//  ClientConnect
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Haneke Design. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UIView ( Helpers )
/**
 Adds a UILabel to the receiver.
 
 @param     frame frame for the new label
 @param     autoResizingMask autoresizing mask for the new label
 
 @returns   pointer to the newly added UILabel.
 */
- (UILabel*)addLabelWithFrame: (CGRect)frame
			 autoResizingMask: (UIViewAutoresizing)autoResizingMask;
@end
