//
//  KLRefreshTableHeaderView.h
//  keylime-iphone
//
//  Created by Jesse Curry on 7/17/10.
//  Copyright 2010 Circonda, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _ViewStatus
{
	KLRefreshTableHeaderViewStatusReleaseToReload,
	KLRefreshTableHeaderViewStatusPullToReload,
	KLRefreshTableHeaderViewStatusLoading,
	KLRefreshTableHeaderViewStatusCount
} KLRefreshTableHeaderViewStatus;

@interface KLRefreshTableHeaderView : UIView
{
	UILabel*					lastUpdatedLabel;
	UILabel*					statusLabel;
	UIImageView*				arrowImageView;
	UIActivityIndicatorView*	activityView;
	UIColor*					borderColor;

	BOOL						isFlipped;

	NSDate*						lastUpdatedDate;
}
@property (nonatomic, assign) BOOL		isFlipped;
@property (nonatomic, retain) NSDate*	lastUpdatedDate;

@property (nonatomic, retain) UIColor*	textColor;
@property (nonatomic, retain) UIColor*	shadowColor;
@property (nonatomic, retain) UIColor*	borderColor;
@property (nonatomic, retain) UIImage*	arrowImage;

- (void)flipImageAnimated: (BOOL)animated;
- (void)toggleActivityView: (BOOL)isOn;
- (void)setStatus: (KLRefreshTableHeaderViewStatus)status;

@end
