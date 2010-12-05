//
//  WebServiceConnector.m
//  ThingsToDo
//
//  Created by Jesse Curry on 6/22/10.
//  Copyright 2010 St. Pete Times. All rights reserved.
//

#import "WebServiceConnector.h"
#import "WebServiceConnectorDelegate.h"

#import "AlertUtility.h"

static BOOL verboseOutput = NO;
static NSInteger connectionCount = 0;

@interface WebServiceConnector ()
@property (nonatomic, retain) NSURLConnection*	urlConnection;
@property (nonatomic, retain) NSMutableData*	receivedData;
@property (nonatomic, readonly) NSString*		webServiceRoot;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation WebServiceConnector
@synthesize tag;
@synthesize context;
@synthesize statusCode;
@synthesize urlConnection;
@synthesize receivedData;

- (id)init
{
	return nil;
}

- (id)initWithURLString: (NSString*)aUrlString
			 parameters: (NSDictionary*)someParameters
			   httpBody: (NSData*)theHttpBody
			   delegate: (id<WebServiceConnectorDelegate>)aDelegate
{
	if ( self = [super init] )
	{
		statusCode = -1; // 
		urlString = [[aUrlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding] retain];
		parameters = [someParameters retain];
		httpBody = [theHttpBody retain];
		delegate = aDelegate;
	}
	return self;
}

- (id)initWithPathString: (NSString*)pathString
			  parameters: (NSDictionary*)theParameters
				httpBody: (NSData*)theHttpBody
				delegate: (id<WebServiceConnectorDelegate>)theDelegate
{
	NSString* generatedUrlString = [self.webServiceRoot stringByAppendingString: pathString];
	return [self initWithURLString: generatedUrlString 
						parameters: theParameters 
						  httpBody: theHttpBody 
						  delegate: theDelegate];
}

- (void)dealloc
{
	[urlString release];
	[parameters release];
	[httpBody release];
	
	[context release];
	
	[urlConnection cancel];
	[urlConnection release];
	[receivedData release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark API
- (void)start
{
	if ( self.urlConnection != nil )
		return;
	
	KL_LOG( @"WebServiceConnector: %@", urlString );

	// Create the request.
	NSURL* url = [NSURL URLWithString: urlString];
	NSMutableURLRequest* theRequest = [NSMutableURLRequest requestWithURL: url
															  cachePolicy: NSURLRequestUseProtocolCachePolicy
														  timeoutInterval: 60.0];
	[theRequest setHTTPBody: httpBody];
	
	// create the connection with the request
	// and start loading the data
	self.urlConnection = [NSURLConnection connectionWithRequest: theRequest 
													   delegate: self];
	if ( self.urlConnection ) 
	{
		// Create the NSMutableData to hold the received data.
		self.receivedData = [NSMutableData data];
		
		// Update the connectionCount
		[[self class] willChangeValueForKey: @"connectionCount"];
		++connectionCount;
		[[self class] didChangeValueForKey: @"connectionCount"];
	} 
	else 
	{
		// Inform the user that the connection failed.
		[delegate webServiceConnector: self 
					 didFailWithError: nil];
		
		[AlertUtility showConnectionErrorAlert];
	}
}

- (void)cancel
{
	[self.urlConnection cancel];
	self.urlConnection = nil;
}

#pragma mark -
#pragma mark Properties
+ (NSInteger)connectionCount
{
	return connectionCount;
}

+ (BOOL)verbose
{
	return verboseOutput;
}

+ (void)setVerbose: (BOOL)verbose
{
	verboseOutput = verbose;
}

- (void)setVerbose: (BOOL)verbose
{
	[[self class] setVerbose: verbose];
}

- (NSString*)webServiceRoot
{
	NSString* webServiceRoot = [[NSUserDefaults standardUserDefaults] valueForKey: @"webServiceRoot"];
	
	// Remove a trailing slash if there is not one.
	if ( [webServiceRoot length]
		&& [[webServiceRoot substringFromIndex: [webServiceRoot length] - 1] isEqual: @"/"] )
	{
		webServiceRoot = [webServiceRoot substringToIndex: [webServiceRoot length] - 1];
	}
	
	return webServiceRoot;
}

#pragma mark -
#pragma mark NSURLConnection Delegate
- (void)connection: (NSURLConnection*)connection 
didReceiveResponse: (NSURLResponse*)response
{
	if ( [response isKindOfClass: [NSHTTPURLResponse class]] )
	{
		statusCode = [(NSHTTPURLResponse*)response statusCode];
		
		if ( verboseOutput )
			KL_LOG( @"(%d) %@", statusCode, urlString );
	}
	else
	{
		statusCode = -1;
	}

	
    [self.receivedData setLength: 0];
}

- (void)connection: (NSURLConnection*)connection 
	didReceiveData: (NSData*)data
{
    // Append the new data to receivedData.
    [receivedData appendData: data];
}

- (void)connection: (NSURLConnection*)connection
  didFailWithError: (NSError*)error
{
    // release the connection
    self.urlConnection = nil;
	self.receivedData = nil;
	
    // inform the user
    KL_LOG(@"Connection failed! Error - %@ %@",
          [error localizedDescription],
          [[error userInfo] objectForKey: NSURLErrorFailingURLStringErrorKey]);
	
	// Update the connectionCount
	[[self class] willChangeValueForKey: @"connectionCount"];
	--connectionCount;
	[[self class] didChangeValueForKey: @"connectionCount"];
	
	[delegate webServiceConnector: self 
				 didFailWithError: error];
	
	[AlertUtility showConnectionErrorAlert];
}

- (void)connectionDidFinishLoading: (NSURLConnection*)connection
{
    KL_LOG(@"Succeeded! Received %d bytes of data", [self.receivedData length]);
		
	NSString* responseString = [[[NSString alloc] initWithData: self.receivedData 
													  encoding: NSUTF8StringEncoding] autorelease];
	
	
    // release the connection, and the data object
    self.urlConnection = nil;
    self.receivedData = nil;
	
	// Update the connectionCount
	[[self class] willChangeValueForKey: @"connectionCount"];
	--connectionCount;
	[[self class] didChangeValueForKey: @"connectionCount"];
	
	if ( [responseString length] )
	{	
		KL_LOG( @"responseString:\n%@", responseString );
		[delegate webServiceConnector: self
				  didFinishWithResult: [responseString JSONValue]];
	}
	else
	{
		[delegate webServiceConnector: self 
				  didFinishWithResult: nil];
	}
}

@end
