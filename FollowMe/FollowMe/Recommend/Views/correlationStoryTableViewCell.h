//
//  correlationStoryTableViewCell.h
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "correlation.h"
@interface correlationStoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *like;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (nonatomic, retain) correlation *model;

@end
