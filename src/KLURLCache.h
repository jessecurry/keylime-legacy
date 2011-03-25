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
 
 KLURLCache does not need to be intantiated, all of the methods are class
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
 
 */
+ (NSData*)contentsOfURL: (NSURL*)url;
+ (void)clearCacheOfURL: (NSURL*)url;
+ (void)clearCache;

+ (void)setCacheInterval: (NSTimeInterval)cacheInterval;

@end
