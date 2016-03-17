//
//  SearchModel.h
//  FollowMe
//
//  Created by SCJY on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchModel : NSObject
@property(nonatomic, copy) NSString *title;
@property(nonatomic, copy) NSString *location;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *url;
@property(nonatomic, copy) NSString *cover_image_url;
- (instancetype)initWithDictionary:(NSDictionary *)dict;

@end
