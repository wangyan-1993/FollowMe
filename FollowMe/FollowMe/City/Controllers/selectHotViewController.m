//
//  selectHotViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "selectHotViewController.h"
#import "JCTagListView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JCTagListView.h"

@interface selectHotViewController ()<UISearchBarDelegate>

@property(nonatomic, strong) JCTagListView *jcTagList;
@property(nonatomic, strong) UISearchBar *citySearchBar;

@end

@implementation selectHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://api.breadtrip.com/hunter/products/v2/search/hotkeywords/?city_name=%E6%AD%A6%E6%B1%89&sign=181bd33c9e5b30fd73e4725b68c5fdcc
    
    //点击明信片：http://api.breadtrip.com/hunter/products/v2/search/?city_name=%E6%AD%A6%E6%B1%89&lat=34.6134073236616&lng=112.414083492134&q=%E6%98%8E%E4%BF%A1%E7%89%87&start=0
    //点击聚会  ：http://api.breadtrip.com/hunter/products/v2/search/?city_name=%E6%AD%A6%E6%B1%89&lat=34.6134073236616&lng=112.414083492134&q=%E8%81%9A%E4%BC%9A&start=0
    
//    self.view.backgroundColor = [UIColor orangeColor];
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(kWidth/3, kHeight/8, kWidth/3, 44)];
    lable.text = @"热门搜索";
    lable.textAlignment = NSTextAlignmentCenter;
//    lable.backgroundColor = [UIColor redColor];
    [self.view addSubview:lable];
    
    
    
    self.jcTagList = [[JCTagListView alloc] initWithFrame:CGRectMake(0, kHeight/5, kWidth, kHeight/2)];
    self.jcTagList.tagTextColor = [UIColor colorWithRed:235/255 green:235/255 blue:235/255 alpha:0.5];
    self.jcTagList.tagStrokeColor = [UIColor colorWithRed:235/255 green:235/255 blue:235/255 alpha:0.5];
    self.jcTagList.layer.cornerRadius = 10.0;
    self.jcTagList.canSelectTags = YES;

    [self.jcTagList.tags addObjectsFromArray:@[@"摄影",@"占卜",@"美食",@"达人",@"明信片",@"油画",@"资讯",@"旅行",@"健康",@"约咖啡"]];

    [self.view addSubview:self.jcTagList];
    
    
    
//    //搜索框：
//    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, kWidth, 40)];
//    self.mySearchBar.delegate = self;
//    //    [self.navigationController.navigationBar addSubview:self.mySearchBar];
//    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
//    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
//    self.mySearchBar.backgroundColor = kMainColor;
//    self.mySearchBar.placeholder = @"搜索城市名或者拼音";
//    //    self.mySearchBar.layer.cornerRadius = 10;
//    self.mySearchBar.clipsToBounds = YES;
//    
//    [self.view addSubview:self.mySearchBar];
    
    self.citySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kWidth/6, 5, kWidth - kWidth/6 - 5, 40)];
    self.citySearchBar.delegate = self;
    self.citySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.citySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.citySearchBar.placeholder = @"请搜索关键字,地点,分类";
    self.citySearchBar.layer.cornerRadius = 10.0;
    self.citySearchBar.clipsToBounds = YES;
    [self.navigationController.navigationBar addSubview:self.citySearchBar];
  
    [self showBackBtn];
    
    
//    [self updateConfig];
    
}


-(void)backNext{
    [self.navigationController popoverPresentationController];
    
    
}

-(void)updateConfig{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.breadtrip.com/hunter/products/v2/search/hotkeywords/?city_name=%E5%8C%97%E4%BA%AC&sign=d8c4c7cc232d1b05a8b2e1c52b3e0020" parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WLZLog(@"%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.citySearchBar.hidden = NO;
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
     self.citySearchBar.hidden = YES;
}

/*
 - (void)viewWillDisappear:(BOOL)animated{
 [super viewWillDisappear:animated];
 self.mySearchBar.hidden = YES;
 }
 - (void)viewWillAppear:(BOOL)animated{
 [super viewWillAppear:animated];
 self.mySearchBar.hidden = NO;
 }
 */

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
