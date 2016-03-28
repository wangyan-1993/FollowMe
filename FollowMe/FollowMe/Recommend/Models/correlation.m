//
//  correlation.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "correlation.h"

@implementation correlation
- (instancetype)initWithDictionary:(NSDictionary *)tripDic{
    self = [super init];
    if (self) {
        NSString *str1 = tripDic[@"cover_image_1600"];
        self.image = [str1 stringByReplacingOccurrencesOfString:@"/w/640/h/480/" withString:@"/w/700/h/300/"];
        self.introduce = tripDic[@"name"];
        self.time = tripDic[@"mileage"];
        self.look = tripDic[@"view_count"];
        self.foot = tripDic[@"waypoints"];
        self.like = tripDic[@"recommendations"];
        self.commentt = tripDic[@"total_comments_count"];
        
        
    }
    return self;
}

@end
