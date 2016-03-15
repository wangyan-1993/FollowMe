//
//  TravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "TravelViewController.h"
#import "SecondTravelViewController.h"
@interface TravelViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;
@end

@implementation TravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [[NSURL alloc]initWithString:@"http://web.breadtrip.com/product/topics/"];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self.view addSubview:self.webView];
}
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSLog(@"%@", request);
//    switch (navigationType) {
//        case UIWebViewNavigationTypeOther:
//        {
//            SecondTravelViewController *secondTVC = [[SecondTravelViewController alloc]init];
//            secondTVC.string = [NSString stringWithFormat:@"%@", request];
//            [self.navigationController pushViewController:secondTVC animated:YES];
//        }
//            break;
//            
//        default:
//            break;
//    }
    return YES;
}
- (UIWebView *)webView{
    if (_webView == nil) {
        self.webView = [[UIWebView alloc]initWithFrame:self.view.frame];
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
