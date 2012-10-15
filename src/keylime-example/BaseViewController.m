//
//  BaseViewController.m
//  keylime
//
//  Created by Jesse Curry on 10/15/12.
//  Copyright (c) 2012 Jesse Curry. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation BaseViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
