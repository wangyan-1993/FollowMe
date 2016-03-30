//
//  specialTableViewCell.h
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "specialModel.h"

@interface specialTableViewCell : UITableViewCell

@property (nonatomic, strong) specialModel *model;
+ (CGFloat)getCellHeightWithModel:(specialModel *)model;
+ (CGFloat)getTextHeightWithText:(NSString *)textLable;
@end
