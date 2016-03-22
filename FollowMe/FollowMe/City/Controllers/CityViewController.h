//
//  CityViewController.h
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseCityModel.h"

//代理传值，传递首页搜索图案的第二个详细界面的城市值
//
//@protocol SelectCityDelegate <NSObject>
//
//-(void)getCityName:(NSString *)city;
//
//@end



@interface CityViewController : UIViewController

//@property(nonatomic, assign) id<SelectCityDelegate>delegate;

@property(nonatomic, strong) ChoseCityModel *model;

@property(nonatomic, strong) UIButton *selectButton;

@property(nonatomic, strong) NSString *selectStr;
@property(nonatomic, strong) NSString *stringName;



@end
