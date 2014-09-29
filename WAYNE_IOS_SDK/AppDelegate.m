//
//  AppDelegate.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-22.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "AppDelegate.h"
#import "MenuViewController.h"
#import "MobClick.h"
#import "UMSocial.h"
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
    
    [MobClick startWithAppkey:UmengAppKey];
    [UMSocialData setAppKey:UmengAppKey];
    [UMSocialConfig setSnsPlatformNames:@[UMShareToFacebook,UMShareToTwitter,UMShareToEmail,UMShareToSms]];
    [UMSocialConfig setWXAppId:AppId_Weixin url:nil];
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    //    [UMSocialConfig setTheme:UMSocialThemeBlack];
    [UMSocialConfig setShareGridViewTheme:^(CGContextRef ref, UIImageView *backgroundView,UILabel *label){
        //        backgroundView.backgroundColor = [UIColor whiteColor];
        //隐藏文字
        label.hidden = YES;
    }];
    
    [MobClick updateOnlineConfig];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onlineConfigCallBack:) name:UMOnlineConfigDidFinishedNotification object:nil];
    
    return YES;
}
- (void)onlineConfigCallBack:(NSNotification *)notification {
    if ([[MobClick getConfigParams:@"showAds"]isEqualToString:@"YES"]) {
        NSLog(@"online config has fininshed and params = %@", notification.userInfo);
    }
    
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
    [UMSocialSnsService  applicationDidBecomeActive];
//    [FBAppEvents activateApp];
//    [FBAppCall handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UMOnlineConfigDidFinishedNotification object:nil];
    
//    [FBSession.activeSession close];
}
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    [UMSocialSnsService handleOpenURL:url wxApiDelegate:nil];
//    [FBAppCall handleOpenURL:url
//                  sourceApplication:sourceApplication fallbackHandler:nil];
    
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
