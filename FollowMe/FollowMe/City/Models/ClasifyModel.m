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
        self.StrId = dic[@"id"];
        self.StrName = dic[@"name"];
    }
    
    
    return self;
    
}

@end
