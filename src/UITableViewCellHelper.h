//
//  UITableViewCellHelper.h
//  ClientConnect
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Haneke Design. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableViewCell ( Helper )
/**
 Adds a UILabel to the receiver.
 
 @param     frame frame for the new label
 @param     autoResizingMask autoresizing mask for the new label
 
 @returns   pointer to the newly added UILabel.
 */
- (UILabel*)addLabelWithFrame: (CGRect)frame
			 autoResizingMask: (UIViewAutoresizing)autoResizingMask;

/**
 Adds a one pixel tall UIView to the receiver
 
 @param     height the y-value at which to place the rule
 @param     color the background color of the added UIView
 
 @returns   pointer to the newly added UIView.
 */
- (UIView*)addHorizontalRuleAtHeight: (CGFloat)height
						   withColor: (UIColor*)color;

/**
 Adds a one pixel tall lightGray UIView to the receiver
 
 @param     height the y-value at which to place the rule
 
 @returns   pointer to the newly added UIView.
 */
- (UIView*)addHorizontalRuleAtHeight: (CGFloat)height;
@end
