//
//  WebViewController.h
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : KLViewController <UIWebViewDelegate>
{
	IBOutlet UIView*			loadingCoverView;
	IBOutlet UIWebView*			webView;
	
	IBOutlet UIBarButtonItem*	backButton;
	IBOutlet UIBarButtonItem*	forwardButton;
	IBOutlet UIBarButtonItem*	refreshButton;
	IBOutlet UIBarButtonItem*	stopButton;
	
	NSURL*						url;
}
+ (id)controllerWithURL: (NSURL*)url;
+ (id)modalControllerWithURL: (NSURL*)url;

- (IBAction)dismiss: (id)sender;

@end
