//
//  UITableViewCellHelper.h
//  ClientConnect
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Haneke Design. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UITableViewCell ( Helper )
- (UILabel*)addLabelWithFrame: (CGRect)frame
			 autoResizingMask: (UIViewAutoresizing)autoResizingMask;

- (UIView*)addHorizontalRuleAtHeight: (CGFloat)height
						   withColor: (UIColor*)color;
- (UIView*)addHorizontalRuleAtHeight: (CGFloat)height;
@end
