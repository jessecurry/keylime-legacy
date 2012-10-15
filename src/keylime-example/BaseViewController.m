//
//  BaseViewController.m
//  keylime
//
//  Created by Jesse Curry on 10/15/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BaseViewController
+ (id)controller
{
	id controller = [[[self class] alloc] init];
	if ( controller )
	{
		// Do anything we need to do with a controller
	}
	
	return controller;
}
@end
