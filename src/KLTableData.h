//
//  KLTableData.h
//  ClientConnect
//
//  Created by Jesse Curry on 2/1/11.
//  Copyright 2011 Jesse Curry. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface KLTableData : NSObject 
{
	NSMutableArray* sectionNames;
	NSMutableArray*	sectionDatum;
}
- (void)addSectionName: (NSString*)sectionName withData: (NSArray*)sectionData;
- (void)removeSection: (NSInteger)sectionIndex;

- (NSInteger)numberOfSections;
- (NSInteger)numberOfRowsInSection: (NSInteger)sectionIndex;

- (NSString*)titleForSection: (NSInteger)sectionIndex;
- (id)dataObjectForIndexPath: (NSIndexPath*)indexPath;

@end
