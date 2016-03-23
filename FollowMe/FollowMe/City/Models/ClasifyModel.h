//
//  ClasifyModel.h
//  FollowMe
//
//  Created by scjy on 16/3/22.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClasifyModel : NSObject
@property(nonatomic, copy) NSString *StrName;
@property(nonatomic, copy) NSString *StrId;

-(instancetype)initWithDictionary:(NSDictionary *)dic;

@end
