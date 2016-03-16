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
@interface TravelViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    NSURL *url = [[NSURL alloc]initWithString:@"http://web.breadtrip.com/product/topics/"];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
    
}
-  (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}
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
        
        [self.webView stopLoading];
    }
    if ([string2 isEqualToString:@"book"]) {
        ThirdTravelViewController *third = [[ThirdTravelViewController alloc]init];
        third.urlString = urlStr;
        third.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:third animated:YES];
        [self.webView stopLoading];

    }
    
    return YES;
}


- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.webView.delegate = self;
        
    }
    return _webView;
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
