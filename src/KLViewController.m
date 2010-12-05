//
//  KLViewController.m
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "KLViewController.h"

static NSManagedObjectContext* defaultManagedObjectContext = nil;

////////////////////////////////////////////////////////////////////////////////////////////////////
@interface KLViewController ()
- (NSString*)dictionaryKeyForView: (UIView*)theView;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLViewController
@synthesize managedObjectContext;

+ (void)setDefaultManagedObjectContext: (NSManagedObjectContext*)defaultMoC
{
	// Probably no need to retain this.
	defaultManagedObjectContext = defaultMoC;
}

#pragma mark -
- (void)dealloc
{
	[tableData release];
	[canPullToRefreshDictionary release];
	[refreshHeaderViewDictionary release];
	[checkForRefreshDictionary release];
	[tableViewReloadingDictionary release];
	
	[super dealloc];
}

#pragma mark -
- (void)viewDidLoad
{
	[super viewDidLoad];
	//[self updateView];
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
		
		[frc setDelegate: self];
	
		NSError* error = nil;
		[NSFetchedResultsController deleteCacheWithName: frc.cacheName];
		if ( ![frc performFetch: &error] ) 
		{
			KL_LOG( @"[%@]Unresolved error %@, %@", [[self class] description], error, [error userInfo] );
		}
	}
}

- (void)removeTableDataForTableView: (UITableView*)tableView
{
	[self.tableData	removeObjectForKey: [self dictionaryKeyForView: tableView]];
}

- (id)dataObjectForIndexPath: (NSIndexPath*)indexPath inTableView: (UITableView*)tableView
{	
	id dataObject = nil;
	
	// Find the data for the current tableView
	id currentTableData = [self.tableData objectForKey: [self dictionaryKeyForView: tableView]];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		dataObject = [(NSFetchedResultsController*)currentTableData objectAtIndexPath: indexPath];
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

#pragma mark -
#pragma mark Display
- (void)updateView
{
	KL_LOG(@"WARNING: %@ has no updateView method.", NSStringFromClass([self class]));
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
	// TODO: Make this 80% more dynamical.
	NSString* const kCellIdentifier = @"kCellIdentifier";
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier: kCellIdentifier];
	if ( cell == nil )
	{
		cell = [[[UITableViewCell alloc] initWithStyle: UITableViewCellStyleSubtitle 
									   reuseIdentifier: kCellIdentifier] autorelease];
	}
	
	id dataObject = [self dataObjectForIndexPath: indexPath 
									 inTableView: tableView];
	
	// TODO: Really need to use an externalized styler.
	// Reset Text
	cell.textLabel.text = nil;
	cell.detailTextLabel.text = nil;
	cell.detailTextLabel.numberOfLines = 1;
	
	if ( dataObject )
	{
		cell.textLabel.text = NSStringFromClass([dataObject class]);
		cell.accessoryType = UITableViewCellAccessoryNone;
	}
	
	return cell;
}

- (NSInteger)tableView: (UITableView*)tableView numberOfRowsInSection: (NSInteger)section
{
	NSUInteger rowCount = 0;
	
	id currentTableData = [self.tableData objectForKey: [self dictionaryKeyForView: tableView]];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		id <NSFetchedResultsSectionInfo> sectionInfo = [[frc sections] objectAtIndex: section];
		rowCount = [sectionInfo numberOfObjects];
	}
	else if ( [currentTableData isKindOfClass: [NSArray class]] )
	{
		rowCount = [(NSArray*)currentTableData count];
	}
	else
	{
		rowCount = 1; // TODO: this may change
	}
	
	return rowCount;
}

- (NSInteger)numberOfSectionsInTableView: (UITableView*)tableView
{
	NSUInteger sectionCount = 0;
	
	id currentTableData = [self.tableData objectForKey: [self dictionaryKeyForView: tableView]];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		sectionCount = [[frc sections] count];
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
	
	id currentTableData = [self.tableData objectForKey: [self dictionaryKeyForView: tableView]];
	if ( [currentTableData isKindOfClass: [NSFetchedResultsController class]] )
	{
		NSFetchedResultsController* frc = currentTableData;
		sectionName = [[[frc sections] objectAtIndex: section] name];
	}
	
	return sectionName;
}

- (NSArray*)sectionIndexTitlesForTableView: (UITableView*)tableView
{
	NSArray* sectionIndexTitles = nil;
	
	id currentTableData = [self.tableData objectForKey: [self dictionaryKeyForView: tableView]];
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
	
	// Dynamically style the cell
	NSString* dataObjectClassName = NSStringFromClass( [dataObject class] );
	SEL dataObjectStylerSelector = NSSelectorFromString( [NSString stringWithFormat: @"heightForCellWith%@:font:", dataObjectClassName] );
	
	// Configure cell based on content type.
	if ( [[dataObject class] respondsToSelector: dataObjectStylerSelector] )
	{	
		CGFloat ret;
		UIFont* font = [UIFont systemFontOfSize: 17];
		
		NSMethodSignature* stylerMethodSignature = [[dataObject class] methodSignatureForSelector: dataObjectStylerSelector];
		NSInvocation* stylerInvocation = [NSInvocation invocationWithMethodSignature: stylerMethodSignature];
		[stylerInvocation setSelector: dataObjectStylerSelector];
		[stylerInvocation setTarget: [dataObject class]];
		[stylerInvocation setArgument: &dataObject atIndex: 2];
		[stylerInvocation setArgument: &font atIndex: 3];
		[stylerInvocation invoke];
		
		[stylerInvocation getReturnValue: &ret];
		
		return ret;
	}
//	else if ( [dataObject isKindOfClass: [NSString class]] )
//		return [dataObject heightForCellWithString: dataObject
//											  font: [UIFont systemFontOfSize: 17]];
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
	
	id dataObject = [self dataObjectForIndexPath: indexPath
									 inTableView: tableView];
	
	KL_LOG(@"[%@]selected %@", NSStringFromClass([self class]), NSStringFromClass([dataObject class]));
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
	headerView.backgroundColor = [UIColor colorWithWhite: 0.0 alpha: 0.35];
	
	UILabel* headerLabel = [[UILabel alloc] initWithFrame: CGRectMake( 10, 2, 300, adjustedHeight )];
	headerLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
	headerLabel.font = [UIFont boldSystemFontOfSize: kTableViewHeaderFontSize];
	headerLabel.textColor = [UIColor whiteColor];
	headerLabel.backgroundColor = [UIColor clearColor];
	headerLabel.text = [self tableView: theTableView titleForHeaderInSection: section];
	
	[headerView addSubview: headerLabel];
	
	return [headerView autorelease];
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
	
	KL_LOG(@"[%@]Please override reloadTableViewDataSource", NSStringFromClass([self class]));
	
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
			      @selector(reloadTableViewDataSource)] )
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
	
}

@end
