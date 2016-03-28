//
//  farina.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "farina.h"

@implementation farina
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.image = dict[@"avatar_m"];
    }
    return self;
}
@end
