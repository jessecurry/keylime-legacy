//
//  NSStringKLExtensions.m
//  TrainerApp
//
//  Created by Jesse Curry on 12/1/09.
//  Copyright 2009 Jesse Curry.. All rights reserved.
//

#import "NSStringKLExtensions.h"


@implementation NSString ( KLExtensions )
+ (NSString*)stringFromTimeIntervalWithHMS: (NSTimeInterval)timeInterval
{
	return [NSString stringWithFormat: @"%02d:%02d:%02d", 
			(int)(timeInterval / 3600),			// Hours
			((int)timeInterval % 3600) / 60,	// Minutes
			(int)timeInterval % 60];			// Seconds
}

+ (NSString*)stringFromTimeIntervalWithMSH: (NSTimeInterval)timeInterval
{
	return [NSString stringWithFormat: @"%02d:%02d:%02d", 
			((int)timeInterval % 3600) / 60,	// Minutes
			(int)timeInterval % 60,				// Seconds
			(int)(timeInterval * 100) % 100];	// Hundreths
}

+ (NSString*)stringFromTimeIntervalWithMSt: (NSTimeInterval)timeInterval
{
	return [NSString stringWithFormat: @"%02d:%02d.%01d", 
			((int)timeInterval % 3600) / 60,	// Minutes
			(int)timeInterval % 60,				// Seconds
			(int)(timeInterval * 10) % 10];		// Tenths
}

#pragma mark -
+ (NSString*)stringWithCharsIfNotNull: (char*)chars
{
	if ( chars == NULL )
		return nil;
	else
		return [[NSString stringWithUTF8String: chars] 
				stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

#pragma mark -
#pragma mark Instance
- (NSString*)stringByDecodingXMLEntities
{
	NSUInteger myLength = [self length];
	NSUInteger ampIndex = [self rangeOfString: @"&" options: NSLiteralSearch].location;
	
	// Short-circuit if there are no ampersands.
	if ( ampIndex == NSNotFound )
	{
		return self;
	}
	
	// Make result string with some extra capacity.
	NSMutableString* result = [NSMutableString stringWithCapacity: (myLength * 1.25)];
	
	// First iteration doesn't need to scan to & since we did that already, but for code simplicity's sake we'll do it again with the scanner.
	NSScanner* scanner = [NSScanner scannerWithString: self];
	
	[scanner setCharactersToBeSkipped: nil];
	
	NSCharacterSet* boundaryCharacterSet = [NSCharacterSet characterSetWithCharactersInString: @" \t\n\r;"];
	
	do
	{
		// Scan up to the next entity or the end of the string.
		NSString* nonEntityString;
		if ( [scanner scanUpToString: @"&" intoString: &nonEntityString] )
		{
			[result appendString: nonEntityString];
		}
		
		if ( [scanner isAtEnd] )
		{
			return result;
		}
		
		// Scan either a HTML or numeric character entity reference.
		if ( [scanner scanString: @"&amp;" intoString: NULL] ) 
			[result appendString: @"&"];
		else if ( [scanner scanString: @"&apos;" intoString: NULL] ) 
			[result appendString: @"'"];
		else if ( [scanner scanString: @"&quot;" intoString: NULL] ) 
			[result appendString: @"\""];
		else if ( [scanner scanString: @"&lt;" intoString: NULL] ) 
			[result appendString: @"<"];
		else if ( [scanner scanString: @"&gt;" intoString: NULL] ) 
			[result appendString: @">"];
		else if ( [scanner scanString: @"&nbsp;" intoString: NULL] )
			[result appendString: @" "];
		else if ( [scanner scanString: @"&mdash;" intoString: NULL] )
			[result appendString: @"–"];
		else if ( [scanner scanString: @"&#" intoString: NULL] )
		{
			BOOL gotNumber;
			unsigned charCode;
			NSString* xForHex = @"";
			
			// Is it hex or decimal?
			if ( [scanner scanString: @"x" intoString: &xForHex] )
			{
				gotNumber = [scanner scanHexInt: &charCode];
			}
			else
			{
				gotNumber = [scanner scanInt: (int*)&charCode];
			}
			
			if ( gotNumber )
			{
				[result appendFormat: @"%C", charCode];
				
				[scanner scanString: @";" intoString: NULL];
			}
			else
			{
				NSString* unknownEntity = @"";
				
				[scanner scanUpToCharactersFromSet: boundaryCharacterSet intoString: &unknownEntity];
				
				[result appendFormat: @"&#%@%@", xForHex, unknownEntity];
				
				//[scanner scanUpToString:@";" intoString:&unknownEntity];
				//[result appendFormat:@"&#%@%@;", xForHex, unknownEntity];
				KL_LOG(@"Expected numeric character entity but got &#%@%@;", xForHex, unknownEntity);
			}
		}
		else
		{
			NSString* amp;
			
			[scanner scanString: @"&" intoString: &amp];      //an isolated & symbol
			[result appendString: amp];
			
			/*
			 NSString *unknownEntity = @"";
			 [scanner scanUpToString:@";" intoString:&unknownEntity];
			 NSString *semicolon = @"";
			 [scanner scanString:@";" intoString:&semicolon];
			 [result appendFormat:@"%@%@", unknownEntity, semicolon];
			 KL_LOG(@"Unsupported XML character entity %@%@", unknownEntity, semicolon);
			 */
		}
	} while ( ![scanner isAtEnd] );
	
	return result;
}

@end
