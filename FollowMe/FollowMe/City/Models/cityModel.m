//
//  cityModel.m
//  FollowMe
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "cityModel.h"

@implementation cityModel


-(instancetype)initWithCity:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.address = dic[@"address"];
        self.date_str = dic[@"date_str"];
        self.distance = dic[@"distance"];
        self.price = dic[@"price"];
        
        self.user = dic[@"user"];
        
        self.tab_list = dic[@"tab_list"];
        self.product_id = dic[@"product_id"];
        self.stock = dic[@"stock"];
        self.like_count = dic[@"like_count"];
        self.title_page = dic[@"title_page"];
        self.title = dic[@"title"];
        self.sold_count = dic[@"sold_count"];
        
    }

    return self;
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//}







@end
