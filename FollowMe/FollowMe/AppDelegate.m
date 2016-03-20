//
//  AppDelegate.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "AppDelegate.h"
#import "RecommendViewController.h"
#import "CityViewController.h"
#import "MineViewController.h"
#import "PlusViewController.h"
#import "TravelViewController.h"
#import <BmobSDK/Bmob.h>
#import "WeiboSDK.h"
@interface AppDelegate ()<UITabBarControllerDelegate, WeiboSDKDelegate>
@property(nonatomic, strong) UITabBarController *tabBarVC;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
    [Bmob registerWithAppKey:kBmobAppID];
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kWeiboAppKey];
    
    
    self.tabBarVC = [[UITabBarController alloc]init];
    self.tabBarVC.delegate = self;
    RecommendViewController *recommendVC = [[RecommendViewController alloc]init];
    UINavigationController *recommendNav = [[UINavigationController alloc]initWithRootViewController:recommendVC];
    recommendNav.tabBarItem.image = [UIImage imageNamed:@"heart"];
    recommendNav.tabBarItem.title = @"推荐";
    CityViewController *cityVC = [[CityViewController alloc]init];
    UINavigationController *cityNav = [[UINavigationController alloc]initWithRootViewController:cityVC];
    cityNav.tabBarItem.image = [UIImage imageNamed:@"28-star"];
    cityNav.tabBarItem.title = @"城市猎人";
   
    TravelViewController *travelVC = [[TravelViewController alloc]init];
    UINavigationController *travelNav = [[UINavigationController alloc]initWithRootViewController:travelVC];
    travelNav.tabBarItem.image = [UIImage imageNamed:@"23-bird"];
    travelNav.tabBarItem.title = @"自由行";
    MineViewController *mine = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mine];
    mineNav.tabBarItem.image = [UIImage imageNamed:@"53-house"];
    mineNav.tabBarItem.title = @"我的";
    PlusViewController *plusVC = [[PlusViewController alloc]init];
    UINavigationController *plusNav = [[UINavigationController alloc]initWithRootViewController:plusVC];
    plusNav.tabBarItem.image = [UIImage imageNamed:@"10-medical"];
    
    plusNav.tabBarItem.title = @"记录";
    self.tabBarVC.viewControllers = @[recommendNav, cityNav, plusNav, travelNav, mineNav];
    self.tabBarVC.tabBar.tintColor = [UIColor whiteColor];
    self.tabBarVC.tabBar.barTintColor = kMainColor;
    self.window.rootViewController = self.tabBarVC;

    
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}




- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}


- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

/**
 收到一个来自微博客户端程序的响应
 
 收到微博的响应后，第三方应用可以通过响应类型、响应的数据和 WBBaseResponse.userInfo 中的数据完成自己的功能
 @param response 具体的响应对象
 */
- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{
    NSString *accessToken = [(WBAuthorizeResponse *)response accessToken];
    NSString *uid = [(WBAuthorizeResponse *)response userID];
    NSDate *expiresDate = [(WBAuthorizeResponse *)response expirationDate];
    NSLog(@"acessToken:%@",accessToken);
    NSLog(@"UserId:%@",uid);
    NSLog(@"expiresDate:%@",expiresDate);
     NSDictionary *dic = @{@"access_token":accessToken,@"uid":uid,@"expirationDate":expiresDate};
        [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:BmobSNSPlatformSinaWeibo block:^(BmobUser *user, NSError *error) {
            if (error) {
                NSLog(@"weibo login error:%@",error);
            } else if (user){
                NSLog(@"user objectid is :%@",user.objectId);
    
            }
        }];
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}



@end
