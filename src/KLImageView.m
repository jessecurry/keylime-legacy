//
//  KLImageView.m
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "KLImageView.h"

#import "KLURLCache.h"

@interface KLImageView ()
@property (nonatomic, retain) NSURL* imageURL;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLImageView
@synthesize imageURL;

- (void)dealloc
{
    [imageURL release];
    [super dealloc];
}

#pragma -
- (void)loadImageWithURL: (NSURL*)url
{
    self.imageURL = url;
    NSData* imageData = [KLURLCache contentsOfURL: self.imageURL];
    if ( imageData )
    {
        self.image = [UIImage imageWithData: imageData];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] addObserver: self 
                                                 selector: @selector(imageDataAvailable:) 
                                                     name: KLURLCacheDidLoadContentsOfURLNotification 
                                                   object: [KLURLCache class]];
    }
}

#pragma mark -
// TODO: look into more efficiently handling this
- (void)imageDataAvailable: (NSNotification*)notification
{
    if ( [self.imageURL isEqual: [[notification userInfo] objectForKey: KLURLCacheURLKey]] )
    {
        self.image = [UIImage imageWithData: [KLURLCache contentsOfURL: self.imageURL]];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver: self 
                                                    name: KLURLCacheDidLoadContentsOfURLNotification 
                                                  object: [KLURLCache class]];
}

@end
