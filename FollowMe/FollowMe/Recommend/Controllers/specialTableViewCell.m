//
//  specialTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "specialTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "mapAddressViewController.h"
@interface specialTableViewCell()

@property (nonatomic, strong) UIImageView *photo;
@property (nonatomic, strong) UILabel *text;
@property (nonatomic, strong) UILabel *time;
@property (nonatomic, strong) UILabel *name;
@property (nonatomic, retain) NSString *test;
@property (nonatomic, strong) NSString *latitude;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *address;
@end
@implementation specialTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}

-(void)setModel:(specialModel *)model{
    self.latitude = model.latitude;
    self.longitude = model.longitude;
    self.address = model.poi_name;
    CGFloat width;
    CGFloat height;
    if (model.imageWidth == nil) {
        width = 0;
        height = 0;
    }
    else{
    width = [model.imageWidth floatValue];
    height = [model.imageHeight floatValue];
    if (width == height) {
        height = width = kWidth-20;
    }
    else {
        height = height/width * (kWidth-20);
        width = kWidth-20;
    }
    }
    NSString *strImage = model.photo_1600;
    self.photo = [[UIImageView alloc] initWithFrame:CGRectMake(10 , 0, width,height)];
    [self.photo sd_setImageWithURL:[NSURL URLWithString:strImage] placeholderImage:nil];
    CGFloat textHeight = [[self class] getTextHeightWithText:model.text];
    self.text = [[UILabel alloc] initWithFrame:CGRectMake(10, height+10, kWidth-20, 100)];
    self.text.numberOfLines = 0;
    self.text.font = [UIFont systemFontOfSize:13.0];
    CGRect textFrame = self.text.frame;
    textFrame.size.height = textHeight;
    self.text.frame = textFrame;
    self.text.text = model.text;
    self.time = [[UILabel alloc]initWithFrame:CGRectMake(30, height+textHeight+20, 150, 15)];
    self.time.text = model.local_time;
    self.time.enabled = NO;
    self.time.highlighted = YES;
    self.time.font = [UIFont systemFontOfSize:13];
    //时钟图片添加
    UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectMake(15,height+textHeight+20 , 15, 15)];
    clockImage.image = [UIImage imageNamed:@"clock"];
    UIButton *addressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addressBtn.frame = CGRectMake(180, height+textHeight+20, kWidth-180, 15);
    [addressBtn setTitle:model.poi_name forState:UIControlStateNormal];
    [addressBtn addTarget:self action:@selector(map) forControlEvents:UIControlEventTouchUpInside];
    addressBtn.layer.masksToBounds = YES;
    addressBtn.layer.cornerRadius = 5;
    [addressBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    addressBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    
    
    [self addSubview:addressBtn];
    [self addSubview:clockImage];
    [self addSubview:self.time];
    [self addSubview:self.text];
    [self addSubview:self.photo];
}
- (void)map{
    mapAddressViewController *mapVC = [[mapAddressViewController alloc] init];
    mapVC.longitudeZH = self.longitude;
    mapVC.latitudeZH = self.latitude;
    mapVC.name = self.address;
    [self.owone.navigationController pushViewController:mapVC animated:YES];
}
+ (CGFloat)getCellHeightWithModel:(specialModel *)model{
    
    CGFloat width;
    CGFloat height;
    if (model.imageWidth == nil) {
        width = 0;
        height = 0;
    }
    else{
    width = [model.imageWidth floatValue];
    height = [model.imageHeight floatValue];
    if (width == height) {
        height = width = kWidth-20;
    }
    else {
        height = height/width * (kWidth-20);
        width = kWidth-20;
    }
    }
    CGFloat textHeight = [[self class] getTextHeightWithText:model.text];
    return  height+textHeight+50;
}
+ (CGFloat)getTextHeightWithText:(NSString *)textLable{
    CGRect text = [textLable boundingRectWithSize:CGSizeMake(kWidth-20, 2000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0]} context:nil ];
    return text.size.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
