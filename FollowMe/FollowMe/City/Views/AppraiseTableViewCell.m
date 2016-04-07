//
//  AppraiseTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "AppraiseTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface AppraiseTableViewCell ()
@property (strong, nonatomic) IBOutlet UIImageView *GoodImage;
@property (strong, nonatomic) IBOutlet UILabel *goodLb;

@property (strong, nonatomic) IBOutlet UIImageView *ReceiveImage;
@property (strong, nonatomic) IBOutlet UILabel *RemoveLb;

@property (strong, nonatomic) IBOutlet UIImageView *ReplaView;

@property (strong, nonatomic) IBOutlet UILabel *ReblyLb;




@end


@implementation AppraiseTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.GoodImage.layer.cornerRadius = 22;
    self.GoodImage.clipsToBounds = YES;
    self.ReceiveImage.layer.cornerRadius = 22;
    self.ReceiveImage.clipsToBounds = YES;
    self.ReplaView.layer.cornerRadius = 22;
    self.ReplaView.clipsToBounds = YES;

}


-(void)setModel:(ClasifyModel *)model{
    
    self.goodLb.text = [NSString stringWithFormat:@"%@%%",model.goodSay];
    if ([model.goodSay integerValue] > 80) {
        self.GoodImage.image = [UIImage imageNamed:@"hun_smile"];

    }else{
        self.GoodImage.image = [UIImage imageNamed:@"hun_ok"];

    }
    self.RemoveLb.text = [NSString stringWithFormat:@"%@%%",model.receiveSay];
    if ([model.receiveSay integerValue] > 80) {
        self.ReceiveImage.image = [UIImage imageNamed:@"hun_smile"];
        
    }else{
        self.ReceiveImage.image = [UIImage imageNamed:@"hun_ok"];
        
    }
    
    self.ReblyLb.text = [NSString stringWithFormat:@"%@%%",model.replySay];
    
    if ([model.replySay integerValue] > 80) {
        self.ReplaView.image = [UIImage imageNamed:@"hun_smile"];
        
    }else{
        self.ReplaView.image = [UIImage imageNamed:@"hun_ok"];
        
    }
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
