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

- (instancetype)initWithDictionary:(NSDictionary *)rowdic;
@end
