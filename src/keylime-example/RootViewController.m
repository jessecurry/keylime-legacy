//
//  RootViewController.m
//  keylime
//
//  Created by Jesse Curry on 10/15/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import "RootViewController.h"

@interface RootViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation RootViewController
@synthesize tableView=_tableView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	NSArray* sampleData = @[@"One", @"Two", @"Three"];
	[self setTableData: sampleData
		  forTableView: self.tableView];
}

#pragma mark -
- (void)didSelectDataObject: (id<DataObject>)dataObject
{
	if ( [dataObject isKindOfClass: [NSString class]] )
	{
		NSString* str = (NSString*)dataObject;
		
		[AlertUtility showAlertWithTitle: NSLocalizedString(@"You Selected", @"UIAlertView Title")
								 message: str];
	}
	else
	{
		[super didSelectDataObject: dataObject];
	}
}

@end
