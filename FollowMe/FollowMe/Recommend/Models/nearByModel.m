//
//  nearByModel.m
//  FollowMe
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "nearByModel.h"

@implementation nearByModel
- (instancetype)initWithDictionary:(NSDictionary *)dict{
    self = [super init];
    if (self) {
        self.nameStr = dict[@"name"];
        self.userImage = dict[@"cover_s"];
        self.tipsCount = dict[@"tips_count"];
        self.distance = dict[@"distance"] ;
        self.visitedCount = dict[@"visited_count"];
        NSArray *tipsArray = [[NSArray alloc] init];
        if (dict[@"tips_count"] == [NSNumber numberWithInteger:1]    ) {
            tipsArray = dict[@"tips"];
            for (NSDictionary *dictt in tipsArray) {
                self.tips = dictt[@"content"];
            }
            
        }else{
            self.tips = @"";
        }
        
        
    }
    return self;
}
@end
