//
//  KLTableViewCell.m
//  keylime
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "KLTableViewCell.h"
#import "DataObject.h"

@implementation KLTableViewCell
@synthesize dataObject;
+ (CGFloat)cellHeightWithDataObject: (id)theDataObject
{
    return 44.0;
}

#pragma mark -
- (id)initWithStyle: (UITableViewCellStyle)style reuseIdentifier: (NSString*)reuseIdentifier
{
	self = [super initWithStyle: style reuseIdentifier: reuseIdentifier];
	if ( self )
	{
		self.backgroundView = [[[UIImageView alloc] initWithImage:
								[UIImage imageNamed: @"activityCellBackground.png"]] autorelease];
	}
	return self;
}

- (void)dealloc
{
	[dataObject release], dataObject = nil;
	
	[super dealloc];
}

#pragma mark -
#pragma mark API
- (void)configureWithDataObject: (id)theDataObject
{
	//KL_LOG(@"[%@]configureWithDataObject: %@", NSStringFromClass([self class]), NSStringFromClass([theDataObject class]));
	self.dataObject = theDataObject;
}

#pragma mark -
#pragma mark Properties
- (CGFloat)cellHeight
{
	return [[self class] cellHeightWithDataObject: self.dataObject];
}

#pragma mark -
- (void)setSelected: (BOOL)selected animated: (BOOL)animated
{
	[super setSelected: selected animated: animated];

	// Configure the view for the selected state.
}

@end
