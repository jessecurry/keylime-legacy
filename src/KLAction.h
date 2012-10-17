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

@property (nonatomic, strong) 	UIImage*		iconImage;
@property (nonatomic, strong) 	NSString*		title;
@property (nonatomic, strong) 	NSString*		subtitle;
@property (nonatomic, strong) 	UIView*			accessoryView;
@property (nonatomic, assign)   UITableViewCellAccessoryType    accessoryType;
@property (nonatomic, strong)	UIView*			backgroundView;
@property (nonatomic, assign)	CGFloat			cellHeight;
@property (nonatomic, assign)   NSInteger       badgeValue;
@property (nonatomic, readonly) BOOL            isLastAction;

@property (nonatomic, unsafe_unretained) 	id				target;
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
