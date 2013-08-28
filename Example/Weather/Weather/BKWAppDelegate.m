//
//  AVAAppDelegate.m
//  Weather
//
//  Created by Gaspard Viot on 27/08/13.
//  Copyright (c) 2013 Backelite. All rights reserved.
//

#import "BKWAppDelegate.h"

@implementation BKWAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    UIColor *navigationBarColor = [UIColor colorWithRed:0.357 green:0.576 blue:0.941 alpha:1.000];
    [[UINavigationBar appearance] setTintColor:navigationBarColor];
    [[UISearchBar appearance] setTintColor:navigationBarColor];
    return YES;
}

@end
