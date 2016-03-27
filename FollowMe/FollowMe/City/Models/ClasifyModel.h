//
//  ClasifyModel.h
//  FollowMe
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClasifyModel : NSObject
//头部背景图片
@property(nonatomic, copy) NSString *Cover;
//头像
@property(nonatomic, copy) NSString *avatar;
//粉丝
@property(nonatomic, copy) NSString *followers_count;
//关注人数；
@property(nonatomic, copy) NSString *fanceCount;
//作者名字
@property(nonatomic, strong) NSString *orderName;
//作者地址
@property(nonatomic, strong) NSString *oderAddress;
//作者爱好
@property(nonatomic, strong) NSString *liker;

//作者简介
@property(nonatomic, strong) NSString *userDesc;

//好评率
@property(nonatomic, assign) NSString *goodSay;
//接单率
@property(nonatomic, assign) NSString * receiveSay;

//回复率；
@property(nonatomic, assign) NSString* replySay;

/*
 评价：
 内容 
 头像
 图案
 日期

 */

/*
 猎人活动
 
 */

/*
 游记故事集
 
 */






-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
