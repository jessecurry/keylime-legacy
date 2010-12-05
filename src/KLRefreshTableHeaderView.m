//
//  KLRefreshTableHeaderView.m
//  keylime-iphone
//
//  Created by Jesse Curry on 7/17/10.
//  Copyright 2010 Circonda, Inc. All rights reserved.
//

#import "KLRefreshTableHeaderView.h"
#import <QuartzCore/QuartzCore.h>

#define TEXT_COLOR [UIColor colorWithRed: 1.0 green: 1.0 blue: 1.0 alpha: 1.0]
#define BORDER_COLOR [UIColor colorWithRed: 0.1 green: 0.1 blue: 0.1 alpha: 1.0]

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLRefreshTableHeaderView
@synthesize borderColor;
@synthesize isFlipped;
@synthesize lastUpdatedDate;

- (id)initWithFrame: (CGRect)frame
{
	if ( self = [super initWithFrame: frame] )
	{
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		self.borderColor = BORDER_COLOR;
		self.backgroundColor = [UIColor colorWithRed: 0 / 255.0
											   green: 117 / 255.0 
												blue: 192 / 255.0 
											   alpha: 1.0];

		lastUpdatedLabel = [[UILabel alloc] initWithFrame: 
							CGRectMake(0.0f, frame.size.height - 30.0f, 320.0f, 20.0f)];
		lastUpdatedLabel.font = [UIFont systemFontOfSize: 12.0f];
		lastUpdatedLabel.textColor = TEXT_COLOR;
		lastUpdatedLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		lastUpdatedLabel.backgroundColor = [UIColor clearColor]; //self.backgroundColor;
		lastUpdatedLabel.opaque = YES;
		lastUpdatedLabel.textAlignment = UITextAlignmentCenter;
		lastUpdatedLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		[self addSubview: lastUpdatedLabel];
		[lastUpdatedLabel release];

		statusLabel = [[UILabel alloc] initWithFrame: CGRectMake(0.0f,
																 frame.size.height - 48.0f, 
																 320.0f, 
																 20.0f)];
		statusLabel.font = [UIFont boldSystemFontOfSize: 13.0f];
		statusLabel.textColor = TEXT_COLOR;
		statusLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
		statusLabel.backgroundColor = [UIColor clearColor]; //self.backgroundColor;
		statusLabel.opaque = YES;
		statusLabel.textAlignment = UITextAlignmentCenter;
		statusLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		
		[self setStatus: KLRefreshTableHeaderViewStatusPullToReload];
		[self addSubview: statusLabel];
		[statusLabel release];

		arrowImageView = [[UIImageView alloc] initWithFrame:
		              CGRectMake(25.0f, frame.size.height - 65.0f, 30.0f, 55.0f)];
		arrowImageView.contentMode = UIViewContentModeScaleAspectFit;
		arrowImageView.image = [UIImage imageNamed: @"refreshArrow.png"];
		[arrowImageView layer].transform = CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f);
		[self addSubview: arrowImageView];
		[arrowImageView release];

		activityView = [[UIActivityIndicatorView alloc] 
						initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleWhite];
		activityView.frame = CGRectMake(25.0f, frame.size.height - 38.0f, 20.0f, 20.0f);
		activityView.hidesWhenStopped = YES;
		[self addSubview: activityView];
		[activityView release];

		isFlipped = NO;
	}
	return self;
}

- (void)dealloc
{
	activityView = nil;
	statusLabel = nil;
	arrowImageView = nil;
	lastUpdatedLabel = nil;
	
	[borderColor release];
	
	[super dealloc];
}

#pragma mark -
- (void)willMoveToSuperview: (UIView*)newSuperview
{
	[super willMoveToSuperview: newSuperview];
	
	// Resize Width
	self.frame = CGRectMake( self.frame.origin.x, 
							self.frame.origin.y, 
							newSuperview.frame.size.width, 
							self.frame.size.height );
}

#pragma mark -
- (void)drawRect: (CGRect)rect
{
	CGContextRef context = UIGraphicsGetCurrentContext();
	CGContextDrawPath(context, kCGPathFillStroke);
	[self.borderColor setStroke];
	CGContextBeginPath(context);
	CGContextMoveToPoint(context, 0.0f, self.bounds.size.height - 1);
	CGContextAddLineToPoint(context, self.bounds.size.width, self.bounds.size.height - 1);
	CGContextStrokePath(context);
}

- (void)flipImageAnimated: (BOOL)animated
{
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: animated ? 0.18 : 0.0];
	[arrowImageView layer].transform = isFlipped 
	? CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f) 
	: CATransform3DMakeRotation(M_PI * 2, 0.0f, 0.0f, 1.0f);
	[UIView commitAnimations];

	isFlipped = !isFlipped;
}

- (void)setLastUpdatedDate: (NSDate*)newDate
{
	if ( newDate )
	{
		if ( lastUpdatedDate != newDate )
		{
			[lastUpdatedDate release];
		}

		lastUpdatedDate = [newDate retain];

		NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
		[formatter setDateStyle: NSDateFormatterShortStyle];
		[formatter setTimeStyle: NSDateFormatterShortStyle];
		lastUpdatedLabel.text = [NSString stringWithFormat:
		                         @"Last Updated: %@", [formatter stringFromDate: lastUpdatedDate]];
		[formatter release];
	}
	else
	{
		lastUpdatedDate = nil;
		lastUpdatedLabel.text = @"Last Updated: Never";
	}
}

- (void)setStatus: (KLRefreshTableHeaderViewStatus)status
{
	switch ( status )
	{
	case KLRefreshTableHeaderViewStatusReleaseToReload:
		statusLabel.text = NSLocalizedString(@"Release to refresh...", @"Refreshable Table Header Status Label");
		break;
	case KLRefreshTableHeaderViewStatusPullToReload:
		statusLabel.text = NSLocalizedString(@"Pull down to refresh...", @"Refreshable Table Header Status Label");
		break;
	case KLRefreshTableHeaderViewStatusLoading:
		statusLabel.text = NSLocalizedString(@"Loading...", @"Refreshable Table Header Status Label");
		break;
	default:
		break;
	}
}

- (void)toggleActivityView: (BOOL)isOn
{
	if ( isOn )
	{
		[activityView startAnimating];
		arrowImageView.hidden = YES;
		[self setStatus: KLRefreshTableHeaderViewStatusLoading];
	}
	else
	{
		[activityView stopAnimating];
		arrowImageView.hidden = NO;
	}
}

#pragma mark -
#pragma mark Properties
- (UIColor*)textColor
{
	// Note, the accuracy here depends on setTextColor always setting both colors
	return lastUpdatedLabel.textColor;
}

- (void)setTextColor: (UIColor*)textColor
{
	lastUpdatedLabel.textColor = textColor;
	statusLabel.textColor = textColor;
}

- (UIColor*)shadowColor
{
	return lastUpdatedLabel.shadowColor;
}

- (void)setShadowColor: (UIColor*)shadowColor
{
	lastUpdatedLabel.shadowColor = shadowColor;
	statusLabel.shadowColor = shadowColor;
}

- (UIImage*)arrowImage
{
	return arrowImageView.image;
}

- (void)setArrowImage: (UIImage*)arrowImage
{
	arrowImageView.image = arrowImage;
}

@end
