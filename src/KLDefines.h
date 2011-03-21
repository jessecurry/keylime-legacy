/*
 *  KLDefines.h
 *  keylime
 *
 *  Created by Jesse Curry on 12/5/10.
 *  Copyright 2010 Jesse Curry. All rights reserved.
 *
 */

#pragma mark Logging
#if DEBUG
#define KL_LOG(...) NSLog(__VA_ARGS__)
#else
#define KL_LOG(...) /* */
#endif

#define FORCE_STRING(x) x ? x : @""

#define CLASS_NAME NSStringFromClass([self class])