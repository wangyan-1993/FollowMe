//
//  storyTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "storyTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface storyTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *titleName;

@property (strong, nonatomic) IBOutlet UILabel *saying;
@property (strong, nonatomic) IBOutlet UILabel *lookLb;
@property (strong, nonatomic) IBOutlet UILabel *linkCount;
@property (strong, nonatomic) IBOutlet UILabel *otherSay;
@property (strong, nonatomic) IBOutlet UIImageView *backImage;




@end


@implementation storyTableViewCell
/*

 
 */

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(storyMdel *)model{
    
    self.titleName.text = model.name ;
    
    if ([model.date_complete isEqualToString:@""]) {
        self.saying.text = @"默认故事集";
    }else{
    //日期转换
    NSDate *date1 = [[NSDate alloc]initWithTimeIntervalSince1970:(long)model.date_added];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //设置转化格式
    //yyyy年, MM月, dd日, HH小时/hh, mm分, ss秒 HH:mm:ss
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/shanghai"];
    [formatter setTimeZone:timeZone];//把时区设置添加到格式转化中
    
    //将NSDate转化成一个NSString类型的日期
    NSString *nowTimeStr = [formatter stringFromDate:date1];
  
        self.saying.text = [NSString stringWithFormat:@"%@•%lu地点故事",nowTimeStr,model.spot_count];}
    
    
    self.lookLb.text = [NSString stringWithFormat:@"%@次浏览",model.view_count];
    self.linkCount.text = [NSString stringWithFormat:@"%@喜欢",model.liked_count];
    [self.backImage sd_setImageWithURL:[NSURL URLWithString:model.cover_image_default]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
