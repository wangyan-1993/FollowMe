//
//  cityModel.h
//  FollowMe
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface cityModel : NSObject

@property(nonatomic, copy) NSString *address;

@property(nonatomic, copy) NSString *date_str;
@property(nonatomic, copy) NSString *distance;
@property(nonatomic, copy) NSString *like_count;
@property(nonatomic, copy) NSString *price;
@property(nonatomic, copy) NSString *product_id;
@property(nonatomic, copy) NSString *stock;
@property(nonatomic, copy) NSArray *tab_list;
@property(nonatomic, copy) NSDictionary *user;
@property(nonatomic, copy) NSString *title_page;
@property(nonatomic, copy) NSString *title;
//@property(nonatomic, copy) NSString *



-(instancetype)initWithCity:(NSDictionary *)dic;





@end
