//
//  storyDetailsView.m
//  FollowMe
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "storyDetailsView.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface storyDetailsView(){
    //保存上一次图片的底部的高度
    CGFloat _previousImageBottom;
    //保存最后一次label底部的高度
    CGFloat _lastLableBottom;
    CGFloat _introduceLableBottom;
}
@property (nonatomic, strong) UIImageView *userHeadImage;
@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UIImageView *lineImage;
@property(nonatomic, strong) UIScrollView *mainScrollView;
@end
@implementation storyDetailsView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self configView];
    }
    return self;
}
- (void)configView{
    self.backgroundColor = kCollectionColor;
    [self addSubview:self.mainScrollView];
   
}
- (void)setDataDic:(NSDictionary *)dataDic{
   //先解析trip数组
    NSDictionary *tripsDic = dataDic[@"trip"];
    NSDictionary *userDic = tripsDic[@"user"];
    [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar_m"]] placeholderImage:nil];
    self.userNameLable.text = userDic[@"name"];
    //解析spot数组
    NSDictionary *spotDic = dataDic[@"spot"];
    CGFloat height = [self getTextHeightWithText:spotDic[@"text"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:19];
    UILabel *introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 114, kWidth-40, height)];

    introduceLable.text = spotDic[@"text"];
    introduceLable.numberOfLines = 0;
    _introduceLableBottom = introduceLable.bottom;
//解析 detail_list
    [self getDetailWithArray:spotDic[@"detail_list"]];
   
    
    
    
    
    
    [self.mainScrollView addSubview:self.userHeadImage];
    [self.mainScrollView addSubview:self.userNameLable];
    [self.mainScrollView addSubview:self.lineImage];
    [self.mainScrollView addSubview:introduceLable];

    
}
#pragma mark -------解析 detail_list

- (void)getDetailWithArray:(NSArray *)detailArray{
 
    for (NSDictionary *dic in detailArray) {
        
        CGFloat y;
        CGFloat width;
        CGFloat height;
        if (_lastLableBottom < _introduceLableBottom) {
            y = _introduceLableBottom + _lastLableBottom + 20;
        }else{
            y = _lastLableBottom + 10;
        }
        width = [dic[@"photo_width"] floatValue];
        height = [dic[@"photo_height"] floatValue];
        if (height != width) {
            height = height/width*(kWidth-40);
        }else if(height == width){
            height = width = kWidth-40;
        }
        if ([dic[@"text"]isEqualToString:@""]) {
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, kWidth-40, height)];
            [image sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:nil];
            [self.mainScrollView addSubview:image];
            _lastLableBottom = y + height +10;
        }
        else{
             CGFloat textHeight = [self getTextHeightWithText:dic[@"text"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:15];
            UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, kWidth-40, height)];
            [image sd_setImageWithURL:[NSURL URLWithString:dic[@"photo"]] placeholderImage:nil];
            y = y + height + 10;
            UILabel *lable = [[UILabel alloc]initWithFrame:CGRectMake(20, y, kWidth-40, textHeight)];
            lable.font = [UIFont systemFontOfSize:13.0];
            lable.text = dic[@"text"];
            lable.numberOfLines = 0;
            _lastLableBottom = y + textHeight;
            [self.mainScrollView addSubview:image];
            [self.mainScrollView addSubview:lable];
        }
    }
    self.mainScrollView.contentSize = CGSizeMake(kWidth, _lastLableBottom + 10);
}
#pragma mark -------user头部的懒加载
- (UIImageView *)userHeadImage{
    if (_userHeadImage == nil) {
        self.userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 26, 40, 40)];
        self.userHeadImage.layer.cornerRadius = 20.0f;
    }
    return _userHeadImage;
}
- (UILabel *)userNameLable{
    if (_userNameLable == nil) {
        self.userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 26, kWidth-75, 40)];
    }
    return _userNameLable;
}
- (UIImageView *)lineImage{
    if (_lineImage == nil) {
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, kWidth-40, 1)];
        self.lineImage.backgroundColor = [UIColor colorWithRed:226/255.f green:222/256.f blue:214/256.f alpha:1.0];
    }
    return _lineImage;
}
#pragma mark -------mainScrollView
-(UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:self.frame];
     
    }
    return _mainScrollView;
    
}
#pragma mark -------------------- 根据文字最大显示宽高贺文字内容返回高度
- (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}
@end
