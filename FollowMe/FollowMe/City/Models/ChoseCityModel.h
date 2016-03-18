//
//  ChoseCityModel.h
//  FollowMe
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChoseCityModel : NSObject


@property(nonatomic, copy) NSString *inCityname;
@property(nonatomic, copy) NSString *inhotCityName;
@property(nonatomic, copy) NSString *forCityName;
@property(nonatomic, copy) NSString *forHotName;




@property(nonatomic, copy) NSString *clasifyName;
@property(nonatomic, copy) NSString *idclasify;

//@property(nonatomic, copy) NSString; *

-(instancetype)initWithDicTionary:(NSDictionary *)dic;





@end
