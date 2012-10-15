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

/**
 
 */
@interface KLURLCacheConnection : NSObject 
{    
    Class<KLURLCacheConnectionDelegate>    delegate;
	NSMutableData*                      receivedData;
	NSDate*                             lastModified;
	NSURLConnection*                    connection;
    
    NSURL*                              url;
    NSString*                           filePath;
    id<NSObject>                        context;
}
@property (nonatomic, assign) Class<KLURLCacheConnectionDelegate>  delegate;
@property (nonatomic, strong) NSURLConnection*                  connection;
@property (nonatomic, strong) NSMutableData*                    receivedData;
@property (nonatomic, strong) NSDate*                           lastModified;
@property (nonatomic, readonly, strong) NSURL*                  url;
@property (nonatomic, strong) NSString*                         filePath;
@property (nonatomic, strong) id<NSObject>                      context;

- (id)initWithURL: (NSURL*)theURL 
         delegate: (Class<KLURLCacheConnectionDelegate>)theDelegate;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////

@protocol KLURLCacheConnectionDelegate<NSObject>
+ (void)cacheConnection: (KLURLCacheConnection*)theConnection
       didFailWithError: (NSError*)error;
+ (void)cacheConnectionDidFinish: (KLURLCacheConnection*)theConnection;
@end
