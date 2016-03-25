//
//  storyMdel.h
//  FollowMe
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface storyMdel : NSObject

@property(nonatomic, copy) NSString *name;
@property(nonatomic, copy) NSString *id;
@property(nonatomic, copy) NSString *liked_count;
@property(nonatomic, copy) NSString *view_count;
@property(nonatomic, copy) NSString *total_comments_count;
@property(nonatomic, copy) NSString *cover_image_default;
@property(nonatomic, assign) NSInteger date_added;
@property(nonatomic, copy) NSString *date_complete;
@property(nonatomic, assign) NSInteger spot_count;

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key;
@end
