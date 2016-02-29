//
//  AppDelegate.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-22.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
//#import <FacebookSDK/FacebookSDK.h>
@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    //tab bar view controller
//    UIViewController *viewController1, *viewController2;
//    viewController1 = [[FirstViewController alloc] initWithNibName:@"FirstViewController" bundle:nil];
//    viewController2 = [[SecondViewController alloc] initWithNibName:@"SecondViewController" bundle:nil];
//   
//    self.tabBarController = [[UITabBarController alloc] init];
//    self.tabBarController.viewControllers = @[viewController1, viewController2];
//    self.window.rootViewController = self.tabBarController;
    UIViewController* rootViewController = [[MenuViewController alloc]init];
    UINavigationController* navigationController = [[UINavigationController alloc]initWithRootViewController:rootViewController];
    self.window.rootViewController = navigationController;
    [self.window makeKeyAndVisible];
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return YES;
}
/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
+ (NSOperationQueue *)backgroundQueue
{
    static dispatch_once_t once;
    static id _backgroundQueue;
    
    dispatch_once(&once, ^{
        _backgroundQueue = [[NSOperationQueue alloc] init];
        [_backgroundQueue setMaxConcurrentOperationCount:4];
    });
    
    return _backgroundQueue;
}
@end
