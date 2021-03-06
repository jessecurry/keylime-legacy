//
//  KLURLCache.h
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KLURLCacheConnection.h"

extern NSString* const KLURLCacheDidLoadContentsOfURLNotification;
extern NSString* const KLURLCacheURLKey;

/**
 Provides generic caching capabilities.
 
 KLURLCache does not need to be instantiated, all of the methods are class
 methods, all of the functionality is really provided by the file system.
 When a call to contentsOfURL: is made KLURLCache will check to see if 
 a copy of data from that URL exists, if so the file modification date
 is compared to the cache interval. If the file is too old a new copy is 
 fetched; if the file is not too old it is returned from disk.
 When files are downloaded KLURLCache posts notifications to inform
 interested parties of the availability of the file.
 */
@interface KLURLCache : NSObject <KLURLCacheConnectionDelegate>
{    
}
/**
 Returns NSData with contents of the specified URL.
 
 If the cache contains data for the URL it will be returned immediately, if there is no
 cached data available this method will return nil and initiate a request to fetch the data.
 When data has been received a notification will be posted.
 */
+ (NSData*)contentsOfURL: (NSURL*)url;

/**
 Removes cached data for the specified URL.
 */
+ (void)clearCacheOfURL: (NSURL*)url;

/**
 Removes all cached data.
 */
+ (void)clearCache;

/**
 Sets the cache interval to a different value.
 
 The cache interval is used to determine when the URL Cache should check for a new version
 of the cached file.
 */
+ (void)setCacheInterval: (NSTimeInterval)cacheInterval;

@end
