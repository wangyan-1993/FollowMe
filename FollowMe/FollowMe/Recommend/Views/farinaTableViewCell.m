//
//  farinaTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "farinaTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation farinaTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(farina *)model{
    self.name.text = model.name;
    [self.image sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:nil];
    self.image.layer.masksToBounds = YES;
    self.image.layer.cornerRadius = 21.5f;

}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
