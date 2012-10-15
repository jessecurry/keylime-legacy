//
//  KLAction.h
//  keylime
//
//  Created by Jesse Curry on 4/10/12.
//  Copyright (c) 2012 Haneke Design. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KLAction : NSObject
{
}

@property (nonatomic, retain) 	UIImage*		iconImage;
@property (nonatomic, retain) 	NSString*		title;
@property (nonatomic, retain) 	NSString*		subtitle;
@property (nonatomic, retain) 	UIView*			accessoryView;
@property (nonatomic, assign)   UITableViewCellAccessoryType    accessoryType;
@property (nonatomic, retain)	UIView*			backgroundView;
@property (nonatomic, assign)	CGFloat			cellHeight;
@property (nonatomic, assign)   NSInteger       badgeValue;
@property (nonatomic, readonly) BOOL            isLastAction;

@property (nonatomic, assign) 	id				target;
@property (nonatomic, assign)   SEL             selector;

// Selector Based
+ (id)objectWithIconImage: (UIImage*)iconImage
					title: (NSString*)title
				 subtitle: (NSString*)subtitle
			accessoryView: (UIView*)accessoryView
				   target: (id)target
                 selector: (SEL)selector;
+ (id)objectWithTitle: (NSString*)title
               target: (id)target
             selector: (SEL)selector;

// In case someone wants to use a string
+ (id)objectWithIconImage: (UIImage*)iconImage
					title: (NSString*)title
				 subtitle: (NSString*)subtitle
			accessoryView: (UIView*)accessoryView
				   target: (id)target
             actionString: (NSString*)actionString;
+ (id)objectWithTitle: (NSString*)title
               target: (id)target
         actionString: (NSString*)actionString;

- (void)doAction;
@end
