//
//  OtherSayingTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "OtherSayingTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface OtherSayingTableViewCell ()
@property (strong, nonatomic) IBOutlet UILabel *saying;

@property (strong, nonatomic) IBOutlet UIImageView *titleImage;

@property (strong, nonatomic) IBOutlet UILabel *timeLable;

@end

@implementation OtherSayingTableViewCell

-(void)setModel:(otherModel *)model{
    
    self.saying.text = model.comment_public;
    [self.titleImage sd_setImageWithURL:[NSURL URLWithString:model.client_avatar]];
    self.timeLable.text = model.datetime_formatted;
    
}


- (void)awakeFromNib {
    // Initialization code
    
    self.titleImage.layer.cornerRadius = 20;
    self.titleImage.clipsToBounds = YES;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
