//
//  destination.h
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface destination : NSObject
@property (nonatomic, retain) NSString *cityName;
@property (nonatomic, retain) NSString *countryName;
- (instancetype)initWithDictionary:(NSDictionary *)dict;
@end
