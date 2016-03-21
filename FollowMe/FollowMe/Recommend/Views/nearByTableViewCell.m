//
//  nearByTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "nearByTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface nearByTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *userImage;
@property (weak, nonatomic) IBOutlet UILabel *nameLable;
@property (weak, nonatomic) IBOutlet UILabel *tipsLable;
@property (weak, nonatomic) IBOutlet UILabel *tips;
@property (weak, nonatomic) IBOutlet UILabel *distanceAndVisitedLable;

@end
@implementation nearByTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setModel:(nearByModel *)model{
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    if ([model.userImage isEqualToString: @""]) {
        self.userImage.image = [UIImage imageNamed:@"noLike"];
    }else{
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.userImage] placeholderImage:nil];}
    self.nameLable.text = model.nameStr;
    NSString *tipsCount = [numberFormatter stringFromNumber:model.tipsCount];
    self.tipsLable.text = [NSString stringWithFormat:@"%@人点评",tipsCount];
    self.tips.text = model.tips;
    //NSNumber转化为NSSting类型
    NSString *visited = [numberFormatter stringFromNumber:model.visitedCount];
    NSString *distance = [numberFormatter stringFromNumber:model.distance];
    self.distanceAndVisitedLable.text = [NSString stringWithFormat:@"距我 %@km  /  %@ 人去过",distance,visited];
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
