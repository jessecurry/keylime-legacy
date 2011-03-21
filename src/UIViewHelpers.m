//
//  UIViewHelpers.m
//  ClientConnect
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Haneke Design. All rights reserved.
//

#import "UIViewHelpers.h"


@implementation UIView ( Helpers )
- (UILabel*)addLabelWithFrame: (CGRect)frame
			 autoResizingMask: (UIViewAutoresizing)autoResizingMask
{
	UILabel* label = [[UILabel alloc] initWithFrame: frame];
	label.autoresizingMask = autoResizingMask;
	[self addSubview: label];
	[label release];
	return label;
}
@end
