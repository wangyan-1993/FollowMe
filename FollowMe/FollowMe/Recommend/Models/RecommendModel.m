//
//  RecommendModel.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "RecommendModel.h"

@implementation RecommendModel
- (instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.activityImageView = dic[@"cover_image_w640"];
        self.activityName = dic[@"name"];
        self.first_day = dic[@"first_day"];
        self.day_count = dic[@"day_count"];
        self.view_count = dic[@"view_count"];
        self.popular_place_str = dic[@"popular_place_str"];
        NSDictionary *dic1 = dic[@"user"];
        
        self.userImage = dic1[@"avatar_m"];
        self.userName = dic1[@"name"];
       
        
    }
    return self;
}
@end
