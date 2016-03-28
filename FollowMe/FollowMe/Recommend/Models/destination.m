//
//  destination.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "destination.h"

@implementation destination
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        NSString *str1;
        NSString *str2;
        self.cityName = dict[@"name"];
        if ([dict[@"province"]isEqual:[NSNull null]]) {
            str1 = @"";
        }
        else{
             NSDictionary *dicttt = dict[@"province"];
            str1 =dicttt[@"name"];
        }
        if ([dict[@"country"] isEqual:[NSNull null]]) {
            str2 = @"";
        }
        else{
            NSDictionary *dictt = dict[@"country"];

            str2 = dictt[@"name"];
        }
       
        self.countryName = [NSString stringWithFormat:@"%@ %@",str1,str2];
        
    }
    return self;
}
@end
