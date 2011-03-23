//
//  KLURLCache.h
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KLURLCache : NSObject 
{    
}
+ (NSData*)contentsOfURL: (NSURL*)url;
+ (void)clearCacheOfURL: (NSURL*)url;
+ (void)clearCache;

+ (void)setCacheInterval: (NSTimeInterval)cacheInterval;

@end
