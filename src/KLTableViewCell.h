//
//  KLTableViewCell.h
//  keylime
//
//  Created by Jesse Curry on 12/22/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITableViewCellHelper.h"

@protocol DataObject;
@interface KLTableViewCell : UITableViewCell 
{
	id<DataObject> dataObject;
}
@property (nonatomic, readonly) CGFloat cellHeight;
@property (nonatomic, retain) id<DataObject> dataObject;

+ (CGFloat)cellHeightWithDataObject: (id)theDataObject;

- (void)configureWithDataObject: (id)theDataObject;
@end
