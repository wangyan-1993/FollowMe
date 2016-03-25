//
//  ActivityTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ActivityTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ActivityTableViewCell ()

@property (strong, nonatomic) IBOutlet UILabel *DidCount;
@property (strong, nonatomic) IBOutlet UIImageView *title_page;

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *like_count;
@property (strong, nonatomic) IBOutlet UILabel *price;

@end



@implementation ActivityTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)setModel:(cityModel *)model{
    
    [self.title_page sd_setImageWithURL:[NSURL URLWithString:model.title_page]];
    //    self.title.text = model.tab_list[1];
    self.address.text = [NSString stringWithFormat:@"%@•%@",model.address,model.distance];
    self.like_count.text = [NSString stringWithFormat:@"%@人喜欢",model.like_count];
    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
    self.title.text = model.title;
    self.DidCount.text = @"38人已体验";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
