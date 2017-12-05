//
//  AppDelegate.m
//  HighlightedSearch
//
//  Created by Leon on 2017/11/21.
//  Copyright © 2017年 Leon. All rights reserved.
//


/**
 * 需要额外说明：做缓存，已经转过的不需要再转了
 
 */

#import "AppDelegate.h"
#import "WPFViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    
    UINavigationController *baseNav = [[UINavigationController alloc] initWithRootViewController:[[WPFViewController alloc] init]];
    
    self.window.rootViewController = baseNav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
