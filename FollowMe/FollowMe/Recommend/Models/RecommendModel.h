//
//  RecommendModel.h
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecommendModel : NSObject
@property (nonatomic, retain) NSString *activityName;
@property (nonatomic, retain) NSString *first_day;
@property (nonatomic, retain) NSNumber *day_count;
@property (nonatomic, retain) NSNumber *view_count;
@property (nonatomic, retain) NSString *popular_place_str;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *activityImageView;
@property (nonatomic, retain) NSString *userImage;


- (instancetype)initWithDictionary: (NSDictionary *)dic;
    

@end
