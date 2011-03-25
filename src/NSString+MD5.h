//
//  NSString+MD5.h
//  keylime
//
//  Created by Jesse Curry on 3/23/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

@interface NSString (NSString_MD5)
/**
 hashes the contents of the receiver.

 @returns   NSString containing the results of an MD5 hash on the receiver.
 */
- (NSString*)MD5String;
@end
