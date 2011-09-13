//
//  NSStringKLExtensions.h
//  TrainerApp
//
//  Created by Jesse Curry on 12/1/09.
//  Copyright 2009 Jesse Curry.. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString ( KLExtensions )
+ (NSString*)stringFromTimeIntervalWithHMS: (NSTimeInterval)timeInterval;
+ (NSString*)stringFromTimeIntervalWithMSH: (NSTimeInterval)timeInterval;
+ (NSString*)stringFromTimeIntervalWithMSt: (NSTimeInterval)timeInterval;

/**
 Returns an NSString 
 
 This method uses [NSString stringWithUTF8String:], but checks for
 NULL first. Newline and whitespace characters are also trimmed.
 
 @param     chars char*
 
 @returns   NSString constructed from the contents of the char* or nil
 */
+ (NSString*)stringWithCharsIfNotNull: (char*)chars;

// Instance
/**
 removes entity references from the receiver.
 
 @returns   NSString with entity references replaced.
 */
- (NSString*)stringByDecodingXMLEntities;


- (BOOL)isNumeric;

@end
