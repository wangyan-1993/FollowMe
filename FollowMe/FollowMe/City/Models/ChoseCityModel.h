//
//  ChoseCityModel.h
//  FollowMe
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoseCityModel : NSObject


@property(nonatomic, copy) NSString *idStr;
@property(nonatomic, copy) NSString *name;


-(instancetype)initWithDicTionary:(NSDictionary *)dic;





@end
