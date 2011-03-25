//
//  KLURLCache.m
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "KLURLCache.h"
#import "NSString+MD5.h"

#ifndef KLURLCACHE_DATA_PATH
#define KLURLCACHE_DATA_PATH @"KLURLCache"
#endif

NSString* const KLURLCacheDidLoadContentsOfURLNotification = @"KLURLCacheDidLoadContentsOfURLNotification";
NSString* const KLURLCacheURLKey = @"KLURLCacheURLKey";

static NSString* dataPath = nil;
static NSTimeInterval KLURLCacheInterval = 86400.0;

@interface KLURLCache ()
+ (NSString*)filePathForURL: (NSURL*)url;
+ (NSDate*)fileModificationDateForFilePath: (NSString*)filePath;
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
    NSData* fileData = nil;

    if ( url )
    {
        NSString* filePath = [[self class] filePathForURL: url];
        
        NSDate* fileDate = [[self class] fileModificationDateForFilePath: filePath];
        /* get the elapsed time since last file update */
        NSTimeInterval time = fabs([fileDate timeIntervalSinceNow]);
        
        if ( time > KLURLCacheInterval ) 
        {
            // file doesn't exist or hasn't been updated since the cache interval
            KLURLCacheConnection* connection = [[KLURLCacheConnection alloc] initWithURL: url 
                                                                                delegate: [self class]];
            connection.filePath = filePath;
             KL_LOG(@"[%@]fetching data for URL: %@", CLASS_NAME, [url absoluteString]);
        }
        else 
        {
            KL_LOG(@"[%@]loading cached data for URL: %@", CLASS_NAME, [url absoluteString]);
            fileData = [NSData dataWithContentsOfFile: filePath];
        }
    }
    
    return fileData;
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
    NSString* filename = [[[url path] lastPathComponent] MD5String];
    NSString* filePath = [dataPath stringByAppendingPathComponent: filename];
    return filePath;
}

+ (NSDate*)fileModificationDateForFilePath: (NSString*)filePath
{
    NSDate* fileModificationDate = [NSDate dateWithTimeIntervalSinceReferenceDate: 0];
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

#pragma mark -
#pragma mark KLURLConnectionDelegate
+ (void)cacheConnection: (KLURLCacheConnection*)theConnection
       didFailWithError: (NSError*)error
{
    NSURL* theURL = theConnection.url;
    
    // Notify interested parties of the (un)availability of the cached image.
    if ( theConnection.url )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: KLURLCacheDidLoadContentsOfURLNotification 
                                                            object: [self class] 
                                                          userInfo: [NSDictionary dictionaryWithObject: theURL 
                                                                                                forKey: KLURLCacheURLKey]];
    }
    
    [theConnection release];
}

+ (void)cacheConnectionDidFinish: (KLURLCacheConnection*)theConnection
{
    NSURL* theURL = theConnection.url;
    NSString* filePath = theConnection.filePath;
    
	if ( [[NSFileManager defaultManager] fileExistsAtPath: filePath] == YES) 
    {
		/* apply the modified date policy */
        
		NSDate* fileDate = [[self class] fileModificationDateForFilePath: filePath];
		NSComparisonResult result = [theConnection.lastModified compare: fileDate];
		if (result == NSOrderedDescending) 
        {
			[[self class] clearCacheOfURL: theURL];
		}
	}
    
	if ( [[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO ) 
    {
		// File doesn't exist, so create it
		[[NSFileManager defaultManager] createFileAtPath: filePath
												contents: theConnection.receivedData
											  attributes: nil];
	}
    // else - cached image is up to date
    
	// reset the file's modification date to indicate that the URL has been checked
	NSDictionary* dict = [[NSDictionary alloc] initWithObjectsAndKeys: [NSDate date], NSFileModificationDate, nil];
	NSError* error = nil;
    if ( ![[NSFileManager defaultManager] setAttributes: dict 
                                           ofItemAtPath: filePath 
                                                  error: &error]) 
    {
		// TODO: post error notification - unable to update file attributes
	}
	[dict release];
    
    // Notify interested parties of the availability of the cached image.
    if ( theURL )
    {
        [[NSNotificationCenter defaultCenter] postNotificationName: KLURLCacheDidLoadContentsOfURLNotification 
                                                            object: [self class] 
                                                          userInfo: [NSDictionary dictionaryWithObject: theURL 
                                                                                                forKey: KLURLCacheURLKey]];
    }
    
    [theConnection release];
}

@end
