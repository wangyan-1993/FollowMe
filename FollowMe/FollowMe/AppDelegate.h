//
//  AppDelegate.h
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>

static BOOL isProduct = YES;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSString *wbtoken;
//@property(nonatomic,strong) UINavigationController *plusNav;

@property(nonatomic, strong) UITabBarController *tabBarVC;
@end

