//
//  CityViewController.h
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChoseCityModel.h"

@interface CityViewController : UIViewController

@property(nonatomic, strong) ChoseCityModel *model;



@property(nonatomic, strong) UIButton *selectButton;

@property(nonatomic, strong) NSString *selectStr;
@property(nonatomic, strong) NSString *stringName;



@end
