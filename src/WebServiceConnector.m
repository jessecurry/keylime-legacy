//
//  WebServiceConnector.m
//  ThingsToDo
//
//  Created by Jesse Curry on 6/22/10.
//  Copyright 2010 St. Pete Times. All rights reserved.
//

#import "WebServiceConnector.h"
#import "WebServiceConnectorDelegate.h"

#import "CJSONDeserializer.h"

static BOOL verboseOutput = NO;
static NSInteger connectionCount = 0;
static NSUInteger maxConnectionCount = 0;
static NSMutableArray* webServiceConnectorQueue = nil;

static NSDictionary* defaultRequestHeaders = nil;


@interface WebServiceConnector ()
@property (nonatomic, retain) NSURLConnection*	urlConnection;
@property (nonatomic, retain) NSMutableData*	receivedData;
@property (nonatomic, readonly) NSString*		webServiceRoot;
@property (nonatomic, readonly) NSString*		webServiceFormatSpecifier;
@property (nonatomic, readonly) NSString*		urlStringWithParameters;

+ (NSMutableArray*)webServiceConnectorQueue;
+ (void)processQueue;
- (void)reallyStart;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation WebServiceConnector
@synthesize parameters;
@synthesize requestHeaderFields;
@synthesize httpBody;
@synthesize httpMethod;
@synthesize delegate;
@synthesize tag;
@synthesize context;
@synthesize statusCode;
@synthesize responseHeaderFields;
@synthesize urlConnection;
@synthesize receivedData;

// Pagination
@synthesize currentPage;
@synthesize numberOfPages;
@synthesize resultsPerPage;

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
		self.parameters = someParameters;
		self.httpBody = theHttpBody;
		self.httpMethod = @"GET";
		self.delegate = aDelegate;
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
	[requestHeaderFields release];
	[httpBody release];
	[httpMethod release];
	
	[context release];
	[responseHeaderFields release];
	
	[urlConnection cancel];
	[urlConnection release];
	[receivedData release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark API
- (void)start
{
    [[WebServiceConnector webServiceConnectorQueue] addObject: self];
    [WebServiceConnector processQueue];
}

- (void)cancel
{
	[self.urlConnection cancel];
	self.urlConnection = nil;
}

#pragma mark -
#pragma mark Private
+ (NSMutableArray*)webServiceConnectorQueue
{
    if ( webServiceConnectorQueue == nil )
    {
        webServiceConnectorQueue = [[NSMutableArray alloc] init];
    }
    return webServiceConnectorQueue;
}

+ (void)processQueue
{    
    // If the maxConnectionCount == 0 we'll assume that no connection queueing is desired.
    if ( ([WebServiceConnector connectionCount] < maxConnectionCount || maxConnectionCount == 0)
        && [[WebServiceConnector webServiceConnectorQueue] count] )
    {
        WebServiceConnector* wsc = [[WebServiceConnector webServiceConnectorQueue] 
                                    objectAtIndex: 0];
        [wsc reallyStart];
        [[WebServiceConnector webServiceConnectorQueue] removeObject: wsc];
    }
}

- (void)reallyStart
{
	if ( self.urlConnection != nil )
		return;
	
	NSString* fullURLString = self.urlStringWithParameters;
	
	KL_LOG( @"WebServiceConnector: %@", fullURLString);
    
	// Create the request.
	NSURL* url = [NSURL URLWithString: fullURLString];
	NSMutableURLRequest* theRequest = [NSMutableURLRequest requestWithURL: url
															  cachePolicy: NSURLRequestUseProtocolCachePolicy
														  timeoutInterval: 60.0];
	
	if ( self.requestHeaderFields )
		[theRequest setAllHTTPHeaderFields: self.requestHeaderFields];
	else
		[theRequest setAllHTTPHeaderFields: defaultRequestHeaders];
	
	[theRequest setHTTPBody: httpBody];
	[theRequest setHTTPMethod: httpMethod];
	
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
		
		startTime = [NSDate timeIntervalSinceReferenceDate]; 
	} 
	else 
	{
		// Inform the user that the connection failed.
		[delegate webServiceConnector: self 
					 didFailWithError: nil];
        
        [WebServiceConnector processQueue]; // since this connection failed we can try to kick off others
	}    
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

+ (void)setDefaultRequestHeaderFields: (NSDictionary*)drc
{
	if ( defaultRequestHeaders != drc )
	{
		[defaultRequestHeaders release];
		defaultRequestHeaders = drc;
		[defaultRequestHeaders retain];
	}
}

- (void)setVerbose: (BOOL)verbose
{
	[[self class] setVerbose: verbose];
}

- (NSString*)webServiceRoot
{
	return [[self class] webServiceRoot];
}

+ (NSString*)webServiceRoot
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

- (NSString*)webServiceFormatSpecifier
{
	return [[self class] webServiceFormatSpecifier];
}

+ (NSString*)webServiceFormatSpecifier
{
	NSString* webServiceFormatSpecifier = [[NSUserDefaults standardUserDefaults] valueForKey: @"webServiceFormatSpecifier"];
	return FORCE_STRING(webServiceFormatSpecifier);
}

#pragma mark -
#pragma mark Connection Queueing
+ (NSInteger)maxConnectionCount
{
    return maxConnectionCount;
}

+ (void)setMaxConnectionCount: (NSInteger)theMaxConnectionCount
{
    maxConnectionCount = theMaxConnectionCount;
}

#pragma -
- (NSString*)urlStringWithParameters
{
	NSString* retStr = urlString;
	
	if ( parameters && [parameters count] )
	{
		NSUInteger parametersAdded = 0;
		for ( NSString* key in parameters )
		{
			retStr = [retStr stringByAppendingFormat: @"%@%@=%@",
					  parametersAdded++ == 0 ? @"?" : @"&",
					  key,
					  [parameters objectForKey: key]];
		}
	}
	
	return retStr;
}

#pragma mark -
#pragma mark NSURLConnection Delegate
- (void)connection: (NSURLConnection*)connection 
didReceiveResponse: (NSURLResponse*)response
{
	if ( [response isKindOfClass: [NSHTTPURLResponse class]] )
	{
		statusCode = [(NSHTTPURLResponse*)response statusCode];
		self.responseHeaderFields = [(NSHTTPURLResponse*)response allHeaderFields];
		
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
    [WebServiceConnector processQueue]; // since this connection failed we can try to kick off others
}

- (void)connectionDidFinishLoading: (NSURLConnection*)connection
{
	responseTime = [NSDate timeIntervalSinceReferenceDate];
	
    //KL_LOG(@"Succeeded! Received %d bytes of data", [self.receivedData length]);
    
	if ( verboseOutput )
	{
		NSString* responseString = [[[NSString alloc] initWithData: self.receivedData 
														  encoding: NSUTF8StringEncoding] autorelease];
		KL_LOG( @"responseString:\n%@", responseString );
	}
	
	NSError* jsonError = nil;
	id jsonResponse = [[CJSONDeserializer deserializer] deserialize: self.receivedData 
															  error: &jsonError];
	
    // release the connection, and the data object
    self.urlConnection = nil;
    self.receivedData = nil;
	
	// Update the connectionCount
	[[self class] willChangeValueForKey: @"connectionCount"];
	--connectionCount;
	[[self class] didChangeValueForKey: @"connectionCount"];
	
	if ( jsonResponse )//[responseString length] )
	{			
		[delegate webServiceConnector: self
				  didFinishWithResult: jsonResponse]; //[responseString JSONValue]];
		
		postParseTime = [NSDate timeIntervalSinceReferenceDate];
	}
	else
	{
		[delegate webServiceConnector: self 
				  didFinishWithResult: nil];
	}
    KL_LOG(@"[%@]response: %.5f - parse: %.5f", urlString, responseTime - startTime, postParseTime - startTime);
    
    [WebServiceConnector processQueue]; // since this connection is done we can try to kick off others
}

@end
