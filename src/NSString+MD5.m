//
//  NSString+MD5.m
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import "NSString+MD5.h"


@implementation NSString (NSString_MD5)
//generate md5 hash from string
- (NSString*)MD5String
{
    const char* concat_str = [self UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(concat_str, strlen(concat_str), result);
    
    NSMutableString* hash = [NSMutableString string];
    for ( int i = 0; i < 16; ++i )
        [hash appendFormat: @"%02X", result[i]];

    return [hash lowercaseString];
}

@end
