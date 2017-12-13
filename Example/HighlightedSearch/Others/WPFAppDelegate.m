//
//  WPFAppDelegate.m
//  HighlightedSearch
//
//  Created by PengfeiWang666 on 12/13/2017.
//  Copyright (c) 2017 PengfeiWang666. All rights reserved.
//

#import "WPFAppDelegate.h"

#import "WPFViewController.h"

@interface WPFAppDelegate ()

@end

@implementation WPFAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UINavigationController *baseNav = [[UINavigationController alloc] initWithRootViewController:[[WPFViewController alloc] init]];
    
    self.window.rootViewController = baseNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
