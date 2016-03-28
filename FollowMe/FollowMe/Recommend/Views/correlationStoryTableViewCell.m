//
//  correlationStoryTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "correlationStoryTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation correlationStoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
- (void)setModel:(correlation *)model{
     NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    self.name.text = model.introduce;
    self.time.text = [NSString stringWithFormat:@"%@足迹",[numberFormatter stringFromNumber:model.foot]];
    
//    self.distance.text = [numberFormatter stringFromNumber:model.foot];
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.like.text = [NSString stringWithFormat:@"%@次浏览 / %@喜欢 / %@评论",[numberFormatter stringFromNumber:model.look],[numberFormatter stringFromNumber:model.like],[numberFormatter stringFromNumber:model.commentt]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
