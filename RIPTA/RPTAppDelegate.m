//
//  AppDelegate.m
//  RIPTA
//
//  Created by Brian Olencki on 10/26/16.
//  Copyright © 2016 Brian Olencki. All rights reserved.
//

#import "RPTAppDelegate.h"
#import "RESideMenu.h"
#import "RPTLeftMenuViewController.h"
#import "RPTRootViewController.h"

@interface RPTAppDelegate ()

@end

@implementation RPTAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    RPTRootViewController *HomeVC = [[RPTRootViewController alloc]init];
    UINavigationController *HomeNavCont = [[UINavigationController alloc]initWithRootViewController:HomeVC];
    RPTLeftMenuViewController *LeftMenuVC = [[RPTLeftMenuViewController alloc]init];
    RESideMenu *SideMenuVC = [[RESideMenu alloc]initWithContentViewController:HomeNavCont leftMenuViewController:LeftMenuVC rightMenuViewController:nil];
    

    //Just a place holder image
    SideMenuVC.backgroundImage = [UIImage imageNamed:@"GradientPink.jpg"];
    
    SideMenuVC.menuPreferredStatusBarStyle = 1;
    SideMenuVC.delegate = self;
    SideMenuVC.contentViewShadowColor = [UIColor blackColor];
    SideMenuVC.contentViewShadowOffset = CGSizeMake(0, 0);
    SideMenuVC.contentViewShadowOpacity = .6;
    SideMenuVC.contentViewShadowRadius = 12;
    SideMenuVC.contentViewShadowEnabled = YES;
    
    self.window.rootViewController = SideMenuVC;
    
    //self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[NSClassFromString(@"RPTRootViewController") new]];
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
