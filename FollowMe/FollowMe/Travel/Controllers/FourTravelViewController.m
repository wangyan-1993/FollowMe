//
//  FourTravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FourTravelViewController.h"
#import "ProgressHUD.h"
@interface FourTravelViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation FourTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [ProgressHUD show:@"数据正在加载"];
    NSURL *url = [[NSURL alloc]initWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self showBackBtn];
    self.navigationController.navigationBar.barTintColor = kMainColor;

    [self.view addSubview:self.webView];
    

}
- (void)viewWillDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [ProgressHUD showSuccess:@"数据已加载完毕"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('hotel-bottom diff')[0].style.display = 'none'"];
    
}

- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.webView.delegate = self;
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, kHeight-40, kWidth, 50)];
        view.backgroundColor = [UIColor whiteColor];
        [self.webView addSubview:view];

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
