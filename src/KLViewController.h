//
//  KLViewController.h
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

#import "KLRefreshTableHeaderView.h"

@interface KLViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
{
	NSManagedObjectContext*	managedObjectContext;
	NSMutableDictionary*	tableData;
	
	// TODO: wrap these up into a structure
	// Pull To Refresh
	NSMutableDictionary*			canPullToRefreshDictionary;
	NSMutableDictionary*			refreshHeaderViewDictionary;
	NSMutableDictionary*			checkForRefreshDictionary;
	NSMutableDictionary*			tableViewReloadingDictionary;
}
@property (nonatomic, readonly) NSUserDefaults*			preferences;
@property (nonatomic, retain)	NSManagedObjectContext*	managedObjectContext;
@property (nonatomic, readonly) NSMutableDictionary*	tableData;
@property (nonatomic, readonly) NSMutableDictionary*	canPullToRefreshDictionary;
@property (nonatomic, readonly) NSMutableDictionary*	refreshHeaderViewDictionary;
@property (nonatomic, readonly) NSMutableDictionary*	checkForRefreshDictionary;
@property (nonatomic, readonly) NSMutableDictionary*	tableViewReloadingDictionary;

+ (void)setDefaultManagedObjectContext: (NSManagedObjectContext*)defaultManagedObjectContext;

// Table Data
- (void)setTableData: (id)tableData
		forTableView: (UITableView*)tableView;
- (id)dataObjectForIndexPath: (NSIndexPath*)indexPath
				 inTableView: (UITableView*)tableView;

// Pull To Refresh
- (void)enablePullToRefreshForTableView: (UITableView*)tableView;
- (BOOL)tableViewCanPullToRefresh: (UITableView*)tableView;
- (void)setCanPullToRefresh: (BOOL)canPullToRefresh
			   forTableView: (UITableView*)tableView;
- (void)reloadDataSourceForTableView: (UITableView*)tableView;
- (void)dataSourceDidFinishLoadingNewDataForTableView: (UITableView*)tableView;
- (void)showReloadAnimationForTableView: (UITableView*)tableView 
							   animated: (BOOL)animated;

// Display
- (void)updateView;

@end
