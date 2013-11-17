//
//  CCNAppDelegate.m
//  CocoaNews
//
//  Created by Thibaut Jarosz on 14/11/13.
//  Copyright (c) 2013 CocoaHeads Lyon. All rights reserved.
//

#import "CCNAppDelegate.h"

#import "CCNTableViewController.h"

@implementation CCNAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[CCNTableViewController new]];
    [self.window makeKeyAndVisible];
    return YES;
}

@end
