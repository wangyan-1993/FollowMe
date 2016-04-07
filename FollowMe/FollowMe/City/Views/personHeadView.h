//
//  personHeadView.h
//  FollowMe
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ClasifyModel.h"

@interface personHeadView : UIView

@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UIImageView *headImage;
//粉丝
@property(nonatomic, strong) UILabel *fanceLb;
//关注
@property(nonatomic, strong) UILabel *LookLb;
//名字
@property(nonatomic, strong) UILabel *nameLable;
//地址
@property(nonatomic, strong) UILabel *addressLb;
@property(nonatomic, strong) UIButton *LookBtn;
@property(nonatomic, strong) UIButton *sentBtn;

@property(nonatomic, strong) UILabel *sayLb;

@property(nonatomic, strong) ClasifyModel *model;

@property(nonatomic, strong) NSDictionary *dic;


@end
