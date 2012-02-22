//
//  WebServiceConnector.h
//  ThingsToDo
//
//  Created by Jesse Curry on 6/22/10.
//  Copyright 2010 St. Pete Times. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol WebServiceConnectorDelegate;

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface WebServiceConnector : NSObject
{
	id<WebServiceConnectorDelegate>	delegate;
	
	NSString*				urlString;
	NSDictionary*			parameters;
	NSDictionary*			requestHeaderFields;
	NSData*					httpBody;
	NSString*				httpMethod;
	
	NSURLConnection*		urlConnection;
	NSMutableData*			receivedData;
	
	NSInteger				tag;
	id						context;
	
	NSInteger				statusCode;
	NSDictionary*			responseHeaderFields;
	
	NSTimeInterval			startTime;
	NSTimeInterval			responseTime;
	NSTimeInterval			postParseTime;
    
    // Pagination
    NSUInteger              currentPage;
    NSUInteger              numberOfPages;
    NSUInteger              resultsPerPage;
}
@property (nonatomic, retain) NSDictionary* parameters;
@property (nonatomic, retain) NSDictionary* requestHeaderFields;
@property (nonatomic, retain) NSData* httpBody;
@property (nonatomic, retain) NSString* httpMethod;
@property (nonatomic, assign) id<WebServiceConnectorDelegate> delegate;

@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) id context;
@property (nonatomic, readonly) NSInteger statusCode;
@property (nonatomic, retain) NSDictionary* responseHeaderFields;

@property (nonatomic, assign) NSUInteger  currentPage;
@property (nonatomic, assign) NSUInteger  numberOfPages;
@property (nonatomic, assign) NSUInteger  resultsPerPage;

+ (NSInteger)connectionCount;

+ (BOOL)verbose;
+ (void)setVerbose: (BOOL)verbose;

+ (void)setDefaultRequestHeaderFields: (NSDictionary*)defaultRequestHeaders;
+ (NSString*)webServiceRoot;
+ (NSString*)webServiceFormatSpecifier;

// Connection queue
+ (NSInteger)maxConnectionCount;
+ (void)setMaxConnectionCount: (NSInteger)maxConnectionCount;

@property (nonatomic, readonly) NSString*		urlStringWithParameters;

- (id)initWithURLString: (NSString*)urlString
			 parameters: (NSDictionary*)parameters
			   httpBody: (NSData*)httpBody
			   delegate: (id<WebServiceConnectorDelegate>)delegate;
- (id)initWithPathString: (NSString*)pathString
			  parameters: (NSDictionary*)parameters
				httpBody: (NSData*)httpBody
				delegate: (id<WebServiceConnectorDelegate>)delegate;
- (void)start;
- (void)cancel; // TODO: make this more robust
@end