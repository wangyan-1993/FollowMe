//
//  ClasifyModel.m
//  FollowMe
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ClasifyModel.h"

@implementation ClasifyModel
-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.Cover = dic[@"cover"];
        self.avatar = dic[@"avatar_l"];
        self.followers_count = dic[@"followings_count"];
        self.fanceCount = dic[@"followers_count"];
        self.orderName = dic[@"name"];
        self.liker = dic[@"profession"];
        self.userDesc = dic[@"user_desc"];
        self.oderAddress = dic[@"location_name"];
        self.goodSay = (long)dic[@"goodcomment_rate"];
        self.receiveSay = (long)dic[@"receive_rate"];
        self.replySay = (long)dic[@"reply_rate"];

    }
    
    
    return self;
    
}

@end
