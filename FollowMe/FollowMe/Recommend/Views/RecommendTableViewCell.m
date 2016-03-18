
//
//  RecommendTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "RecommendTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface RecommendTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *activityImage;
@property (weak, nonatomic) IBOutlet UILabel *activityName;
@property (weak, nonatomic) IBOutlet UILabel *first_dayLable;
@property (weak, nonatomic) IBOutlet UILabel *day_count;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *view_countLable;
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *popular_place_strLable;


@end
@implementation RecommendTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.userImage.layer.masksToBounds = YES;
    //设置为图片宽度的一半
    self.userImage.layer.cornerRadius =  30/2.0f;
    //边框宽度
//    self.userImage.layer.borderWidth = 3.0f;
//    self.userImage.layer.borderColor = [[UIColor whiteColor] CGColor];
    
}
- (void)setModel:(RecommendModel *)model{
    [self.activityImage sd_setImageWithURL:[NSURL URLWithString:model.activityImageView] placeholderImage:nil];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userImage] placeholderImage:nil];
    self.activityName.text = model.activityName;
    self.first_dayLable.text = model.first_day;
    //string转NSNumber
    self.day_count.text = [NSString stringWithFormat:@"%@天",model.day_count];
    self.userName.text = model.userName;
   self.view_countLable.text = [NSString stringWithFormat:@"%@ 次浏览",model.view_count];
    self.popular_place_strLable.text = model.popular_place_str;
    
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
