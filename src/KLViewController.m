//
//  KLViewController.m
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "KLViewController.h"

#import "KLFetchedResultsSearchData.h"
#import "KLTableData.h"

static NSManagedObjectContext* defaultManagedObjectContext = nil;

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation UINavigationBar (CustomImage)
//- (void)drawRect: (CGRect)rect 
//{
//	UIImage* image = [UIImage imageNamed: @"NavigationBarBackground.png"];
//	[image drawInRect: CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
//}
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KLViewController ()
@property (nonatomic, retain) UIPopoverController* popoverController;
- (NSString*)dictionaryKeyForView: (UIView*)theView;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLViewController
@synthesize managedObjectContext;
@synthesize popoverController;
@synthesize hidesNavigationBarWhenPushed=_hidesNavigationBarWhenPushed;

+ (void)setDefaultManagedObjectContext: (NSManagedObjectContext*)defaultMoC
{
	// Probably no need to retain this.
	defaultManagedObjectContext = defaultMoC;
}

#pragma mark -
- (void)dealloc
{
	for ( NSString* key in tableData )
	{
		id value = [tableData objectForKey: key];
		if ( [value isKindOfClass: [NSFetchedResultsController class]] )
			[value setDelegate: nil];
	}
	
	[tableData release];
	[searchDisplayControllers release];
	[searchData release];
	[canPullToRefreshDictionary release];
	[refreshHeaderViewDictionary release];
	[checkForRefreshDictionary release];
	[tableViewReloadingDictionary release];
	
    //	if ( popoverController.popoverVisible )
    //		[self dismissPopoverAnimated: NO];
	[popoverController release];
	
	[super dealloc];
}

#pragma mark -
- (void)viewDidLoad
{
	[super viewDidLoad];
}

- (void)viewWillAppear: (BOOL)animated
{
    [super viewWillAppear: animated];
    
    [self.navigationController setNavigationBarHidden: self.hidesNavigationBarWhenPushed 
                                             animated: animated];
}

- (void)viewWillDisappear: (BOOL)animated
{
	[super viewWillDisappear: animated];
	
	if ( popoverController.popoverVisible )
		[self dismissPopoverAnimated: YES];
}

- (BOOL)shouldAutorotateToInterfaceOrientation: (UIInterfaceOrientation)interfaceOrientation
{
	return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)didReceiveMemoryWarning
{
	// Releases the view if it doesn't have a superview.
	[super didReceiveMemoryWarning];
    
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload
{
	[super viewDidUnload];
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}

#pragma mark -
#pragma mark Properties
- (NSUserDefaults*)preferences
{
	return [NSUserDefaults standardUserDefaults];
}

- (NSManagedObjectContext*)managedObjectContext
{
	// Allows managedObjectContext to be overridden on a per view controller basis.
	return managedObjectContext ? managedObjectContext : defaultManagedObjectContext;
}

- (NSMutableDictionary*)tableData // consider moving this to viewDidLoad -- downside memory use, upside no nil check
{
	if ( tableData == nil )
	{
		tableData = [[NSMutableDictionary alloc] init];
	}
	return tableData;
}

- (NSMutableDictionary*)searchDisplayControllers
{
	if ( searchDisplayControllers == nil )
	{
		searchDisplayControllers = [[NSMutableDictionary alloc] init];
	}
	return searchDisplayControllers;
}

- (NSMutableDictionary*)searchData
{
	if ( searchData == nil )
	{
		searchData = [[NSMutableDictionary alloc] init];
	}
	return searchData;
}

- (NSMutableDictionary*)canPullToRefreshDictionary
{
	if ( canPullToRefreshDictionary == nil )
	{
		canPullToRefreshDictionary = [[NSMutableDictionary alloc] init];
	}
	return canPullToRefreshDictionary;
}

- (NSMutableDictionary*)refreshHeaderViewDictionary
{
	if ( refreshHeaderViewDictionary == nil )
	{
		refreshHeaderViewDictionary = [[NSMutableDictionary alloc] init];
	}
	return refreshHeaderViewDictionary;
}

- (NSMutableDictionary*)checkForRefreshDictionary
{
	if ( checkForRefreshDictionary == nil )
	{
		checkForRefreshDictionary = [[NSMutableDictionary alloc] init];
	}
	return checkForRefreshDictionary;
}

- (NSMutableDictionary*)tableViewReloadingDictionary
{
	if ( tableViewReloadingDictionary == nil )
	{
		tableViewReloadingDictionary = [[NSMutableDictionary alloc] init];
	}
	return tableViewReloadingDictionary;
}

#pragma mark -
- (void)setTableData: (id)theTableData
		forTableView: (UITableView*)tableView
{
	[self setTableData: theTableData 
		  forTableView: tableView 
		monitorChanges: YES];
}

- (void)setTableData: (id)theTableData
		forTableView: (UITableView*)tableView
	  monitorChanges: (BOOL)monitorChanges
{
	if ( theTableData == nil )
	{	
		KL_LOG(@"[%@] WARNING: attempted to set nil tableData", NSStringFromClass([self class]));
		return;
	}
	
	[self.tableData setObject: theTableData 
					   forKey: [self dictionaryKeyForView: tableView]];
	
	if ( [theTableData isKindOfClass: [NSFetchedResultsController class]] )
	{	
		NSFetchedResultsController* frc = (NSFetchedResultsController*)theTableData;
		
		// JLC: for now only fetchedResultsControllers can monitor changes.
		if ( monitorChanges )
			[frc setDelegate: self];
        
		NSError* error = nil;
		[NSFetchedResultsController deleteCacheWithName: frc.cacheName];
		if ( ![frc performFetch: &error] ) 
		{
			KL_LOG( @"[%@]Unresolved error %@, %@", [[self class] description], error, [error userInfo] );
		}
		else
		{
			KL_LOG(@"[%@]loaded %d objects", CLASS_NAME, [frc.fetchedObjects count]);
		}
	}
	
	tableView.dataSource = self;
    tableView.delegate = self; // TODO: do I need to set this here? Or should I set it elsewhere?
}

- (void)fetchDataForTableView: (UITableView*)tableView
{
	id theTableData = [self tableDataForTableView: tableView];
	
	if ( [theTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = (NSFetchedResultsController*)theTableData;
        //		KL_LOG(@"[%@]fetchDataForTableView - %d", 
        //			   CLASS_NAME, 
        //			   [frc.fetchedObjects count]);
		
		// JLC: was resetting the delegate here, but it shouldn't be necessary
		//	if we wanted to monitor changes the delegate should aready be set
		
		NSError* error = nil;
		[NSFetchedResultsController deleteCacheWithName: frc.cacheName];
		if ( ![frc performFetch: &error] ) 
		{
			KL_LOG( @"[%@]Unresolved error %@, %@", [[self class] description], error, [error userInfo] );
		};
	}
	[tableView reloadData];
}

- (id)tableDataForTableView: (UITableView*)tableView
{
	id theTableData = [self.tableData objectForKey: [self dictionaryKeyForView: tableView]];
	if ( theTableData == nil )
	{
		// TODO: All of this needs to be thought out, pretty messy right now.
		// Key is the key for the tableView that the search bar lives in.
		for ( NSString* key in self.searchDisplayControllers )
		{
			UISearchDisplayController* sdc = [self.searchDisplayControllers objectForKey: key];
			if ( sdc.searchResultsTableView == tableView )
			{
				KLFetchedResultsSearchData* sd = [self.searchData objectForKey: key];
				
				id td = [self.tableData objectForKey: key];
				if ( [td isKindOfClass: [NSFetchedResultsController class]] )
					[sd updateDataSource: [td fetchedObjects]];
				
				[sd updateSearchString: sdc.searchBar.text];
				
				theTableData = sd.searchResults;
			}
		}
	}
	return theTableData;
}

- (void)removeTableDataForTableView: (UITableView*)tableView
{
	[self.tableData	removeObjectForKey: [self dictionaryKeyForView: tableView]];
}

- (id)dataObjectForIndexPath: (NSIndexPath*)indexPath inTableView: (UITableView*)tableView
{	
	id dataObject = nil;
	
	// Find the data for the current tableView
	id currentTableData = [self tableDataForTableView: tableView];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		dataObject = [(NSFetchedResultsController*)currentTableData objectAtIndexPath: indexPath];
	}
	else if ( [currentTableData isKindOfClass: [KLTableData class]] )
	{
		dataObject = [(KLTableData*)currentTableData dataObjectForIndexPath: indexPath];
	}
	else if ( [currentTableData isKindOfClass: [NSArray class]] )
	{
		dataObject = [(NSArray*)currentTableData objectAtIndex: indexPath.row];
	}
	else if ( [currentTableData isKindOfClass: [NSString class]] )
	{
		dataObject = currentTableData; // TODO: this will disappear later
	}
	else
	{
		dataObject = NSLocalizedString(@"No table data found.", @"");
	}
	
	return dataObject;
}

- (void)didSelectDataObject: (id<DataObject>)dataObject
{
}

#pragma mark -
#pragma mark Search Display Controllers
- (void)setSearchDisplayController: (UISearchDisplayController*)theSearchDisplayController
					 andSearchData: (KLFetchedResultsSearchData*)theSearchData
					  forTableView: (UITableView*)tableView
{
	if ( theSearchDisplayController == nil 
		|| theSearchData == nil )
	{	
		KL_LOG(@"[%@] WARNING: attempted to set nil searchDisplayController/searchData", NSStringFromClass([self class]));
		return;
	}
	
	[self.searchDisplayControllers setObject: theSearchDisplayController 
									  forKey: [self dictionaryKeyForView: tableView]];
	[self.searchData setObject: theSearchData 
						forKey: [self dictionaryKeyForView: tableView]];
	
	theSearchDisplayController.delegate = self;
	
    //	[tableView scrollToRowAtIndexPath: [NSIndexPath indexPathForRow: 0 inSection: 0] 
    //					 atScrollPosition: UITableViewScrollPositionTop 
    //							 animated: NO];
}

- (void)removeSearchDisplayControllerForTableView: (UITableView*)tableView
{
	NSString* key = [self dictionaryKeyForView: tableView];
	UISearchDisplayController* sdc = [self.searchDisplayControllers objectForKey: key];
	sdc.delegate = nil;
	[self.searchDisplayControllers removeObjectForKey: key];
}

#pragma mark -
#pragma mark Display
- (void)updateView
{
	KL_LOG(@"WARNING: %@ has no updateView method.", NSStringFromClass([self class]));
}

// Data
- (void)reloadData
{
	KL_LOG(@"WARNING: %@ has no reloadData method.", NSStringFromClass([self class]));	
}

#pragma mark -
#pragma mark Popovers
- (void)presentPopover: (UIViewController*)viewController 
			  fromRect:	(CGRect)rect 
permittedArrowDirections: (UIPopoverArrowDirection)arrowDirections 
			  animated: (BOOL)animated
{
	[self dismissPopoverAnimated: animated]; // TODO: will this break anything?
	
	self.popoverController = [[[UIPopoverController alloc] 
							   initWithContentViewController: viewController] autorelease];
	self.popoverController.delegate = self;
	[self.popoverController presentPopoverFromRect: rect 
											inView: self.view 
						  permittedArrowDirections: arrowDirections 
										  animated: animated];
}

- (void)presentPopover: (UIViewController*)viewController
	 fromBarButtonItem: (UIBarButtonItem *)item 
permittedArrowDirections: (UIPopoverArrowDirection)arrowDirections 
			  animated: (BOOL)animated
{
	[self dismissPopoverAnimated: animated]; // TODO: will this break anything?
	
	self.popoverController = [[[UIPopoverController alloc] 
							   initWithContentViewController: viewController] autorelease];
	self.popoverController.delegate = self;
	[self.popoverController presentPopoverFromBarButtonItem: item 
								   permittedArrowDirections: arrowDirections 
												   animated: animated];
}

- (void)dismissPopoverAnimated: (BOOL)animated
{
	if ( self.popoverController.popoverVisible )
		[self.popoverController dismissPopoverAnimated: animated];
	
	self.popoverController = nil;
}

#pragma mark UIPopoverControllerDelegate
- (BOOL)popoverControllerShouldDismissPopover: (UIPopoverController*)popoverController
{
	return YES;
}

- (void)popoverControllerDidDismissPopover: (UIPopoverController*)popoverController
{
	self.popoverController = nil;
}

#pragma mark -
#pragma mark Private
/**
 @brief produces an NSString to be used as a dictionary key for UIViews
 @details UIView does not support the NSCopying protocol and therefor cannot be used
 as a dictionary key, in order to allow the mapping of UIViews to other objects
 this method takes the class name and pointer to produce a key.
 */
- (NSString*)dictionaryKeyForView: (UIView*)theView
{
	return [NSString stringWithFormat: @"%@_%p", NSStringFromClass([theView class]), theView];
}

#pragma mark -
#pragma mark UITableViewDataSource
- (UITableViewCell*)tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath
{
	NSString* cellIdentifier = @"CellIdentifier";
	id<DataObject> dataObject = [self dataObjectForIndexPath: indexPath 
												 inTableView: tableView];
	
	if ( [[dataObject class] respondsToSelector: @selector(tableViewCellIdentifier)] )
		cellIdentifier = [[dataObject class] tableViewCellIdentifier];	
	
	KLTableViewCell* cell = (KLTableViewCell*)[tableView dequeueReusableCellWithIdentifier: cellIdentifier];
	if ( cell == nil )
	{
		if ( [[dataObject class] respondsToSelector: @selector(tableViewCell)] )
			cell = (KLTableViewCell*)[[dataObject class] tableViewCell];
		else
			cell = [[[KLTableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle 
										   reuseIdentifier: cellIdentifier] autorelease];
        
        //KL_LOG(@"<< Created cell with identifier: %@", cellIdentifier);
	}
    else   
    {
        //KL_LOG(@">> Dequeued cell with identifier: %@", cellIdentifier);
    }
	
	cell.textLabel.text = nil;
	cell.detailTextLabel.text = nil;
	cell.detailTextLabel.numberOfLines = 1;
	
    if ( [cell respondsToSelector: @selector(configureWithDataObject:)] )
    {
        [cell configureWithDataObject: dataObject];
    }
	else if ( [dataObject isKindOfClass: [NSString class]] )
	{
		cell.textLabel.text = (NSString*)dataObject;
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	else
	{	
		cell.textLabel.text = NSStringFromClass([dataObject class]);
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (NSInteger)tableView: (UITableView*)tableView numberOfRowsInSection: (NSInteger)section
{
	NSUInteger rowCount = 0;
	
	id currentTableData = [self tableDataForTableView: tableView];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex: section];
		rowCount = [sectionInfo numberOfObjects];
	}
	else if ( [currentTableData isKindOfClass: [KLTableData class]] )
	{
		rowCount = [(KLTableData*)currentTableData numberOfRowsInSection: section];
	}
	else if ( [currentTableData isKindOfClass: [NSArray class]] )
	{
		rowCount = [(NSArray*)currentTableData count];
	}
	else
	{
		// JLC: This will display one row that is a string, we could leave empty tables empty.
		rowCount = 1; // TODO: this may change
	}
	
	return rowCount;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView*)tableView
{
	NSUInteger sectionCount = 0;
	
	id currentTableData = [self tableDataForTableView: tableView];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		sectionCount = [[frc sections] count];
	}
	else if ( [currentTableData isKindOfClass: [KLTableData class]] )
	{
		sectionCount = [(KLTableData*)currentTableData numberOfSections];
	}
	else
	{	
		sectionCount = 1;
	}
	
	return sectionCount;
}

- (NSString*)tableView: (UITableView*)tableView titleForHeaderInSection: (NSInteger)section
{
	NSString* sectionName = nil;
	
	id currentTableData = [self tableDataForTableView: tableView];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		sectionName = [[[frc sections] objectAtIndex: section] name];
	}
	else if ( [currentTableData isKindOfClass: [KLTableData class]] )
	{
		sectionName = [(KLTableData*)currentTableData titleForSection: section];
	}
	
	return sectionName;
}

- (NSArray*)sectionIndexTitlesForTableView: (UITableView*)tableView
{
	NSArray* sectionIndexTitles = nil;
	
	id currentTableData = [self tableDataForTableView: tableView];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		sectionIndexTitles = frc.sectionIndexTitles;
	}
	
	return sectionIndexTitles;
}

#pragma mark UITableViewDelegate
- (CGFloat)tableView: (UITableView*)tableView heightForRowAtIndexPath: (NSIndexPath*)indexPath
{
	// Fetch the data object associated with this cell
	id dataObject = [self dataObjectForIndexPath: indexPath
									 inTableView: tableView];
    //	KLTableViewCell* cell = (KLTableViewCell*)[self tableView: tableView cellForRowAtIndexPath: indexPath];
    //	if ( [cell respondsToSelector: @selector(cellHeight)] )
    //		return [cell cellHeight];
    if ( [[dataObject class] respondsToSelector: @selector(tableViewCellClass)] )
    {
        Class tableViewCellClass = [[dataObject class] tableViewCellClass];
        if ( [tableViewCellClass respondsToSelector: @selector(cellHeightWithDataObject:)] )
        {
            return [tableViewCellClass cellHeightWithDataObject: dataObject];
        }
    }
	
	////////////////////////////////////////////////////////////////////////////////////////////////
	// Dynamically style the cell
	NSString* dataObjectClassName = NSStringFromClass( [dataObject class] );
	SEL dataObjectStylerSelector = NSSelectorFromString( [NSString stringWithFormat: @"heightForCellWith%@:font:", dataObjectClassName] );
	
	// Configure cell based on content type.
	if ( [[dataObject class] respondsToSelector: dataObjectStylerSelector] )
	{	
		CGFloat ret;
		__unsafe_unretained UIFont* font = [UIFont systemFontOfSize: 17];
		__unsafe_unretained id dataArgument = dataObject;
		
		NSMethodSignature* stylerMethodSignature = [[dataObject class] methodSignatureForSelector: dataObjectStylerSelector];
		NSInvocation* stylerInvocation = [NSInvocation invocationWithMethodSignature: stylerMethodSignature];
		[stylerInvocation setSelector: dataObjectStylerSelector];
		[stylerInvocation setTarget: [dataObject class]];
		[stylerInvocation setArgument: &dataArgument atIndex: 2];
		[stylerInvocation setArgument: &font atIndex: 3];
		[stylerInvocation invoke];
		
		[stylerInvocation getReturnValue: &ret];
		
		return ret;
	}
	else
		return 44.0;
}

- (void)tableView: (UITableView*)tableView 
  willDisplayCell: (UITableViewCell*)cell 
forRowAtIndexPath: (NSIndexPath*)indexPath
{	
	cell.textLabel.backgroundColor = [UIColor clearColor];
	cell.detailTextLabel.backgroundColor = [UIColor clearColor];
}

- (void)tableView: (UITableView*)tableView didSelectRowAtIndexPath: (NSIndexPath*)indexPath
{
	[tableView deselectRowAtIndexPath: indexPath animated: YES];
	
	id<DataObject> dataObject = [self dataObjectForIndexPath: indexPath
												 inTableView: tableView];
	[self didSelectDataObject: dataObject];
}

#pragma mark Headers
- (CGFloat)tableView: (UITableView*)theTableView heightForHeaderInSection: (NSInteger)section
{
	return [[self tableView: theTableView titleForHeaderInSection: section] length] > 0 ? kTableViewHeaderHeight : 0;
}

- (UIView*)tableView: (UITableView*)theTableView viewForHeaderInSection: (NSInteger)section
{
	const CGFloat adjustedHeight = kTableViewHeaderHeight - (kTableViewHeaderInset * 2.0);
	
	UIView* headerView = [[UIView alloc] initWithFrame: CGRectMake( 0, 0, 320, adjustedHeight )];
	headerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.95];
	
	UILabel* headerLabel = [[UILabel alloc] initWithFrame: CGRectMake( 10, 2, 300, adjustedHeight )];
	headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerLabel.font = [UIFont boldSystemFontOfSize: kTableViewHeaderFontSize];
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.text = [self tableView: theTableView titleForHeaderInSection: section];
	
	[headerView addSubview: headerLabel];
    [headerLabel release];
	
	return [headerView autorelease];
}

#pragma mark -
#pragma mark UISearchDisplayDelegate
- (void)searchDisplayControllerWillBeginSearch: (UISearchDisplayController*)controller
{
	KL_LOG(@"searchDisplayControllerWillBeginSearch");
}

- (void)searchDisplayControllerDidBeginSearch: (UISearchDisplayController*)controller
{
	KL_LOG(@"searchDisplayControllerDidBeginSearch");	
}

- (void)searchDisplayControllerWillEndSearch: (UISearchDisplayController*)controller
{
	KL_LOG(@"searchDisplayControllerWillEndSearch");	
}

- (void)searchDisplayControllerDidEndSearch: (UISearchDisplayController*)controller
{
	KL_LOG(@"searchDisplayControllerDidEndSearch");	
}

- (BOOL)searchDisplayController: (UISearchDisplayController*)controller 
shouldReloadTableForSearchString: (NSString*)searchString
{
	return YES;
}

- (BOOL)searchDisplayController: (UISearchDisplayController*)controller
shouldReloadTableForSearchScope: (NSInteger)searchOption
{
	return YES;
}

-(void)searchDisplayController: (UISearchDisplayController*)controller 
willShowSearchResultsTableView: (UITableView*)tableView 
{
    
}

-(void)searchDisplayController: (UISearchDisplayController*)controller 
 didShowSearchResultsTableView: (UITableView*)tableView 
{
	if ( [controller.searchBar.superview isKindOfClass: [UITableView class]] )
	{
		UITableView* staticTableView = (UITableView*)controller.searchBar.superview;
        
		CGRect f = [tableView.superview convertRect: staticTableView.frame fromView: staticTableView.superview];
		CGRect s = controller.searchBar.frame;
		CGRect newFrame = CGRectMake(f.origin.x,
									 f.origin.y + s.size.height,
									 f.size.width,
									 f.size.height - s.size.height);
		
		tableView.frame = newFrame;
	}
}


#pragma mark -
#pragma mark PullToRefresh
- (void)enablePullToRefreshForTableView: (UITableView*)tableView
{
	// Make sure that we don't do this twice
	if ( [self tableViewCanPullToRefresh: tableView] )
		return;
	
	// Pull To Refresh
	KLRefreshTableHeaderView* refreshHeaderView = [[KLRefreshTableHeaderView alloc] initWithFrame:
												   CGRectMake(0.0f,
															  0.0f - tableView.bounds.size.height,
															  320.0f,
															  tableView.bounds.size.height)];
	refreshHeaderView.backgroundColor = [UIColor colorWithRed: 0.0 green: 117/255.0 blue: 192/255.0 alpha: 1.0];
	refreshHeaderView.borderColor = [UIColor whiteColor];
	[tableView addSubview: refreshHeaderView];
    [refreshHeaderView release];
	[refreshHeaderView setLastUpdatedDate: [NSDate date]];
	tableView.showsVerticalScrollIndicator = YES;
	
	// Hang onto the refresh header view
	[self.refreshHeaderViewDictionary setObject: refreshHeaderView 
										 forKey: [self dictionaryKeyForView: tableView]];
	
	// Flag this feature as enabled.
	[self setCanPullToRefresh: YES forTableView: tableView];
}

// Can refresh
- (BOOL)tableViewCanPullToRefresh: (UITableView*)tableView
{
	return [[self.canPullToRefreshDictionary valueForKey: [self dictionaryKeyForView: tableView]] boolValue];
}

- (void)setCanPullToRefresh: (BOOL)canPullToRefresh
			   forTableView: (UITableView*)tableView
{
	[self.canPullToRefreshDictionary setValue: [NSNumber numberWithBool: canPullToRefresh] 
									   forKey: [self dictionaryKeyForView: tableView]];
}

// Check for refresh
- (BOOL)tableViewCheckForRefresh: (UITableView*)tableView
{
	return [[self.checkForRefreshDictionary valueForKey: [self dictionaryKeyForView: tableView]] boolValue];
}

- (void)setCheckForRefresh: (BOOL)checkForRefresh
			  forTableView: (UITableView*)tableView
{
	[self.checkForRefreshDictionary setValue: [NSNumber numberWithBool: checkForRefresh] 
                                      forKey: [self dictionaryKeyForView: tableView]];
}

// TableView reloading
- (BOOL)tableViewReloading: (UITableView*)tableView
{
	return [[self.tableViewReloadingDictionary valueForKey: [self dictionaryKeyForView: tableView]] boolValue];
}

- (void)setTableViewReloading: (BOOL)tableViewReloading
                 forTableView: (UITableView*)tableView
{
	[self.tableViewReloadingDictionary setValue: [NSNumber numberWithBool: tableViewReloading] 
                                         forKey: [self dictionaryKeyForView: tableView]];
}

- (void)showReloadAnimationForTableView: (UITableView*)tableView 
							   animated: (BOOL)animated
{
	if ( ![self tableViewCanPullToRefresh: tableView]  )
		return;
	
	[self setTableViewReloading: YES 
				   forTableView: tableView];
	
	KLRefreshTableHeaderView* refreshHeaderView = [self.refreshHeaderViewDictionary objectForKey: 
												   [self dictionaryKeyForView: tableView]];
	[refreshHeaderView toggleActivityView: YES];
	
	if ( animated )
	{
		[UIView beginAnimations: nil context: NULL];
		[UIView setAnimationDuration: 0.2];
		tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                  0.0f);
		[UIView commitAnimations];
	}
	else
	{
		tableView.contentInset = UIEdgeInsetsMake(60.0f, 0.0f, 0.0f,
                                                  0.0f);
	}
}

- (void)reloadDataSourceForTableView: (UITableView*)tableView
{
	if ( tableView == nil )
		return;
	
	NSLog( @"[%@]Please override reloadTableViewDataSource", [[self class] description] );
	
	[self performSelector: @selector(dataSourceDidFinishLoadingNewDataForTableView:) 
			   withObject: tableView 
			   afterDelay: 0.3];
}

- (void)dataSourceDidFinishLoadingNewDataForTableView: (UITableView*)tableView
{
	[self setTableViewReloading: NO 
				   forTableView: tableView];
	
	KLRefreshTableHeaderView* refreshHeaderView = [self.refreshHeaderViewDictionary objectForKey: 
												   [self dictionaryKeyForView: tableView]];
	[refreshHeaderView flipImageAnimated: NO];
	
	[UIView beginAnimations: nil context: NULL];
	[UIView setAnimationDuration: 0.3];
	[tableView setContentInset: UIEdgeInsetsMake(0.0f, 0.0f, 0.0f, 0.0f)];
	[refreshHeaderView setStatus: KLRefreshTableHeaderViewStatusPullToReload];
	[refreshHeaderView toggleActivityView: NO];
	[refreshHeaderView setLastUpdatedDate: [NSDate date]];
	[UIView commitAnimations];
	
	tableView.userInteractionEnabled = YES;
}

#pragma mark UIScrollView Overrides
- (void)scrollViewWillBeginDragging: (UIScrollView*)scrollView
{
	if ( [scrollView isKindOfClass: [UITableView class]] )
	{
		UITableView* tableView = (UITableView*)scrollView;
		
		if ( ![self tableViewCanPullToRefresh: tableView]  )
			return;
		
		if ( ![self tableViewReloading: tableView] )
		{
			//  only check offset when dragging
			[self setCheckForRefresh: YES 
						forTableView: tableView];
		}
	}
}

- (void)scrollViewDidScroll: (UIScrollView*)scrollView
{
	if ( [scrollView isKindOfClass: [UITableView class]] )
	{
		UITableView* tableView = (UITableView*)scrollView;
		
		if ( ![self tableViewCanPullToRefresh: tableView]  )
			return;
		
		if ( [self tableViewReloading: tableView] ) 
			return;
		
		if ( [self tableViewCheckForRefresh: tableView] )
		{
			KLRefreshTableHeaderView* refreshHeaderView = [self.refreshHeaderViewDictionary objectForKey: 
														   [self dictionaryKeyForView: tableView]];
			
			if ( refreshHeaderView.isFlipped
				&& scrollView.contentOffset.y > -65.0f
				&& scrollView.contentOffset.y < 0.0f
				&& ![self tableViewReloading: tableView] )
			{
				[refreshHeaderView flipImageAnimated: YES];
				[refreshHeaderView setStatus: KLRefreshTableHeaderViewStatusPullToReload];
				// Play pop sound
			}
			else if ( !refreshHeaderView.isFlipped
					 && scrollView.contentOffset.y < -65.0f )
			{
				[refreshHeaderView flipImageAnimated: YES];
				[refreshHeaderView setStatus: KLRefreshTableHeaderViewStatusReleaseToReload];
				// Play psst sound
			}
		}
	}
}

- (void)scrollViewDidEndDragging: (UIScrollView*)scrollView
				  willDecelerate: (BOOL)decelerate
{
	if ( [scrollView isKindOfClass: [UITableView class]] )
	{
		UITableView* tableView = (UITableView*)scrollView;
		
		if ( ![self tableViewCanPullToRefresh: tableView]  )
			return;
		
		if ( [self tableViewReloading: tableView] ) 
			return;
		
		if ( scrollView.contentOffset.y <= -65.0f )
		{
			if ( [tableView.dataSource respondsToSelector:
			      @selector(reloadDataSourceForTableView:)] )
			{
				[self showReloadAnimationForTableView: tableView 
											 animated: YES];
				// Play psst2 sound
				[self reloadDataSourceForTableView: tableView];
			}
		}
		[self setCheckForRefresh: NO 
					forTableView: tableView];
	}
}

#pragma mark -
#pragma mark NSFetchedResultsControllerDelegate
- (void)controllerDidChangeContent: (NSFetchedResultsController*)controller
{
	KL_LOG(@"controllerDidChangeContent: %@", [[controller.fetchRequest entity] name]);
}

@end
