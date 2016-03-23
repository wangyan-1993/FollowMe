//
//  BecomeHunterViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "BecomeHunterViewController.h"

@interface BecomeHunterViewController ()
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation BecomeHunterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.title = @"恭喜您加入我们";
    [self showBackBtn];
    self.view.backgroundColor = kMainColor;
    NSURL *url = [[NSURL alloc]initWithString:@"http://web.breadtrip.com/m/club/join_city_hunter/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
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
