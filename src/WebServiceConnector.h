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
	NSData*					httpBody;
	
	NSURLConnection*		urlConnection;
	NSMutableData*			receivedData;
	
	NSInteger				tag;
	id						context;
	
	NSInteger				statusCode;
}
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, retain) id context;
@property (nonatomic, readonly) NSInteger statusCode;

+ (NSInteger)connectionCount;

+ (BOOL)verbose;
+ (void)setVerbose: (BOOL)verbose;

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