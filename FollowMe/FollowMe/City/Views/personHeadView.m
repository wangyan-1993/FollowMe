//
//  personHeadView.m
//  FollowMe
//
//  Created by scjy on 16/3/23.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "personHeadView.h"
#import <SDWebImage/UIImageView+WebCache.h>


@implementation personHeadView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}

-(void)configView{
    
    [self addSubview:self.headImageView];
    [self addSubview:self.headImage];

    [self addSubview:self.fanceLb];

    [self addSubview:self.sentBtn];

    [self addSubview:self.LookBtn];

    [self addSubview:self.addressLb];

    [self addSubview:self.nameLable];

    [self addSubview:self.LookLb];
    [self addSubview:self.sayLb];

}

-(UIImageView *)headImageView{
    if (_headImageView == nil) {
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kWidth*0.8)];
//        self.headImageView.backgroundColor = [UIColor blueColor];
        
    }
    return _headImageView;
  
}
-(UIImageView *)headImage{
    
    if (_headImage == nil) {
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/3, kWidth/8, kWidth/3, kWidth/3)];
        self.headImage.layer.cornerRadius = kWidth/6;
        self.headImage.clipsToBounds = YES;
//        self.headImage.backgroundColor = [UIColor brownColor];
        
    }
    return _headImage;
    
}
-(UILabel *)fanceLb{
    
    if (_fanceLb == nil) {
        
        self.fanceLb = [[UILabel alloc] initWithFrame:CGRectMake(kWidth*1/5+5, kHeight/10+10, 40, 60)];
        self.fanceLb.backgroundColor = [UIColor clearColor];
        self.fanceLb.textAlignment = NSTextAlignmentCenter;
        self.fanceLb.numberOfLines = 2;
        
        
        
    }
    return _fanceLb;
    
}
-(UILabel *)LookLb{
    if (_LookLb == nil) {
        self.LookLb = [[UILabel alloc] initWithFrame:CGRectMake(kWidth*2/3, kHeight/10+10, 40, 60)];
//        self.LookLb.backgroundColor = [UIColor greenColor];
        self.LookLb.textAlignment = NSTextAlignmentCenter;
        self.LookLb.numberOfLines = 2;
        
    }
    return _LookLb;
    
}
-(UILabel *)nameLable{
    
    if (_nameLable == nil) {
        
        self.nameLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kWidth/2+5, kWidth, 20)];
        self.nameLable.textAlignment = NSTextAlignmentCenter;
        self.nameLable.font = [UIFont systemFontOfSize:15.0];
        self.nameLable.backgroundColor = [UIColor clearColor];

    }
    return _nameLable;
    
}
-(UILabel *)addressLb{
    if (_addressLb == nil) {
        self.addressLb = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/4, kHeight/8+kWidth/3+10, kWidth/2, 30)];
        self.addressLb.textAlignment = NSTextAlignmentCenter;
        self.addressLb.font = [UIFont systemFontOfSize:13.0];
        self.addressLb.backgroundColor = [UIColor clearColor];

        
    }
    return _addressLb;
    
}
//-(UIButton *)LookBtn{
//    
//    if (_LookBtn == nil) {
//        self.LookBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.LookBtn.frame = CGRectMake(kWidth/6, kWidth/2+40, kWidth/3-10, 40);
//        self.LookBtn.backgroundColor = [UIColor whiteColor];
//        self.LookBtn.layer.cornerRadius = 15.0;
//        self.LookBtn.clipsToBounds = YES;
//        [self.LookBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        [self.LookBtn setTitle:@"关注" forState:UIControlStateNormal];
//  
//        
//    }
//    return _LookBtn;
//    
//}
//-(UIButton *)sentBtn{
//    
//    if (_sentBtn == nil) {
//        
//        self.sentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        //self.sentBtn.frame = CGRectMake(kWidth/2+10, kWidth/2+40, kWidth/3-10, 40);
//        self.sentBtn.frame = CGRectMake(kWidth/3, kWidth/2+40, kWidth/3-10, 40);
//        self.sentBtn.backgroundColor = [UIColor whiteColor];
//        [self.sentBtn setTitle:@"发私信" forState:UIControlStateNormal];
//        self.sentBtn.layer.cornerRadius = 15.0;
//        self.sentBtn.clipsToBounds = YES;
//        [self.sentBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        
//    }
//    return _sentBtn;
//    
//}



-(UILabel *)sayLb{
    if (_sayLb == nil) {
        _sayLb = [[UILabel alloc] initWithFrame:CGRectMake(20, kHeight/2, kWidth - 40, 100)];
        _sayLb.font = [UIFont systemFontOfSize:13.0];
        _sayLb.textColor = [UIColor blackColor];
        _sayLb.textAlignment = NSTextAlignmentCenter;
        _sayLb.numberOfLines = 0;
    }
    return _sayLb;
}



//-(void)setModel:(ClasifyModel *)model{
//
//    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:model.Cover]];
//    [self.headImage sd_setImageWithURL:[NSURL URLWithString:model.avatar]];
//    self.sayLb.text = model.userDesc;
//    self.fanceLb.text = [NSString stringWithFormat:@"%@ 粉丝",model.fanceCount];
//    self.LookLb.text = [NSString stringWithFormat:@"%@ 关注",model.followers_count];
//    self.nameLable.text = model.orderName;
//    self.addressLb.text = [NSString stringWithFormat:@"%@/%@",model.liker,model.oderAddress];
//
//}

-(void)setDic:(NSDictionary *)dic{
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"cover"]]];
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dic[@"avatar_l"]]];
    self.sayLb.text = dic[@"user_desc"];
    self.fanceLb.text = [NSString stringWithFormat:@"%@   粉丝",dic[@"followers_count"]];
    self.LookLb.text = [NSString stringWithFormat:@"%@    关注",dic[@"followings_count"]];
    self.nameLable.text = dic[@"name"];
    self.addressLb.text = [NSString stringWithFormat:@"%@/%@",dic[@"profession"],dic[@"location_name"]];
    
    
}


@end
