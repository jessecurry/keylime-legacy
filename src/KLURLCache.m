//
//  KLURLCache.m
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "KLURLCache.h"

#ifndef KLURLCACHE_DATA_PATH
#define KLURLCACHE_DATA_PATH @"KLURLCache"
#endif

static NSString* dataPath = nil;
static NSTimeInterval KLURLCacheInterval = 86400.0;

@interface KLURLCache ()
+ (NSString*)filePathForURL: (NSURL*)url;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLURLCache
// Need to make sure that we have a cache directory, and that we know the path to it.
+ (void)initialize
{
    // Create path to cache directory inside the application's Documents directory
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    dataPath = [[[paths objectAtIndex: 0] stringByAppendingPathComponent: KLURLCACHE_DATA_PATH] retain];
    
	// Check for (non)existence of cache directory
	if ( ![[NSFileManager defaultManager] fileExistsAtPath: dataPath] ) 
    {
        // if we don't have one, create it.
        NSError* error = nil;
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath: dataPath
                                        withIntermediateDirectories: NO
                                                         attributes: nil
                                                              error: &error] ) 
        {
            // TODO: post error notification - unable to create cache directory
        }
    }
}

+ (NSData*)contentsOfURL: (NSURL*)url
{
    return nil;
}

+ (void)clearCacheOfURL: (NSURL*)url
{   
    NSString* filePath = [[self class] filePathForURL: url];
    NSError* error = nil;
    if ( ![[NSFileManager defaultManager] removeItemAtPath: filePath 
                                                     error: &error]) 
    {
        // TODO: post error notification - unable to remove file.
    }
}

+ (void)clearCache
{
    // Remove the cache directory and its contents
    NSError* error = nil;
    if ( [[NSFileManager defaultManager] removeItemAtPath: dataPath 
                                                    error: &error]) 
    {
        // Create a new cache directory
        if ( ![[NSFileManager defaultManager] createDirectoryAtPath: dataPath
                                        withIntermediateDirectories: NO
                                                         attributes: nil
                                                              error: &error]) 
        {
            // TODO: post error notification - unable to create new cache directory
        }
    }
    else
    {
        // TODO: post error notification - cache directory doesn't exist.
        return;
    }
}

+ (void)setCacheInterval: (NSTimeInterval)cacheInterval
{
    KLURLCacheInterval = cacheInterval;
}

#pragma mark -
#pragma mark Private
+ (NSString*)filePathForURL: (NSURL*)url
{
    return [[url path] lastPathComponent]; // TODO: use a hash of the URL here.
}

+ (NSDate*)fileModificationDateForFilePath: (NSString*)filePath
{
    NSDate* fileModificationDate = nil;
    if ( [[NSFileManager defaultManager] fileExistsAtPath: filePath] )
    {
        NSError* error = nil;
        NSDictionary* attributes = [[NSFileManager defaultManager] attributesOfItemAtPath: filePath error: &error];
        if ( attributes != nil ) 
        {
			fileModificationDate = [attributes fileModificationDate];
		}
		else 
        {
			// TODO: Post error notification
		}
    }
    
    return fileModificationDate;
}

@end
