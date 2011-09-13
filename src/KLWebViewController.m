    //
//  WebViewController.m
//  keylime
//
//  Created by Jesse Curry on 11/11/10.
//  Copyright 2010 Jesse Curry. All rights reserved.
//

#import "KLWebViewController.h"

@interface KLWebViewController ()
@property (nonatomic, retain) NSURL*    url;
- (void)updateDisplay;
@end

////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation KLWebViewController
@synthesize url;

+ (id)controllerWithURL: (NSURL*)url
{
	id wv = [[[self class] alloc] init];
	if ( wv )
	{
		[wv setUrl: url];
	}
	return [wv autorelease];
}

+ (id)modalControllerWithURL: (NSURL*)url
{
	/* No need for this to have a different nib... a modally presented controller
	   should  simply make sure that there is a button to dismiss added somewhere. */
	id wv = [[[self class] alloc] initWithNibName: @"WebViewControllerModal" bundle: nil];
	if ( wv )
	{
		[wv setUrl: url];
	}
	return [wv autorelease];
}

#pragma mark -
- (void)dealloc
{
	webView.delegate = nil;
	[url release];
	
	[super dealloc];
}

#pragma mark -
#pragma mark IBActions
- (IBAction)dismiss: (id)sender
{
	[self.parentViewController dismissModalViewControllerAnimated: YES];
}

#pragma mark -
- (void)viewDidLoad
{
	[super viewDidLoad];
	
	// TODO: conditionally create a dismiss button if we are presented modally.
	
	if ( self.url )
	{
		[webView loadRequest: [NSURLRequest requestWithURL: self.url]];
	}
}

#pragma mark -
#pragma mark UIWebViewDelegate
//- (BOOL)webView: (UIWebView*)webView 
//shouldStartLoadWithRequest: (NSURLRequest*)request 
// navigationType: (UIWebViewNavigationType)navigationType
//{
//}

- (void)webViewDidStartLoad: (UIWebView*)webView
{
	KL_LOG( @"WebViewController - startedLoad: %@", [self.url description] );
	[self updateDisplay];
}

- (void)webViewDidFinishLoad: (UIWebView*)webView
{
	KL_LOG( @"WebViewController - finshedLoad: %@", [self.url description] );
	[self updateDisplay];
}

- (void)webView: (UIWebView*)webView didFailLoadWithError: (NSError*)error
{
	KL_LOG( @"WebViewController - failedLoad: %@ -- %@", [self.url description], [error localizedDescription] );
	[self updateDisplay];
}

#pragma mark -
- (void)updateDisplay
{
	const NSTimeInterval kAnimationDuration = 0.2;
	
	if ( webView.isLoading )
	{
		loadingCoverView.hidden = NO;
		if ( [[UIView class] respondsToSelector: @selector(transitionWithView:duration:options:animations:completion:)] )
		{
			[UIView transitionWithView: self.view 
							  duration: kAnimationDuration 
							   options: UIViewAnimationOptionCurveEaseOut 
							animations: ^{ loadingCoverView.alpha = 1.0; } 
							completion: ^(BOOL finished){}];
		}
		else
		{
			loadingCoverView.alpha = 1.0;
		}
	}
	else
	{
		if ( [[UIView class] respondsToSelector: @selector(transitionWithView:duration:options:animations:completion:)] )
		{
			[UIView transitionWithView: self.view 
							  duration: kAnimationDuration 
							   options: UIViewAnimationOptionCurveEaseOut 
							animations: ^{ loadingCoverView.alpha = 0.0; } 
							completion: ^(BOOL finished){ loadingCoverView.hidden = YES; }];
		}
		else
		{
			loadingCoverView.alpha = 0.0;
			loadingCoverView.hidden = YES;
		}
	}
	
	backButton.enabled = webView.canGoBack;
	forwardButton.enabled = webView.canGoForward;
	refreshButton.enabled = !webView.isLoading;
	stopButton.enabled = webView.isLoading;
}

@end
