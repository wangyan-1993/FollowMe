//
//  likeTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/4/7.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "likeTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface likeTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageUrl;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *firstDay;
@property (weak, nonatomic) IBOutlet UILabel *dayCount;
@property (weak, nonatomic) IBOutlet UILabel *wayCount;
@property (weak, nonatomic) IBOutlet UIImageView *allImage;


@end
@implementation likeTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.allImage.backgroundColor = [UIColor whiteColor];
}
- (void)setModel:(likeModel *)model{
    [self.imageUrl sd_setImageWithURL:[NSURL URLWithString:model.imageUrl] placeholderImage:nil];
    self.nameLable.text = model.name;
    self.firstDay.text = model.firstDay;
//NSNumber转化为NSString类型
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *dayCount = [numberFormatter stringFromNumber:model.dayCount];
    NSString *wayCount = [numberFormatter stringFromNumber:model.placeCount];
    
    self.dayCount.text = [NSString stringWithFormat:@"%@天",dayCount];
    self.wayCount.text = wayCount;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
