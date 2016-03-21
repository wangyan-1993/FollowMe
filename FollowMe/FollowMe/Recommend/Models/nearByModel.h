//
//  nearByModel.h
//  FollowMe
//
//  Created by scjy on 16/3/20.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface nearByModel : NSObject
@property (nonatomic, retain) NSString *nameStr;
@property (nonatomic, retain) NSString *userImage;
@property (nonatomic, retain) NSNumber *tipsCount;
@property (nonatomic, retain) NSNumber *distance;
@property (nonatomic, retain) NSNumber *visitedCount;
@property (nonatomic, retain) NSString *tips;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
