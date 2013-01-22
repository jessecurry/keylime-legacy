//
//  NSObject_DynamicTableViewCellsTest.m
//  keylime
//
//  Created by Jesse Curry on 1/22/13.
//  Copyright (c) 2013 Jesse Curry. All rights reserved.
//

#import <GHUnitIOS/GHUnit.h>

// Class being tested
#import "NSObject+DynamicTableViewCells.h"

@interface NSObject_DynamicTableViewCellsTest : GHTestCase
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation NSObject_DynamicTableViewCellsTest

- (BOOL)shouldRunOnMainThread
{
  // By default NO, but if you have a UI test or test dependent on running on the main thread return YES.
  // Also an async test that calls back on the main thread, you'll probably want to return YES.
  return NO;
}

#pragma mark - Class setup
- (void)setUpClass
{
  // Run at start of all tests in the class
}

- (void)tearDownClass
{
  // Run at end of all tests in the class
}

#pragma mark - Test setup
- (void)setUp
{
  // Run before each test method
}

- (void)tearDown
{
  // Run after each test method
}

#pragma mark - Tests
- (void)testTableViewCellIdentifier
{
  NSString* const expected = @"NSObjectTableViewCellIdentifier";
  NSString* identifier = [NSObject tableViewCellIdentifier];
  
  GHAssertEqualStrings(identifier, expected, @"identifier should equal %@", expected);
}

- (void)testTableViewCellClass
{
  [NSObject tableViewCellClass];
}
//
//- (void)testTableViewCell
//{
//  
//}

@end
