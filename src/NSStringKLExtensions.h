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

+ (NSString*)stringWithCharsIfNotNull: (char*)chars;

// Instance
- (NSString*)stringByDecodingXMLEntities;
@end
