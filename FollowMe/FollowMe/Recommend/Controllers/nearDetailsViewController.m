//
//  nearDetailsViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/30.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "nearDetailsViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "photoViewController.h"




@interface nearDetailsViewController (){
    CGFloat _scrollViewHeight;
}
@property (nonatomic, retain) NSString *headimageName;
@property (nonatomic, strong) NSDictionary *rootDic;

@end

@implementation nearDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self netWork];
    [self.view addSubview:self.scrollView];
    [self imagebtn];
    [self.view addSubview:self.headImage];
    [self.view addSubview:self.scrollView];
    
}
- (void)imagebtn{
    self.imageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.imageBtn.frame = CGRectMake(0, 0, kWidth, kHeight/3);
    [self.imageBtn addTarget:self action:@selector(photoTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:self.imageBtn];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
   
    CGFloat yOffset   = self.scrollView.contentOffset.y;
    
    if (yOffset < 0) {
        
        CGFloat factor = ((ABS(yOffset)+(kHeight/3))*kWidth)/(kHeight/3);
        CGRect f = CGRectMake(-(factor-kWidth)/2, 0, factor, (kHeight/3)+ABS(yOffset));
        self.headImage.frame = f;
    } else {
        CGRect f = self.headImage.frame;
        f.origin.y = -yOffset;
        self.headImage.frame = f;
    }
}
- (void) netWork {
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/",self.typeId,self.detailId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WLZLog(@"%@",responseObject);
        self.rootDic = responseObject;
       
        
        NSDictionary *shareDic = self.rootDic[@"share_args"];
        NSDictionary *defaultDic = shareDic[@"default"];
        self.headimageName = defaultDic[@"shr_image"];
        NSLog(@"%@",self.headimageName);
        [self headway];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
}
- (void) headway {
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:self.headimageName] placeholderImage:nil];
    
    
    
    CGFloat y;
    y = 0;
    
    CGFloat nameLableHeight = [self getTextHeightWithText:self.rootDic[@"name"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:24];
    UILabel *nameLable = [[UILabel alloc] initWithFrame:CGRectMake(70, kHeight/3+20, kWidth-140, nameLableHeight)];
    nameLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:24];
    nameLable.text = self.rootDic[@"name"];
    nameLable.numberOfLines = 0;
    nameLable.textAlignment = NSTextAlignmentCenter;
    y = nameLable.bottom+15;
    if (![self.rootDic[@"recommended_reason"]isEqual:[NSNull null]]) {
        CGFloat introduceLableHeight = [self getTextHeightWithText:self.rootDic[@"recommended_reason"] WithBigiestSize:CGSizeMake(kWidth, 1000) fontText:14];
        UILabel *introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(50, y, kWidth-100, introduceLableHeight)];
        introduceLable.font = [UIFont systemFontOfSize:14];
        introduceLable.text = self.rootDic[@"recommended_reason"];
        introduceLable.numberOfLines = 0;
        introduceLable.textAlignment = NSTextAlignmentCenter;
        y = introduceLable.bottom+15;
        
        [self.scrollView addSubview:introduceLable];
    }
    if (![self.rootDic[@"address"]isEqual:[NSNull null]]||![self.rootDic[@"arrival_type"]isEqual:[NSNull null]]||![self.rootDic[@"description"]isEqual:[NSNull null]]||![self.rootDic[@"tel"]isEqual:[NSNull null]]||![self.rootDic[@"website"]isEqual:[NSNull null]]) {
        
        UILabel *basicMessageLable = [[UILabel alloc] initWithFrame:CGRectMake(0, y, kWidth, 40)];
        basicMessageLable.text = @"基本信息";
        basicMessageLable.font = [UIFont systemFontOfSize:18];
        basicMessageLable.textAlignment = NSTextAlignmentCenter;
        
        y = basicMessageLable.bottom+15;
        
        [self.scrollView addSubview:basicMessageLable];
        //概况信息
        if (![self.rootDic[@"description"]isEqual:[NSNull null]]) {
            
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, 20)];
            lable1.text = @"概况";
            lable1.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
            
            y = lable1.bottom+5;
            
            CGFloat height2 = [self getTextHeightWithText:self.rootDic[@"description"] WithBigiestSize:CGSizeMake(kWidth-20, 1000) fontText:18] ;
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, height2)];
            lable2.text = self.rootDic[@"description"];
            lable2.numberOfLines = 0;
            y = lable2.bottom+10;
            
            [self.scrollView addSubview:lable1];
            [self.scrollView addSubview:lable2];
        }
        if (![self.rootDic[@"address"]isEqual:[NSNull null]]) {
            
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, 20)];
            lable1.text = @"地址";
            lable1.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
            
            y = lable1.bottom+10;
            
            CGFloat height2 = [self getTextHeightWithText:self.rootDic[@"address"] WithBigiestSize:CGSizeMake(kWidth-20, 1000) fontText:18] ;
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, height2)];
            lable2.text = self.rootDic[@"address"];
            lable2.numberOfLines = 0;
            y = lable2.bottom+10;
            [self.scrollView addSubview:lable1];
            [self.scrollView addSubview:lable2];
        }
        if (![self.rootDic[@"arrival_type"]isEqual:[NSNull null]]) {
            
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, 20)];
            lable1.text = @"到达方式";
            lable1.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
            
            y = lable1.bottom+10;
            
            CGFloat height2 = [self getTextHeightWithText:self.rootDic[@"arrival_type"] WithBigiestSize:CGSizeMake(kWidth-20, 1000) fontText:18] ;
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, height2)];
            lable2.text = self.rootDic[@"arrival_type"];
            lable2.numberOfLines = 0;
            y = lable2.bottom+10;
            [self.scrollView addSubview:lable1];
            [self.scrollView addSubview:lable2];
        }
        if (![self.rootDic[@"tel"]isEqual:[NSNull null]]) {
            
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, 20)];
            lable1.text = @"联系方式";
            lable1.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
            
            y = lable1.bottom+10;
            
            CGFloat height2 = [self getTextHeightWithText:self.rootDic[@"tel"] WithBigiestSize:CGSizeMake(kWidth-20, 1000) fontText:18] ;
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, height2)];
            lable2.text = self.rootDic[@"tel"];
            lable2.numberOfLines = 0;
            y = lable2.bottom+10;
            [self.scrollView addSubview:lable1];
            [self.scrollView addSubview:lable2];
        }
        if (![self.rootDic[@"website"]isEqual:[NSNull null]]) {
            
            UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, 20)];
            lable1.text = @"官方网站";
            lable1.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
            
            y = lable1.bottom+10;
            
            CGFloat height2 = [self getTextHeightWithText:self.rootDic[@"website"] WithBigiestSize:CGSizeMake(kWidth-20, 1000) fontText:18] ;
            UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(10, y, kWidth-20, height2)];
            lable2.text = self.rootDic[@"website"];
            lable2.numberOfLines = 0;
            y = lable2.bottom+10;
            [self.scrollView addSubview:lable1];
            [self.scrollView addSubview:lable2];
        }
        
    }
   
    [self.scrollView addSubview:nameLable];

    _scrollViewHeight = y;
    self.scrollView.contentSize = CGSizeMake(kWidth,kHeight/3 + y);

}
- (void) photoTapped {
    photoViewController *photoVC = [[photoViewController alloc] init];
    photoVC.typeId = self.typeId;
    photoVC.userId = self.detailId;
    [self.navigationController pushViewController:photoVC animated:NO];
}
- (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font{
    CGRect textRect = [text boundingRectWithSize:bigSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:font]} context:nil];
    return textRect.size.height;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
  
        CGRect bounds = self.view.bounds;
        self.scrollView.frame = bounds;
    
    
}
- (UIImageView *)headImage{
    if (_headImage == nil) {
        self.headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, (kHeight/3))];
    }
    return _headImage;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        self.scrollView = [[UIScrollView alloc] init];
        self.scrollView.delegate = self;
        self.scrollView.backgroundColor = [UIColor clearColor];
        
    }
    return _scrollView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
