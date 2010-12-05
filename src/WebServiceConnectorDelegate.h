/*
 *  WebServiceConnectorDelegate.h
 *  keylime
 *
 *  Created by Jesse Curry on 11/23/10.
 *  Copyright 2010 Jesse Curry. All rights reserved.
 *
 */

@class WebServiceConnector;
@protocol WebServiceConnectorDelegate
- (void)webServiceConnector: (WebServiceConnector*)webServiceConnector didFinishWithResult: (id)result;
- (void)webServiceConnector: (WebServiceConnector*)webServiceConnector didFailWithError: (NSError*)error;
@end