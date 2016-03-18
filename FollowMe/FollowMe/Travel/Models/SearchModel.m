//
//  SearchModel.m
//  FollowMe
//
//  Created by SCJY on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SearchModel.h"

@implementation SearchModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.title = dict[@"title"];
        self.cover_image_url = dict[@"cover_image_url"];
        self.price = dict[@"price"];
        self.location = dict[@"location"];
        self.url = dict[@"url"];
    }
    return self;
}

@end
