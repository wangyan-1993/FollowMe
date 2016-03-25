//
//  cityFirstTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "cityFirstTableViewCell.h"
#import "PersonViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

#define huiSE [UIColor colorWithRed:235/255 green:237/255 blue:235/255 alpha:0.3];

@interface cityFirstTableViewCell (){
    NSInteger page;
}
@property (strong, nonatomic) IBOutlet UIImageView *title_page;
@property (strong, nonatomic) IBOutlet UIImageView *avatar_I;
@property (strong, nonatomic) IBOutlet UILabel *title;
@property (strong, nonatomic) IBOutlet UILabel *address;
@property (strong, nonatomic) IBOutlet UILabel *like_count;
@property (strong, nonatomic) IBOutlet UILabel *price;

@property(nonatomic, strong) UILabel *lable;





@end

@implementation CALayer (Additions)



@end



@implementation cityFirstTableViewCell



- (void)awakeFromNib {
    // Initialization code
    //将·图片设置为圆形；
    self.avatar_I.frame = CGRectMake(self.title.frame.size.width+50, self.title.frame.size.height - 53, 53, 53);
    
    self.avatar_I.layer.cornerRadius = self.avatar_I.frame.size.width/2;
    self.avatar_I.clipsToBounds = YES;
    
    self.avatar_I.layer.masksToBounds = YES;
    //设置为图片宽度的一半
//    self.userImage.layer.cornerRadius =  30/2.0f;
    //边框宽度
    self.avatar_I.layer.borderWidth = 3.0f;
    self.avatar_I.layer.borderColor = [[UIColor whiteColor] CGColor];
    page = 0;
    
    
    
    
    
    
}




-(void)setModel:(cityModel *)model{
    
    [self.title_page sd_setImageWithURL:[NSURL URLWithString:model.title_page]];
//    self.title.text = model.tab_list[1];
    self.address.text = [NSString stringWithFormat:@"%@•%@",model.address,model.distance];
    self.like_count.text = [NSString stringWithFormat:@"%@人喜欢",model.like_count];
    self.price.text = [NSString stringWithFormat:@"￥%@",model.price];
    [self.avatar_I sd_setImageWithURL:[NSURL URLWithString:model.user[@"avatar_l"]]];
    self.title.text = model.title;
    page += 1;
    
  
    
        for (NSInteger i = 0; i<model.tab_list.count; i++) {

            self.lable = [[UILabel alloc] initWithFrame:CGRectMake(i*kWidth*0.2, 240+(page-1)*280, kWidth*0.2, 44)];
            _lable.text = model.tab_list[i];
            _lable.textAlignment = NSTextAlignmentCenter;
            _lable.font = [UIFont systemFontOfSize:13.0];
            _lable.textColor = huiSE;

            [self addSubview:_lable];
        }
    

   
   
    
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
