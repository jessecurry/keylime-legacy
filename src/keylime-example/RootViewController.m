//
//  RootViewController.m
//  keylime
//
//  Created by Jesse Curry on 10/15/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import "RootViewController.h"

#define WEB_SERVICE_URL_STRING @"https://twitter.com/users/jesseleecurry.json"
#define USE_COMPLETION_HANLDER  1

//
#import "WebServiceConnectorDelegate.h"

#import "HTTPStatusCodes.h"

@interface RootViewController () <WebServiceConnectorDelegate>
- (void)handleWebServiceConnector: (WebServiceConnector*)webServiceConnector
                           result: (id)result;
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
    
    [self enablePullToRefreshForTableView: self.tableView];
}

#pragma mark -
#pragma mark IBActions
- (IBAction)webServiceTestAction: (id)sender
{
#if USE_COMPLETION_HANLDER
    WebServiceConnector* wsc = [[WebServiceConnector alloc] initWithURLString: WEB_SERVICE_URL_STRING
																   parameters: nil
																	 httpBody: nil
                                                            completionHandler: ^(WebServiceConnector* wsc, id result, NSError* error){
                                                                if ( result )
                                                                {
                                                                    [self handleWebServiceConnector: wsc
                                                                                             result: result];
                                                                }
                                                                else // Error
                                                                {
                                                                    [AlertUtility showAlertWithTitle: NSLocalizedString(@"Connection Error", @"UIAlertView title")
                                                                                             message: [error localizedDescription]];
                                                                }
                                                            }];
#else
	WebServiceConnector* wsc = [[WebServiceConnector alloc] initWithURLString: WEB_SERVICE_URL_STRING
																   parameters: nil
																	 httpBody: nil
																	 delegate: self];    
#endif
	
	if ( wsc )
	{
		wsc.httpMethod = HTTP_GET;
		[wsc start];   // starts or queues the web service connector
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
		NSString* message = (NSString*)dataObject;
		
		[AlertUtility showAlertWithTitle: NSLocalizedString(@"You Selected", @"UIAlertView title")
								 message: message];
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
    [self handleWebServiceConnector: webServiceConnector
                             result: result];
}

- (void)webServiceConnector: (WebServiceConnector*)webServiceConnector
           didFailWithError: (NSError*)error
{
    KL_LOG(@"[%@]webServiceConnector:didFailWithError: %@", CLASS_NAME, [error localizedDescription]);

}

#pragma mark -
#pragma mark Private
- (void)handleWebServiceConnector: (WebServiceConnector*)webServiceConnector
                           result: (id)result
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

@end
