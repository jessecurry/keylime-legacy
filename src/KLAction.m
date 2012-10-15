//
//  KLAction.m
//  keylime
//
//  Created by Jesse Curry on 4/10/12.
//  Copyright (c) 2012 Haneke Design. All rights reserved.
//

#import "KLAction.h"

static KLAction* _lastAction = nil;

@implementation KLAction
@synthesize iconImage=_iconImage;
@synthesize title=_title;
@synthesize subtitle=_subtitle;
@synthesize accessoryView=_accessoryView;
@synthesize accessoryType=_accessoryType;
@synthesize backgroundView=_backgroundView;
@synthesize cellHeight=_cellHeight;
@synthesize badgeValue=_badgeValue;

@synthesize target=_target;
@synthesize selector=_selector;

+ (id)objectWithIconImage: (UIImage*)iconImage
					title: (NSString*)title
				 subtitle: (NSString*)subtitle
			accessoryView: (UIView*)accessoryView
				   target: (id)target
                 selector: (SEL)selector
{
	id ao = [[[self class] alloc] init];
	if ( ao )
	{
		[ao setIconImage: iconImage];
		[ao setTitle: title];
		[ao setSubtitle: subtitle];
		[ao setAccessoryView: accessoryView];
        [ao setAccessoryType: UITableViewCellAccessoryDisclosureIndicator];
		[ao setTarget: target];
		[ao setSelector: selector];
		[ao setCellHeight: 44.0];
	}
	return ao;
}

+ (id)objectWithTitle: (NSString*)title
               target: (id)target
             selector: (SEL)selector
{
	return [[self class] objectWithIconImage: nil
									   title: title
									subtitle: nil
							   accessoryView: nil
									  target: target
                                    selector: selector];
}

+ (id)objectWithIconImage: (UIImage*)iconImage
					title: (NSString*)title
				 subtitle: (NSString*)subtitle
			accessoryView: (UIView*)accessoryView
				   target: (id)target
             actionString: (NSString*)actionString
{
	return [[self class] objectWithIconImage: iconImage
									   title: title
									subtitle: subtitle
							   accessoryView: accessoryView
									  target: target
                                    selector: NSSelectorFromString(actionString)];
}

+ (id)objectWithTitle: (NSString*)title
               target: (id)target
         actionString: (NSString*)actionString
{
	return [[self class] objectWithIconImage: nil
									   title: title
									subtitle: nil
							   accessoryView: nil
									  target: target
                                actionString: actionString];
}

#pragma mark -
- (void)dealloc
{
	self.selector = NULL;
	
}

#pragma mark -
- (void)doAction
{
	if ( self.selector )
	{	
		if ( [self.target respondsToSelector: self.selector] )
		{	
            [self.target performSelector: self.selector 
                              withObject: self];

            _lastAction = self;
        }
		else
        {
			KL_LOG( @"WARNING: %@ does not respond to %@", 
				  NSStringFromClass([self.target class]), 
				  NSStringFromSelector(self.selector) );
        }
	}
	else
	{
		KL_LOG( @"WARNING: no selector" );	
	}
}

- (BOOL)isLastAction
{
    BOOL isLastAction = (self == _lastAction);
    return isLastAction;
}

#pragma mark -
+ (UITableViewCell*)tableViewCell
{
    // JLC: need the reuse identifier here so cells are dequeued properly
	return [[[[self class] tableViewCellClass] alloc] initWithStyle: UITableViewCellStyleSubtitle 
                                                     reuseIdentifier: [[self class] tableViewCellIdentifier]];
}

@end
