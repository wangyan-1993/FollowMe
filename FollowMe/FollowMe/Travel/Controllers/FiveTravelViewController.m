//
//  FiveTravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FiveTravelViewController.h"
#import "ThirdTravelViewController.h"
@interface FiveTravelViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation FiveTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [[NSURL alloc]initWithString:self.urlString];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self showBackBtn];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.title = self.name;
    [self.view addSubview:self.webView];
    
    
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%ld", (long)navigationType);
    NSString *urlStr = request.URL.absoluteString;
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    NSInteger length = array.count;
    NSString *string1 = array[length-2];
    if (![string1 isEqualToString:@"product"] && ![string1 isEqualToString:@"hotel"]) {
        ThirdTravelViewController *third = [[ThirdTravelViewController alloc]init];
        third.urlString = urlStr;
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
