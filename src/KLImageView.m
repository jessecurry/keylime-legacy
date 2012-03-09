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
@synthesize failureImage=_failureImage;
@synthesize imageURL;

- (void)dealloc
{
    self.failureImage = nil;
    [imageURL release];
    
	[[NSNotificationCenter defaultCenter] removeObserver: self];
    [super dealloc];
}

#pragma -
- (void)loadImageWithURL: (NSURL*)url
{
    self.imageURL = url;
    
    if ( self.imageURL )
    {
        NSData* imageData = [KLURLCache contentsOfURL: self.imageURL];
        UIImage* imageFromData = [UIImage imageWithData: imageData];
        if ( imageFromData )
        {
            self.image = imageFromData;
        }
        else
        {
//            self.image = self.failureImage; // Do nothing for now
//            [KLURLCache clearCacheOfURL: self.imageURL];
            
            [[NSNotificationCenter defaultCenter] addObserver: self 
                                                     selector: @selector(imageDataAvailable:) 
                                                         name: KLURLCacheDidLoadContentsOfURLNotification 
                                                       object: [KLURLCache class]];
        }
    }
    else
    {
        self.image = self.failureImage;
    }
}

#pragma mark -
// TODO: look into more efficiently handling this
- (void)imageDataAvailable: (NSNotification*)notification
{
    if ( [self.imageURL isEqual: [[notification userInfo] objectForKey: KLURLCacheURLKey]] )
    {
        UIImage* returnedImage = [UIImage imageWithData: [KLURLCache contentsOfURL: self.imageURL]];
        if ( returnedImage )
        {
            self.image = returnedImage;
        }
        else // no image data returned
        {
            if ( self.failureImage )
                self.image = self.failureImage;
            // else - leave the current .image property alone.
            
            // Make sure our cache is clear
            [KLURLCache clearCacheOfURL: self.imageURL];
        }
        
        [[NSNotificationCenter defaultCenter] removeObserver: self 
                                                        name: KLURLCacheDidLoadContentsOfURLNotification 
                                                      object: [KLURLCache class]];
    }
}

@end
