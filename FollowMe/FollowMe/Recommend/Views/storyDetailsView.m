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
    //介绍文字底部的高度
    CGFloat _introduceLableBottom;
    //保存上一次图片的底部的高度
    CGFloat _previousImageBottom;
    //保存最后一次label底部的高度
    CGFloat _previousLabelBottom;
}
@property (nonatomic, strong) UIImageView *userHeadImage;
@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UIImageView *lineImage;
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
    self.backgroundColor = [UIColor colorWithRed:250/255.f green:246/255.f blue:232/255.f alpha:1.0];
    
    

   
}
- (void)setDataDic:(NSDictionary *)dataDic{
   //先解析trip数组
    NSDictionary *tripsDic = dataDic[@"trip"];
    NSDictionary *userDic = tripsDic[@"user"];
    [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar_m"]] placeholderImage:nil];
    self.userNameLable.text = userDic[@"name"];
    //解析spot数组
    NSDictionary *spotDic = dataDic[@"spot"];
    CGFloat height = [self getTextHeightWithText:spotDic[@"text"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:15];
    UILabel *introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(20, 178, kWidth-40, height+70)];
    WLZLog(@"%.2f",height);
    introduceLable.text = spotDic[@"text"];
    introduceLable.numberOfLines = 0;
    
//解析 detail_list
    [self getDetailWithArray:spotDic[@"detail_list"]];
    _introduceLableBottom = introduceLable.bottom;
    
    
    
    
    
    [self addSubview:self.userHeadImage];
    [self addSubview:self.userNameLable];
    [self addSubview:self.lineImage];
    [self addSubview:introduceLable];

    
}
#pragma mark -------解析 detail_list

- (void)getDetailWithArray:(NSArray *)detailArray{
    _previousImageBottom = 0;
    _previousLabelBottom = 0;
    
    for (NSDictionary *dic in detailArray) {
        CGFloat imageHeight = [dic[@"photo_height"] integerValue];
        CGFloat imageWeight = [dic[@"phono_width"]integerValue];
        if (imageHeight == imageWeight) {
            imageHeight = imageWeight = kWidth-40;
        }else{
            imageHeight = imageHeight/imageWeight*kWidth;
            
            imageWeight = kWidth-40;
            
        }
        
//       UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(20,_introduceLableBottom+20 , kWidth-40, <#CGFloat height#>)]
        
    }
}
#pragma mark -------user头部的懒加载
- (UIImageView *)userHeadImage{
    if (_userHeadImage == nil) {
        self.userHeadImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, 40, 40)];
        self.userHeadImage.layer.cornerRadius = 20.0f;
    }
    return _userHeadImage;
}
- (UILabel *)userNameLable{
    if (_userNameLable == nil) {
        self.userNameLable = [[UILabel alloc] initWithFrame:CGRectMake(75, 90, kWidth-75, 40)];
    }
    return _userNameLable;
}
- (UIImageView *)lineImage{
    if (_lineImage == nil) {
        self.lineImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 154, kWidth-40, 1)];
        self.lineImage.backgroundColor = [UIColor colorWithRed:226/255.f green:222/256.f blue:214/256.f alpha:1.0];
    }
    return _lineImage;
}
#pragma mark -------introduceLable(介绍文字)
//- (UILabel *)introduceLable{
//    if (_introduceLable == nil) {
//        self.introduceLable = [[UILabel alloc] initWithFrame:self.frame];
//        
//    }
//    return _introduceLable;
//}
#pragma mark -------------------- 根据文字最大显示宽高贺文字内容返回高度
- (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}
@end
