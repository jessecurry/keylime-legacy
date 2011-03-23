//
//  KLURLCacheConnection.h
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

// Mostly stolen from Apple Sample Code.

#import <Foundation/Foundation.h>

@protocol KLURLCacheConnectionDelegate;
@interface KLURLCacheConnection : NSObject 
{    
    id<KLURLCacheConnectionDelegate>    delegate;
	NSMutableData*                      receivedData;
	NSDate*                             lastModified;
	NSURLConnection*                    connection;
}
@property (nonatomic, assign) id<KLURLCacheConnectionDelegate>  delegate;
@property (nonatomic, retain) NSURLConnection*                  connection;
@property (nonatomic, retain) NSMutableData*                    receivedData;
@property (nonatomic, retain) NSDate*                           lastModified;

- (id)initWithURL: (NSURL*)theURL 
         delegate: (id<KLURLCacheConnectionDelegate>)theDelegate;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol KLURLCacheConnectionDelegate<NSObject>
- (void)connection: (KLURLCacheConnection*)theConnection
  didFailWithError: (NSError*)error;
- (void)connectionDidFinish: (KLURLCacheConnection*)theConnection;
@end
