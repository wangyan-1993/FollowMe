//
//  cityFirstTableViewCell.h
//  FollowMe
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "cityModel.h"
@interface cityFirstTableViewCell : UITableViewCell

@property(nonatomic, strong) cityModel *model;
@property (strong, nonatomic) IBOutlet UIButton *ClassifyButton;

@end
