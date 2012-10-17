//
//  KLURLCacheConnection.m
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "KLURLCacheConnection.h"

@interface KLURLCacheConnection ()
@property (nonatomic, strong) NSURL* url;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLURLCacheConnection
@synthesize delegate;
@synthesize receivedData;
@synthesize lastModified;
@synthesize connection;
@synthesize url;
@synthesize filePath;
@synthesize context;

/* This method initiates the load request. The connection is asynchronous,
 and we implement a set of delegate methods that act as callbacks during
 the load. */
- (id)initWithURL: (NSURL*)theURL 
         delegate: (Class<KLURLCacheConnectionDelegate>)theDelegate
{
	if ( (self = [super init]) ) 
    {
        self.url = theURL;
		self.delegate = theDelegate;
        
		/* Create the request. This application does not use a NSURLCache
		 disk or memory cache, so our cache policy is to satisfy the request
		 by loading the data from its source. */
		NSURLRequest* theRequest = [NSURLRequest requestWithURL: theURL
													cachePolicy: NSURLRequestReloadIgnoringLocalCacheData
												timeoutInterval: 60];
        
		/* Create the connection with the request and start loading the
		 data. The connection object is owned both by the creator and the
		 loading system. */
        
		self.connection = [NSURLConnection connectionWithRequest: theRequest 
                                                        delegate: self];
		if ( self.connection == nil ) 
        {
			/* inform the user that the connection failed */
			// TODO: post error to delegate
		}
	}
    
	return self;
}


#pragma mark -
#pragma mark NSURLConnectionDelegate methods
- (void)connection: (NSURLConnection*)connection 
didReceiveResponse: (NSURLResponse*)response
{
    /* This method is called when the server has determined that it has
	 enough information to create the NSURLResponse. It can be called
	 multiple times, for example in the case of a redirect, so each time
	 we reset the data capacity. */
    
	/* create the NSMutableData instance that will hold the received data */
	long long contentLength = [response expectedContentLength];
	if ( contentLength == NSURLResponseUnknownLength ) 
    {
		contentLength = 500000;
	}
	self.receivedData = [NSMutableData dataWithCapacity: (NSUInteger)contentLength];
    
	/* Try to retrieve last modified date from HTTP header. If found, format
	 date so it matches format of cached image file modification date. */
	if ( [response isKindOfClass: [NSHTTPURLResponse self]] ) 
    {
		NSDictionary* headers = [(NSHTTPURLResponse*)response allHeaderFields];
		NSString* modified = [headers objectForKey: @"Last-Modified"];
		if (modified) 
        {
			NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
            
			/* avoid problem if the user's locale is incompatible with HTTP-style dates */
			[dateFormatter setLocale: [[NSLocale alloc] initWithLocaleIdentifier: @"en_US_POSIX"]];
            
			[dateFormatter setDateFormat: @"EEE, dd MMM yyyy HH:mm:ss zzz"];
			self.lastModified = [dateFormatter dateFromString: modified];
		}
		else 
        {
			/* default if last modified date doesn't exist (not an error) */
			self.lastModified = [NSDate dateWithTimeIntervalSinceReferenceDate: 0];
		}
	}
}

- (void)connection:(NSURLConnection*)connection didReceiveData: (NSData*)data
{
    /* Append the new data to the received data. */
    [self.receivedData appendData: data];
}

- (void)connection: (NSURLConnection*)connection 
  didFailWithError: (NSError*)error
{
    KL_LOG(@"[%@]connection:didFailWithError: %@", CLASS_NAME, [error localizedDescription]);
	[self.delegate cacheConnection: self 
                  didFailWithError: error];
}

- (NSCachedURLResponse*)connection: (NSURLConnection*)connection
                 willCacheResponse: (NSCachedURLResponse*)cachedResponse
{
	/* this application does not use a NSURLCache disk or memory cache */
    return nil;
}

- (void)connectionDidFinishLoading: (NSURLConnection*)connection
{
    KL_LOG(@"[%@]connectionDidFinishLoading:", CLASS_NAME);
	[self.delegate cacheConnectionDidFinish: self];
}


@end
