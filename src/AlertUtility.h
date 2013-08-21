//
//  AlertUtility.h
//  ThingsToDo
//
//  Created by Jesse Curry on 8/27/10.
//  Copyright 2010 keylime. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 Utility class for cleaning up the display of simple UIAlertViews.
 */
@interface AlertUtility : NSObject <UIAlertViewDelegate>
{
}

+ (void)showAlertWithTitle: (NSString*)title message: (NSString*)message;
+ (void)showConnectionErrorAlert;
+ (void)showDatabaseErrorAlert;
@end
