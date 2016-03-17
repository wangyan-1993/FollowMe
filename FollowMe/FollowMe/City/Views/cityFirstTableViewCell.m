//
//  cityFirstTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "cityFirstTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface cityFirstTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *title_page;
@property (strong, nonatomic) IBOutlet UIImageView *avatar_I;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *like_count;
@property (strong, nonatomic) IBOutlet UILabel *price;




@end

@implementation cityFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    //将·图片设置为圆形；
    self.avatar_I.layer.cornerRadius = self.avatar_I.frame.size.width/2;
    self.avatar_I.clipsToBounds = YES;
}

-(void)setModel:(cityModel *)model{
    
    
    [self.title_page sd_setImageWithURL:[NSURL URLWithString:model.title_page]];
    
    
//    self.title.text = model.tab_list[1];
    self.address.text = [NSString stringWithFormat:@"%@•%@",model.address,model.distance];
    self.like_count.text = [NSString stringWithFormat:@"%@人喜欢",model.like_count];
    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
    [self.avatar_I sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar_l"]]];
    self.title.text = model.title;
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
