//
//  ChoseCityModel.m
//  FollowMe
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ChoseCityModel.h"

@implementation ChoseCityModel

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
//    
//}

-(instancetype)initWithDicTionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.name = dic[@"name"];
        self.idStr = dic[@"id"];

    }

    
    return self;
    
    
}

@end
