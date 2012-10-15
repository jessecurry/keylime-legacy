//
//  UITableViewCellHelper.m
//  ClientConnect
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Haneke Design. All rights reserved.
//

#import "UITableViewCellHelper.h"
// TODO: setup a designated view and move all of these methods to the UIViewHelper
@implementation UITableViewCell ( Helper )
- (UILabel*)addLabelWithFrame: (CGRect)frame
			 autoResizingMask: (UIViewAutoresizing)autoResizingMask
{
	UILabel* label = [[UILabel alloc] initWithFrame: frame];
	label.autoresizingMask = autoResizingMask;
	label.font = [UIFont systemFontOfSize: 12.0];
	label.backgroundColor = [UIColor clearColor];
	[self.contentView addSubview: label];
	return label;
}

- (UIView*)addHorizontalRuleAtHeight: (CGFloat)height
						   withColor: (UIColor*)color
{
	UIView* rule = [[UIView alloc] initWithFrame: CGRectMake( 0, height, self.frame.size.width, 1.0 )];
	rule.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	rule.backgroundColor = color;
	[self.contentView addSubview: rule];
	return rule;
}

- (UIView*)addHorizontalRuleAtHeight: (CGFloat)height
{
	return [self addHorizontalRuleAtHeight: height
								 withColor: [UIColor lightGrayColor]];
}

@end
