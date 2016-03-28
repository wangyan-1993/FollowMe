//
//  correlation.h
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface correlation : NSObject
@property (nonatomic, retain) NSString *image;
@property (nonatomic, retain) NSNumber *time;
@property (nonatomic, retain) NSNumber *foot;
@property (nonatomic, retain) NSNumber *look;
@property (nonatomic, retain) NSNumber *like;
@property (nonatomic, retain) NSNumber *commentt;
@property (nonatomic, retain) NSString *introduce;
- (instancetype)initWithDictionary:(NSDictionary *)tripDic;
@end
