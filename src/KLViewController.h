//
//  KLViewController.h
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// Protocols
#import "DataObject.h"

// Views
#import "KLRefreshTableHeaderView.h"
#import "KLTableViewCell.h"
#import "KLFetchedResultsSearchData.h"

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KLViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, UIPopoverControllerDelegate, UISearchDisplayDelegate>
{
	NSMutableDictionary*	tableData;
	NSMutableDictionary*	searchDisplayControllers;
	NSMutableDictionary*	searchData;
	
	UISearchDisplayController* currentSearchDisplayController;
	
	// TODO: wrap these up into a structure
	// Pull To Refresh
	NSMutableDictionary*			_canPullToRefreshDictionary;
	NSMutableDictionary*			_refreshHeaderViewDictionary;
	NSMutableDictionary*			_checkForRefreshDictionary;
	NSMutableDictionary*			_tableViewReloadingDictionary;
}
@property (unsafe_unretained, nonatomic, readonly) NSUserDefaults*			preferences;
@property (nonatomic, strong)	NSManagedObjectContext*	managedObjectContext;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary*	tableData;
@property (unsafe_unretained, nonatomic, readonly)	NSMutableDictionary*	searchDisplayControllers;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary*	searchData;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary*	canPullToRefreshDictionary;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary*	refreshHeaderViewDictionary;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary*	checkForRefreshDictionary;
@property (unsafe_unretained, nonatomic, readonly) NSMutableDictionary*	tableViewReloadingDictionary;
@property (nonatomic, assign)   BOOL                    hidesNavigationBarWhenPushed;
@property (nonatomic, assign) UIView*       keyboardContainerView; // NOTE: this will not be retained, it should point to a retained view

/**
 Returns an autoreleased UIViewController instance.
 */
+ (id)controller;

/**
 Returns an autoreleased UIViewController instance with the managedObjectContext set.
 */
+ (id)controllerWithManagedObjectContext: (NSManagedObjectContext*)managedObjectContext;

- (void)addKeyValueObservers;
- (void)removeKeyValueObservers;
- (void)addNotificationObservers;
- (void)removeNotificationObservers;

// Core Data
+ (void)setDefaultManagedObjectContext: (NSManagedObjectContext*)defaultManagedObjectContext;

// Table Data
- (void)setTableData: (id)tableData
		forTableView: (UITableView*)tableView;
- (void)setTableData: (id)theTableData
		forTableView: (UITableView*)tableView
	  monitorChanges: (BOOL)monitorChanges;
- (void)fetchDataForTableView: (UITableView*)tableView;
- (id)tableDataForTableView: (UITableView*)tableView;
- (void)removeTableDataForTableView: (UITableView*)tableView;
- (id)dataObjectForIndexPath: (NSIndexPath*)indexPath
				 inTableView: (UITableView*)tableView;

- (void)tableView: (UITableView*)tableView didSelectDataObject: (id<DataObject>)dataObject forRowAtIndexPath: (NSIndexPath*)indexPath;
- (void)didSelectDataObject: (id<DataObject>)dataObject DEPRECATED_ATTRIBUTE;

// Search Display Controllers
- (void)setSearchDisplayController: (UISearchDisplayController*)searchDisplayController
					 andSearchData: (KLFetchedResultsSearchData*)theSearchData
					  forTableView: (UITableView*)tableView;

// Pull To Refresh
- (void)enablePullToRefreshForTableView: (UITableView*)tableView;
- (KLRefreshTableHeaderView*)refreshHeaderViewForTableView: (UITableView*)tableView;
- (BOOL)tableViewCanPullToRefresh: (UITableView*)tableView;
- (void)setCanPullToRefresh: (BOOL)canPullToRefresh
			   forTableView: (UITableView*)tableView;
- (void)reloadDataSourceForTableView: (UITableView*)tableView;
- (void)dataSourceDidFinishLoadingNewDataForTableView: (UITableView*)tableView;
- (void)showReloadAnimationForTableView: (UITableView*)tableView 
							   animated: (BOOL)animated;

// Display
- (void)updateView;

// Data
- (void)reloadData;

// Popovers
- (void)presentPopover: (UIViewController*)viewController 
			  fromRect:	(CGRect)rect 
permittedArrowDirections: (UIPopoverArrowDirection)arrowDirections 
			  animated: (BOOL)animated;
- (void)presentPopover: (UIViewController*)viewController
	 fromBarButtonItem: (UIBarButtonItem *)item 
permittedArrowDirections: (UIPopoverArrowDirection)arrowDirections 
			  animated: (BOOL)animated;
- (void)dismissPopoverAnimated: (BOOL)animated;

@end