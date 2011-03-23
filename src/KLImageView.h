//
//  KLImageView.h
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KLImageView : UIImageView 
{
    NSURL*  imageURL;
}
- (void)loadImageWithURL: (NSURL*)url;
@end
