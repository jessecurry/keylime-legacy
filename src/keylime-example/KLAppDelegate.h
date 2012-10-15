//
//  KLAppDelegate.h
//  keylime-example
//
//  Created by Jesse Curry on 10/15/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KLAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
