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
	NSManagedObjectContext*	managedObjectContext;
	NSMutableDictionary*	tableData;
	NSMutableDictionary*	searchDisplayControllers;
	NSMutableDictionary*	searchData;
	
	UISearchDisplayController* currentSearchDisplayController;
	
	// TODO: wrap these up into a structure
	// Pull To Refresh
	NSMutableDictionary*			canPullToRefreshDictionary;
	NSMutableDictionary*			refreshHeaderViewDictionary;
	NSMutableDictionary*			checkForRefreshDictionary;
	NSMutableDictionary*			tableViewReloadingDictionary;
	
	UIPopoverController*			popoverController;
}
@property (nonatomic, readonly) NSUserDefaults*			preferences;
@property (nonatomic, retain)	NSManagedObjectContext*	managedObjectContext;
@property (nonatomic, readonly) NSMutableDictionary*	tableData;
@property (nonatomic, readonly)	NSMutableDictionary*	searchDisplayControllers;
@property (nonatomic, readonly) NSMutableDictionary*	searchData;
@property (nonatomic, readonly) NSMutableDictionary*	canPullToRefreshDictionary;
@property (nonatomic, readonly) NSMutableDictionary*	refreshHeaderViewDictionary;
@property (nonatomic, readonly) NSMutableDictionary*	checkForRefreshDictionary;
@property (nonatomic, readonly) NSMutableDictionary*	tableViewReloadingDictionary;

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
- (void)didSelectDataObject: (id<DataObject>)dataObject;

// Search Display Controllers
- (void)setSearchDisplayController: (UISearchDisplayController*)searchDisplayController
					 andSearchData: (KLFetchedResultsSearchData*)theSearchData
					  forTableView: (UITableView*)tableView;

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