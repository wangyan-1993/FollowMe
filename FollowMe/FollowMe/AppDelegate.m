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
@interface AppDelegate ()<UITabBarControllerDelegate>
@property(nonatomic, strong) UITabBarController *tabBarVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    
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
    
   MineViewController *mineVC = [[MineViewController alloc]init];
    UINavigationController *mineNav = [[UINavigationController alloc]initWithRootViewController:mineVC];
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
