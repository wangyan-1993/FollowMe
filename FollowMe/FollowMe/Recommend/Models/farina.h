//
//  farina.h
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface farina : NSObject
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
-(instancetype)initWithDictionary:(NSDictionary *)dict;
@end
