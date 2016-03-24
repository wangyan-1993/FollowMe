//
//  TravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "TravelViewController.h"
#import "SecondTravelViewController.h"
#import "ThirdTravelViewController.h"
#import "JCTagListView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "SearchTravelViewController.h"
#import "ProgressHUD.h"
#import "DataBaseManager.h"
@interface TravelViewController ()<UIWebViewDelegate, UISearchBarDelegate>
@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) UISearchBar *mySearchBar;
@property(nonatomic, strong) UIView *whiteView;
@property(nonatomic, strong) JCTagListView *cityList;
@property(nonatomic, strong) JCTagListView *searchList;
@property(nonatomic, strong) NSMutableArray *cityArray;
@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSURL *url = [[NSURL alloc]initWithString:@"http://web.breadtrip.com/product/topics/"];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 0, kWidth-20, 40)];
    self.mySearchBar.layer.cornerRadius = 10;
    self.mySearchBar.clipsToBounds = YES;
    self.mySearchBar.delegate = self;
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.placeholder = @"搜索目的地";
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    [ProgressHUD show:@"数据正在加载"];

    [self loadData];
    
    
}
-  (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.mySearchBar.hidden = NO;
    
}
#pragma mark---common method

- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manager GET:@"http://api.breadtrip.com/product/search/hot/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray *dataArray = responseObject[@"data"];
        self.cityArray = [NSMutableArray new];
        for (NSDictionary *dict in dataArray) {
            NSString *name = dict[@"name"];
            [self.cityArray addObject:name];
        }
               [self addWhiteView];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@", error);
    }];
}


- (void)addWhiteView{
    self.cityList.canSelectTags = YES;
    self.searchList.canSelectTags = YES;
    self.cityList.tagCornerRadius = 10.0f;
    self.searchList.tagCornerRadius = 10.0f;
#pragma mark---数据库
    //************************创建数据库，
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    //并传入所建数据库的名字！！！！！！！！！！！！！！！！必须传名字
    //dbManager.name = @"city";
    
    
    NSArray *ayyay1 = [NSArray arrayWithArray:self.cityArray];
    [self.cityList.tags addObjectsFromArray:ayyay1];
    //查询数据库里的所有元素
    NSArray *array =[NSArray arrayWithArray:[dbManager selectAllCollect]];
    //显示搜索记录
    if (self.searchList.tags.count > 0) {
        [self.searchList.tags removeAllObjects];
    }
    [self.searchList.tags addObjectsFromArray:array];
    
//小标签的点击方法
    __block TravelViewController *weakself = self;
    //
    [self.cityList setCompletionBlockWithSelected:^(NSInteger index) {
        weakself.mySearchBar.text = weakself.cityArray[index];
        //推出下一个页面
        SearchTravelViewController *search = [[SearchTravelViewController alloc]init];
        //隐藏搜索栏
        weakself.mySearchBar.hidden = YES;
        //将点击值传进下一个页面搜索栏
        search.cityName = weakself.cityArray[index];
        [weakself.navigationController pushViewController:search animated:YES];

        //forin循环，判断搜索记录是否包含当前所点击的城市
        for (NSString *str in weakself.searchList.tags) {
           
            //如果包含，直接退出
            if ([weakself.cityArray[index] isEqualToString:str]) {
                return;
            }
        }
        //不包含写进搜索记录；
        [weakself.searchList.tags addObject:weakself.cityArray[index]];
#pragma mark---数据库       
        //************************在数据库添加元素
        [dbManager insertIntoSearch:weakself.cityArray[index]];
        //搜索记录最多显示十个
        if (weakself.searchList.tags.count > 10) {
            [weakself.searchList.tags removeObjectAtIndex:0];
        }
        //刷新搜索记录
        [weakself.searchList.collectionView reloadData];
        
    }];
  [self.searchList setCompletionBlockWithSelected:^(NSInteger index) {
      SearchTravelViewController *search = [[SearchTravelViewController alloc]init];
      search.cityName = [dbManager selectAllCollect][index];
      weakself.mySearchBar.hidden = YES;
      [weakself.navigationController pushViewController:search animated:YES];

  }];
    
}

#pragma mark---UIWebViewDelegate
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    NSString *urlStr = request.URL.absoluteString;
   
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    NSInteger length = array.count;
    NSString *string1 = array[length-3];
    NSString *string2 = array[length-2];
    if ([string1 isEqualToString:@"product_topic"]) {
        SecondTravelViewController *second = [[SecondTravelViewController alloc]init];
        second.urlString = urlStr;
        second.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:second animated:YES];
        self.mySearchBar.hidden = YES;
        [self.webView stopLoading];
    }
    if ([string2 isEqualToString:@"book"]) {
        ThirdTravelViewController *third = [[ThirdTravelViewController alloc]init];
        third.urlString = urlStr;
        third.hidesBottomBarWhenPushed = YES;
        self.mySearchBar.hidden = YES;
        [self.navigationController pushViewController:third animated:YES];
        [self.webView stopLoading];

    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [ProgressHUD showSuccess:@"数据已加载完毕"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(nullable NSError *)error{
    [ProgressHUD showError:[NSString stringWithFormat:@"%@", error]];
}

#pragma mark---UISearchBarDelegate
//搜索栏输入导入时候
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self addWhiteView];
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:0.6 animations:^{
        self.whiteView.frame = self.view.frame;
    }];
    return YES;
}
//取消按钮的点击方法
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.6 animations:^{
        self.whiteView.frame = CGRectMake(0, -kHeight, kWidth, kHeight);
    }];
    self.mySearchBar.text = nil;

}
//搜索按钮的点击方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    for (NSString *str in self.searchList.tags) {
        if ([searchBar.text isEqualToString:str]) {
            return;
        }
    }
    [self.searchList.tags addObject:searchBar.text];
    if (self.searchList.tags.count > 10) {
        [self.searchList.tags removeObjectAtIndex:0];
    }
    [self.searchList.collectionView reloadData];
    SearchTravelViewController *search = [[SearchTravelViewController alloc]init];
    search.cityName = searchBar.text;
    self.mySearchBar.hidden = YES;
    [self.navigationController pushViewController:search animated:YES];

}
//点击空白回收键盘
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.mySearchBar resignFirstResponder];
}
#pragma mark---懒加载
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.webView.delegate = self;
        
    }
    return _webView;
}

- (UIView *)whiteView{
    if (_whiteView == nil) {
        self.whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, -kHeight, kWidth, kHeight)];
        UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 75, kWidth, 20)];
        label1.text = @"--热门搜索--";
        label1.textAlignment = NSTextAlignmentCenter;
        [self.whiteView addSubview:label1];
        UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(0, kHeight/2+15, kWidth, 20)];
        label2.text = @"--搜索记录--";
        label2.textAlignment = NSTextAlignmentCenter;

        [self.whiteView addSubview:label2];
        self.whiteView.backgroundColor =[UIColor whiteColor];
        [self.view addSubview:self.whiteView];
    }
    return _whiteView;
}

- (JCTagListView *)cityList{
    if (_cityList == nil) {
        self.cityList = [[JCTagListView alloc]initWithFrame:CGRectMake(kWidth/12, 100, kWidth/6*5, kHeight/2-100)];
        [self.whiteView addSubview:self.cityList];
        
    }
    return _cityList;
}


- (JCTagListView *)searchList{
    if (_searchList == nil) {
        self.searchList = [[JCTagListView alloc]initWithFrame:CGRectMake(kWidth/12, kHeight/2+50, kWidth/6*5, kHeight/2-50)];
        [self.whiteView addSubview:self.searchList];
        }
    return _searchList;
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
