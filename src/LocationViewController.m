//
//  LocationViewController.m
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "LocationViewController.h"

@interface LocationViewController ()
@property (nonatomic, strong) CLLocation* location;
- (void)selectLastAnnotationInMapView: (MKMapView*)mapView;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation LocationViewController
@synthesize location;

+ (id)controllerWithLocation: (CLLocation*)location
{
	id vc = [[[self class] alloc] init];
	if ( vc )
	{
		[vc setLocation: location];
	}

	return vc;
}

#pragma mark -
- (void)dealloc
{
	[locationMapView setDelegate: nil];

}

#pragma mark -
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// Restore user's last selected map type
	NSInteger lastSelectedSegmentIndex = [[[NSUserDefaults standardUserDefaults] valueForKey: kUserPreferenceMapType] integerValue];
	[mapTypeSegmentedControl setSelectedSegmentIndex: lastSelectedSegmentIndex];
	
	[self setMapType: [mapTypeSegmentedControl selectedSegmentIndex]];
	
	if ( self.location )
	{	
		//self.title = self.destination.name;
		//[locationMapView addAnnotation: [KLAnnotation annotationWithDestination: self.destination]];
		//[locationMapView setRegion: MKCoordinateRegionMakeWithDistance( self.location.coordinate, 1000, 1000 )
		//					 animated: YES];
	}
}

- (void)viewWillAppear: (BOOL)animated
{
	[super viewWillAppear: animated];
}

#pragma mark -
#pragma mark IBActions
- (IBAction)mapTypeSelectionDidChange: (id)sender
{
	NSInteger selectedIndex = [mapTypeSegmentedControl selectedSegmentIndex];
	[self setMapType: selectedIndex];
	
	[[NSUserDefaults standardUserDefaults] setValue: [NSNumber numberWithInteger: selectedIndex]
											 forKey: kUserPreferenceMapType];
	
}

- (void)setMapType: (MapType)mapType
{
	switch ( mapType )
	{
		case MapTypeMap:
			[locationMapView setMapType: MKMapTypeStandard];
			break;
		case MapTypeSatellite:
			[locationMapView setMapType: MKMapTypeSatellite];
			break;
		case MapTypeHybrid:
		default:
			[locationMapView setMapType: MKMapTypeHybrid];
			break;
	}
}

- (void)selectLastAnnotationInMapView: (MKMapView*)mapView
{
	if ( [mapView.annotations count] )
	{
		[mapView selectAnnotation: [mapView.annotations lastObject]
						 animated: YES];
	}
}

#pragma mark -
#pragma mark MKMapViewDelegate
- (void)mapView: (MKMapView*)mapView didAddAnnotationViews: (NSArray*)views
{
	[self performSelector: @selector(selectLastAnnotationInMapView:) 
			   withObject: mapView 
			   afterDelay: 0.5];
}

@end
