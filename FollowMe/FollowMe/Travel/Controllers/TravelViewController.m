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
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 10, kWidth, 40)];
    self.mySearchBar.delegate = self;
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.placeholder = @"搜索目的地";
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
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
    NSArray *ayyay1 = [NSArray arrayWithArray:self.cityArray];
    [self.cityList.tags addObjectsFromArray:ayyay1];

    __block TravelViewController *weakself = self;
    [self.cityList setCompletionBlockWithSelected:^(NSInteger index) {
        weakself.mySearchBar.text = weakself.cityArray[index];
        for (NSString *str in weakself.searchList.tags) {
            if ([weakself.cityArray[index] isEqualToString:str]) {
                return;
            }
        }
        [weakself.searchList.tags addObject:weakself.cityArray[index]];
        if (weakself.searchList.tags.count > 10) {
            [weakself.searchList.tags removeObjectAtIndex:0];
        }
        [weakself.searchList.collectionView reloadData];
        SearchTravelViewController *search = [[SearchTravelViewController alloc]init];
        weakself.mySearchBar.hidden = YES;
        search.cityName = weakself.cityArray[index];
        [weakself.navigationController pushViewController:search animated:YES];
       
    }];
  [self.searchList setCompletionBlockWithSelected:^(NSInteger index) {
      SearchTravelViewController *search = [[SearchTravelViewController alloc]init];
      search.cityName = weakself.cityArray[index];

      [weakself.navigationController pushViewController:search animated:YES];
      weakself.mySearchBar.hidden = YES;

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

#pragma mark---UISearchBarDelegate

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self addWhiteView];
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
    [UIView animateWithDuration:0.6 animations:^{
        self.whiteView.frame = self.view.frame;
    }];
    return YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.6 animations:^{
        self.whiteView.frame = CGRectMake(0, -kHeight, kWidth, kHeight);
    }];
    self.mySearchBar.text = nil;

}
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

    [self.navigationController pushViewController:search animated:YES];
    self.mySearchBar.hidden = YES;

}
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
