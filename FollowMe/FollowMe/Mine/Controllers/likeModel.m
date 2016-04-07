//
//  likeModel.m
//  FollowMe
//
//  Created by scjy on 16/4/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "likeModel.h"

@implementation likeModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.imageUrl = dict[@"cover_image"];
        self.name = dict[@"name"];
        self.dayCount = dict[@"day_count"];
        self.firstDay = dict[@"first_day"];
        self.placeCount = dict[@"waypoints"];
    }
    return self;
}
@end
