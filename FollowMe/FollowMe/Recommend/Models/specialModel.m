//
//  specialModel.m
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "specialModel.h"

@implementation specialModel


- (instancetype)initWithDictionary:(NSDictionary *)rowdic{
    self = [super init];
    if (self) {
        if (![rowdic[@"location"]isEqual:[NSNull null]]) {
            NSDictionary *addressDic = rowdic[@"location"];
            self.latitude = addressDic[@"latitude"];
            self.longitude = addressDic[@"longitude"];
            
        }
        
        
        if (rowdic[@"photo"]!=nil) {
            self.photo_1600 = rowdic[@"photo"];
            if ([rowdic[@"photo_info"]isEqual:[NSNull null]]) {
            }else{
                NSDictionary *dic2 = rowdic[@"photo_info"];
                self.imageWidth = dic2[@"w"];
                self.imageHeight = dic2[@"h"];
                
                
            }
        }
        self.text = rowdic[@"text"];
        self.local_time = rowdic[@"local_time"];
        if (![rowdic[@"poi"] isEqual:[NSNull null]]) {
            NSDictionary *dic = rowdic[@"poi"];
            self.poi_name = dic[@"name"];

       }
        
       
    }
    return self;
}

@end
