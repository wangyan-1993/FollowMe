//
//  SearchCollectionViewCell.m
//  FollowMe
//
//  Created by SCJY on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SearchCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface SearchCollectionViewCell()
@property(nonatomic, strong) UIImageView *imageview;

@property(nonatomic, strong) UILabel *location;
@property(nonatomic, strong) UILabel *price;


@end
@implementation SearchCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
   
    [self addSubview:self.imageview];
    [self addSubview:self.price];
    [self addSubview:self.location];
    [self addSubview:self.title];
    
 
}

- (void)setModel:(SearchModel *)model{
    [self.imageview sd_setImageWithURL:[NSURL URLWithString:model.cover_image_url]];
    self.price.text = [NSString stringWithFormat:@"￥%@", model.price];
    self.location.text = [NSString stringWithFormat:@"%@",model.location];
    self.title.text = [NSString stringWithFormat:@"%@",model.title];
}

- (UIImageView *)imageview{
    if (_imageview == nil) {
        self.imageview = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kWidth / 2-20, kWidth / 3 + 5)];
        self.imageview.layer.cornerRadius = 5;
        self.imageview.clipsToBounds = YES;
    }
    return _imageview;
}
- (UILabel *)title{
    if (_title == nil) {
        self.title = [[UILabel alloc] initWithFrame:CGRectMake(5, kWidth / 3 + 5, kWidth / 2-15, kWidth/9 + 5)];
        self.title.numberOfLines = 0;
        self.title.font = [UIFont systemFontOfSize:15.0];
    }
    return _title;
}
- (UILabel *)price{
    if (_price == nil) {
        self.price = [[UILabel alloc]initWithFrame:CGRectMake(kWidth/4+10, kWidth/9*4 + 5, kWidth/4-20, kWidth/9 + 5)];
        self.price.textColor = [UIColor orangeColor];
        self.price.textAlignment = NSTextAlignmentRight;
        self.price.font = [UIFont systemFontOfSize:17];
    }
    return _price;
}
- (UILabel *)location{
    if (_location == nil) {
        self.location = [[UILabel alloc]initWithFrame:CGRectMake(10, kWidth /9*4 + 5, kWidth/4, kWidth/9 + 5)];
        self.location.textAlignment = NSTextAlignmentLeft;
        self.location.font = [UIFont systemFontOfSize:14];
        self.location.textColor = [UIColor lightGrayColor];
    }
    return _location;
}
@end
