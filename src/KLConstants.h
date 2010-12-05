/*
 *  KLConstants.h
 *  keylime
 *
 *  Created by Jesse Curry on 12/5/10.
 *  Copyright 2010 Jesse Curry. All rights reserved.
 *
 */

#pragma mark -
#pragma mark UITableView
static const CGFloat kTableViewHeaderHeight = 20.0;
static const CGFloat kTableViewHeaderInset = 2.0;
static const CGFloat kTableViewHeaderFontSize = 14.0;

#pragma mark -
#pragma mark MKMapView
typedef enum _MapType
{
	MapTypeNone = -1,
	MapTypeMap,
	MapTypeSatellite,
	MapTypeHybrid,
	MapTypeCount
} MapType;

static NSString* const kUserPreferenceMapType = @"kUserPreferenceMapType";