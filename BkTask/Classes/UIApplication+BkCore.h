//
//  UIApplication+BkCore.h
//  BkCore
//
//  Created by Pierre Monod-Broca on 08/11/11.
//  Copyright (c) 2011 Backelite. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (BkCore)

/**
 * Enables the network activitiy indicator in the status bar.
 * This method also increments a counter that is used 
 * to determine when to disable the indicator.
 */
- (void) enableNetworkActivityIndicator;

/**
 * Decrements the network activity state counter 
 * and actually disables the indicator in the status bar 
 * IFF the counter value is equal to 0.
 */
- (void) disableNetworkActivityIndicator;

@end
