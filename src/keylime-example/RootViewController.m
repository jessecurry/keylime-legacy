//
//  RootViewController.m
//  keylime
//
//  Created by Jesse Curry on 10/15/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import "RootViewController.h"

#define WEB_SERVICE_URL_STRING @"https://twitter.com/users/jesseleecurry.json"

//
#import "WebServiceConnectorDelegate.h"

#import "HTTPStatusCodes.h"

@interface RootViewController () <WebServiceConnectorDelegate>

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
#pragma mark IBActions
- (IBAction)webServiceTestAction: (id)sender
{
	WebServiceConnector* wsc = [[WebServiceConnector alloc] initWithURLString: WEB_SERVICE_URL_STRING
																   parameters: nil
																	 httpBody: nil
																	 delegate: self];
	
	if ( wsc )
	{
		KL_LOG(@"[%@]starting web service connector", CLASS_NAME);
		wsc.httpMethod = HTTP_GET;
		[wsc start];
	}
	else
	{
		[AlertUtility showAlertWithTitle: NSLocalizedString(@"Error", @"UIAlertView title")
								 message: NSLocalizedString(@"There was an error creating the web service connector.", @"UIAlertView message")];
	}
}

#pragma mark -
- (void)didSelectDataObject: (id<DataObject>)dataObject
{
	if ( [dataObject isKindOfClass: [NSString class]] )
	{
		NSString* str = (NSString*)dataObject;
		
		[AlertUtility showAlertWithTitle: NSLocalizedString(@"You Selected", @"UIAlertView title")
								 message: str];
	}
	else
	{
		[super didSelectDataObject: dataObject];
	}
}

#pragma mark -
#pragma mark WebServiceConnectorDelegate
- (void)webServiceConnector: (WebServiceConnector*)webServiceConnector
        didFinishWithResult: (id)result;
{
    // Check for errors
    NSInteger statusCode = webServiceConnector.statusCode;
	if ( statusCode == HTTP_STATUS_UNAUTHORIZED || statusCode == HTTP_STATUS_FORBIDDEN )
	{
        [AlertUtility showAlertWithTitle: NSLocalizedString(@"Server Error", @"UIAlertView title")
                                 message: NSLocalizedString(@"Your connection was not authorized.", @"")];
	}
    else if ( statusCode == HTTP_STATUS_INTERNAL_SERVER_ERROR )
    {
        [AlertUtility showAlertWithTitle: NSLocalizedString(@"Server Error", @"UIAlertView title")
                                 message: NSLocalizedString(@"There was an internal server error, please try your request again later.", @"")];
    }
	else
	{
        KL_LOG(@"[%@]webServiceConnector:didFinishWithResult:\n%@", CLASS_NAME, result);
		NSDictionary* resultDict = SAFE_DICTIONARY(result);
		NSMutableArray* dataArray = [NSMutableArray array];
		
		// Step through all of the results, looking for strings
		for ( NSString* key in resultDict )
		{
			NSString* str = SAFE_STRING([resultDict objectForKey: key]);
			
			if ( str )
				[dataArray addObject: str];
		}
		
		// If we have some data, update the tableView
		if ( [dataArray count] )
		{
			[self setTableData: dataArray
				  forTableView: self.tableView];
			
			[self.tableView reloadData];
		}
    }
}

- (void)webServiceConnector: (WebServiceConnector*)webServiceConnector
           didFailWithError: (NSError*)error
{
    KL_LOG(@"[%@]webServiceConnector:didFailWithError: %@", CLASS_NAME, [error localizedDescription]);

}

@end
