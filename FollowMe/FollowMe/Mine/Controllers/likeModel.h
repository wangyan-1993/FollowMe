//
//  likeModel.h
//  FollowMe
//
//  Created by scjy on 16/4/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface likeModel : NSObject
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSString *firstDay;
@property (nonatomic, retain) NSNumber *dayCount;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSNumber *placeCount;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
