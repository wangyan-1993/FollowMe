//
//  specialModel.h
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface specialModel : NSObject
@property (nonatomic, retain) NSString *photo_1600;
@property (nonatomic, retain) NSString *text;
@property (nonatomic, retain) NSString *local_time;
@property (nonatomic, retain) NSString *poi_name;
@property (nonatomic, retain) NSString *imageWidth;
@property (nonatomic, retain) NSString *imageHeight;
@property (nonatomic, retain) NSString *latitude;
@property (nonatomic, retain) NSString *longitude;
- (instancetype)initWithDictionary:(NSDictionary *)rowdic;
@end
