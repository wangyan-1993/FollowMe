//
//  storyDetailsView.m
//  FollowMe
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "storyDetailsView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "advertisingViewController.h"
#import "storyDetailsViewController.h"
@interface storyDetailsView()<UITextFieldDelegate>{
    //保存上一次图片的底部的高度
    CGFloat _previousImageBottom;
    //保存最后一次label底部的高度
    CGFloat _lastLableBottom;
    CGFloat _introduceLableBottom;
    CGFloat _lableBottom;
    //保存推荐的人底部的高度
    CGFloat _recommendBottom;
    //最后的高度
    CGFloat _zeroBottom;
    //html接口（最下方广告详情接口）
    NSString *_html;
}
@property (nonatomic, strong) UIImageView *userHeadImage;
@property (nonatomic, strong) UILabel *userNameLable;
@property (nonatomic, strong) UIImageView *lineImage1;
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
    UITextField *textfield = [[UITextField alloc]initWithFrame:CGRectMake(0, kHeight-44, kWidth, 44)];
    textfield.borderStyle = UITextBorderStyleRoundedRect;
    textfield.placeholder = @"追加评论...";
    [self addSubview:textfield];
    
    
   
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
   
    if (_lableBottom != 0) {
        CGFloat y;
        y = _lableBottom+10;
        //横线
        UIImageView *lineImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, 335, 1)];
        lineImage2.backgroundColor = [UIColor colorWithRed:226/255.f green:222/256.f blue:214/256.f alpha:1.0];
        y = lineImage2.bottom + 20;
        //相机图片添加
        UIImageView *cameraImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, 20, 20)];
        cameraImage.image = [UIImage imageNamed:@"camera"];
        
        //故事收录于浅色调
        UILabel *fromLable = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 70, 20)];
        fromLable.text = @"故事收录于";
        fromLable.enabled = NO;
        fromLable.highlighted = YES;
        fromLable.textAlignment = NSTextAlignmentLeft;
        fromLable.font = [UIFont systemFontOfSize:13];
        //后面的文字要加粗和大写
        UILabel *storyFromLable = [[UILabel alloc] initWithFrame:CGRectMake(fromLable.right, y, 325, 20)];
        storyFromLable.text =tripsDic[@"name"];
        storyFromLable.textAlignment = NSTextAlignmentLeft;
        y = storyFromLable.bottom +10;
        //时钟图片添加
        UIImageView *clockImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, y, 20, 20)];
        clockImage.image = [UIImage imageNamed:@"clock"];
        //时间
        UILabel *timeLable = [[UILabel alloc] initWithFrame:CGRectMake(50, y, 325, 20)];
        NSString *timeStr = [spotDic[@"date_tour"] stringByReplacingOccurrencesOfString:@"T" withString:@" "];
        timeStr = [timeStr substringToIndex:16];
        timeLable.text = timeStr;
        timeLable.enabled = NO;
//        timeLable.highlighted = YES;
        timeLable.textAlignment = NSTextAlignmentLeft;
        timeLable.font = [UIFont systemFontOfSize:13];

        y = timeLable.bottom + 30;
        //请求数据
        NSDictionary *targetDic = spotDic[@"target"];
        //广告详情html接口
        _html = targetDic[@"url"];
        //广告图片  点击进入详情界面
        UIButton *advertisementBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        if (targetDic[@"cover"] != nil) {
            
            advertisementBtn.frame = CGRectMake(0, y, kWidth, kHeight/4);
            [advertisementBtn addTarget:self action:@selector(advertisementDetail) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *advertisementImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/4)];
            [advertisementImage sd_setImageWithURL:[NSURL URLWithString:targetDic[@"cover"]] placeholderImage:nil];
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight/8-20, kWidth, 20)];
            lable1.text = @"点击查看详情";
            lable1.textAlignment = NSTextAlignmentCenter;
            lable1.font = [UIFont systemFontOfSize:13];
            lable1.textColor = [UIColor whiteColor];
            
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight/8, kWidth, 20)];
            lable2.textAlignment = NSTextAlignmentCenter;
            lable2.text = targetDic[@"title"];
            lable2.font = [UIFont systemFontOfSize:20];
            lable2.textColor = [UIColor whiteColor];
            [advertisementImage addSubview:lable2];
            [advertisementImage addSubview:lable1];
            [advertisementBtn addSubview:advertisementImage];
            y = advertisementBtn.bottom + 20;

        }
                //多少人喜欢
        UILabel *likeCount = [[UILabel alloc] initWithFrame:CGRectMake(20, y, 335, 30)];
        likeCount.text = [NSString stringWithFormat:@"%@人喜欢",spotDic[@"recommendations_count"]];
        likeCount.textAlignment = NSTextAlignmentLeft;
        y = likeCount.bottom + 10;
//        添加button按钮
//        推荐（喜欢的人）的个人信息
        NSArray *recommendationsArray = spotDic[@"recommendations"];
        //获取头像信息
        NSMutableArray *userImageArray = [NSMutableArray new];
        NSInteger userImageCount;
        for (NSDictionary *dic in recommendationsArray) {
            [userImageArray addObject:dic[@"avatar_m"]];
        }
        //判断用户喜欢人数
        if (userImageArray.count<=7) {
            userImageCount = userImageArray.count;
        }
        else{
            userImageCount = 7;
        }
        //遍历数组
        for (NSInteger i = 0; i<userImageCount; i++) {
           UIButton *imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(20+(i*50), y, 45, 45)];
            if ([userImageArray[i] isEqualToString:@"http://media.breadtrip.com/avatars/default/m.png"]) {
                userImage.image = [UIImage imageNamed:@"avatar"];
            }else{
                [userImage sd_setImageWithURL:[NSURL URLWithString:userImageArray[i]] placeholderImage:nil];}
            userImage.layer.masksToBounds = YES;
            userImage.layer.cornerRadius = 22.5f;
            
            imageBtn.frame = CGRectMake(20+(i*50), y, 45, 45);
            imageBtn.layer.masksToBounds = YES;
            imageBtn.layer.cornerRadius = 22.5f;
            imageBtn.tag = 100+i;
            [imageBtn addTarget:self action:@selector(userHeadSelect:) forControlEvents:UIControlEventTouchUpInside];
            [self.mainScrollView addSubview:userImage];
            [self.mainScrollView addSubview:imageBtn];
            
        }
        y = y + 55;
            //解析评论信息
        
            UILabel *commentsCount = [[UILabel alloc] initWithFrame:CGRectMake(20, y, kWidth-40, 30)];
            commentsCount.text = [NSString stringWithFormat:@"%@人评论",spotDic[@"comments_count"]];
            _zeroBottom = y+30;
        //解析评论数据
        [self getWithCommentsArray:spotDic[@"comments"]];
            
//        [self getcommentsArrayWith:(NSArray)]
        
        [self.mainScrollView addSubview:commentsCount];
        [self.mainScrollView addSubview:advertisementBtn];
        [self.mainScrollView addSubview:fromLable];
        [self.mainScrollView addSubview:clockImage];
        [self.mainScrollView addSubview:cameraImage];
        [self.mainScrollView addSubview:likeCount];
        [self.mainScrollView addSubview:storyFromLable];
        [self.mainScrollView addSubview:timeLable];
        [self.mainScrollView addSubview:lineImage2];
        
    }

    
    
    
    [self.mainScrollView addSubview:self.userHeadImage];
    [self.mainScrollView addSubview:self.userNameLable];
    [self.mainScrollView addSubview:self.lineImage1];
    [self.mainScrollView addSubview:introduceLable];

    self.mainScrollView.contentSize = CGSizeMake(kWidth, _zeroBottom + 54);
}
#pragma mark ----------评论实现方法
- (void)getWithCommentsArray:(NSArray *)commentsArray{
    for (NSDictionary *dic in commentsArray) {
        NSDictionary *userDic = dic[@"user"];
       CGFloat height = [self getTextHeightWithText:[NSString stringWithFormat:@"%@:%@",userDic[@"name"],dic[@"comment"]] WithBigiestSize:CGSizeMake(kWidth-95, 1000) fontText:14];
//        CGFloat weight = [self getTextWeightWithText:userDic[@"name"] WithBigiestSize:CGSizeMake(1000, 40) fontText:12];
        //用户头像
        UIImageView *Userimage = [[UIImageView alloc] initWithFrame:CGRectMake(20, _zeroBottom, 45, 45)];
        [Userimage sd_setImageWithURL:[NSURL URLWithString:userDic[@"avatar_m"]] placeholderImage:nil];
        Userimage.layer.masksToBounds = YES;
        Userimage.layer.cornerRadius = 22.5f;
        //用户头像点击按钮
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(20, _zeroBottom, 45, 45);
        btn.layer.masksToBounds = YES;
        btn.layer.cornerRadius = 22.5f;
        [btn addTarget:self action:@selector(userHeadSelect:) forControlEvents:UIControlEventTouchUpInside];
        //评论
        UILabel *commentLableName = [[UILabel alloc] initWithFrame:CGRectMake(75, _zeroBottom, kWidth-95, height)];
        commentLableName.text = [NSString stringWithFormat:@"%@:%@",userDic[@"name"],dic[@"comment"]];
        commentLableName.numberOfLines = 0;
        commentLableName.font = [UIFont systemFontOfSize:14];
//        commentLableName.enabled = NO;
//        commentLableName.highlighted = YES;
        CGFloat btnHeight;
        if (height <= 50 ) {
            btnHeight = 50;
        }
        else{
            btnHeight = height;
        }
        UIButton *commentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        commentBtn.frame = CGRectMake(75, _zeroBottom, kWidth-95, btnHeight+10);
        
        _zeroBottom += btnHeight +10;
        [self.mainScrollView addSubview:Userimage];
        [self.mainScrollView addSubview:commentLableName];
        [self.mainScrollView addSubview:commentBtn];
    }
    
    
    
}

#pragma mark -------最下面广告详情的点击方法
- (void)advertisementDetail{
    
    advertisingViewController *adVC = [[advertisingViewController alloc] init];
    adVC.html = _html;
  
    
    [self.owner.navigationController pushViewController:adVC animated:YES];
}
#pragma mark -------人物头像的点击方法
- (void)userHeadSelect:(UIButton *)btn{
    switch (btn.tag) {
        case 100:
            WLZLog(@"1");
            break;
        case 101:
            WLZLog(@"2");
            break;

            
        default:
            break;
    }
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
    _lableBottom = _lastLableBottom+10;
 
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
- (UIImageView *)lineImage1{
    if (_lineImage1 == nil) {
        self.lineImage1 = [[UIImageView alloc] initWithFrame:CGRectMake(20, 90, kWidth-40, 1)];
        self.lineImage1.backgroundColor = [UIColor colorWithRed:226/255.f green:222/256.f blue:214/256.f alpha:1.0];
    }
    return _lineImage1;
}
#pragma mark -------mainScrollView
-(UIScrollView *)mainScrollView{
    if (_mainScrollView == nil) {
        self.mainScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight-44)];
     
    }
    return _mainScrollView;
    
}
#pragma mark -------------------- 根据文字最大显示宽高贺文字内容返回高度
- (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}
- (CGFloat)getTextWeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.width;
}
@end
