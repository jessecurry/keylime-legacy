//
//  LocationViewController.h
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationViewController : KLViewController <MKMapViewDelegate>
{
	CLLocation*						location;
	
	IBOutlet MKMapView*				locationMapView;
	IBOutlet UISegmentedControl*	mapTypeSegmentedControl;
}

+ (id)controllerWithLocation: (CLLocation*)location;

// 
- (IBAction)mapTypeSelectionDidChange: (id)sender;

- (void)setMapType: (MapType)mapType;
@end
