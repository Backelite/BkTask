//
//  UIApplication+BkCore.m
//  BkCore
//
//  Created by Pierre Monod-Broca on 08/11/11.
//  Copyright (c) 2011 Backelite. All rights reserved.
//

#import "UIApplication+BkCore.h"

@implementation UIApplication (BkCore)

#pragma mark - Network activity indicator

static NSUInteger networkActivityIndicatorStateCounter = 0;

- (void) enableNetworkActivityIndicator
{
	if ([NSThread mainThread]) {
        if (!self.networkActivityIndicatorVisible) {
            self.networkActivityIndicatorVisible = YES;
        }
		networkActivityIndicatorStateCounter++;
	} else {
		[self performSelectorOnMainThread:@selector(enableNetworkActivityIndicator) withObject:nil waitUntilDone:NO];
	}
}

- (void) disableNetworkActivityIndicator
{
	if ([NSThread mainThread]) {
		// Decrement counter and disable activity indicator when it reaches zero
		if (networkActivityIndicatorStateCounter > 0) {
			networkActivityIndicatorStateCounter--;
			if (networkActivityIndicatorStateCounter == 0) {
				self.networkActivityIndicatorVisible = NO;
			}
		}
	} else {
		[self performSelectorOnMainThread:@selector(disableNetworkActivityIndicator) withObject:nil waitUntilDone:NO];
	}
}


@end
