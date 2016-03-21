//
//  ThirdTravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ThirdTravelViewController.h"
#import "FourTravelViewController.h"
@interface ThirdTravelViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation ThirdTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *url = [[NSURL alloc]initWithString:self.urlString];
    self.navigationController.navigationBar.barTintColor = kMainColor;
self.title = @"介绍";
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    [self showBackBtn];

    [self.view addSubview:self.webView];


}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSString *urlStr = request.URL.absoluteString;
    NSArray *array = [urlStr componentsSeparatedByString:@"/"];
    NSInteger length = array.count;
    NSString *string1 = array[length-2];
    NSString *string2 = array.lastObject;
    WLZLog(@"%@", request);
    WLZLog(@"%ld", (long)navigationType);
    FourTravelViewController *four = [[FourTravelViewController alloc]init];
    switch (navigationType) {
        case UIWebViewNavigationTypeLinkClicked:
        {
            

            if ([string1 isEqualToString:@"detail"]) {
                four.title = @"产品详情";
            }
            if ([string1 isEqualToString:@"price_info"]) {
                four.title = @"价格信息";
            }
            if ([string1 isEqualToString:@"notice"]) {
                four.title = @"预订须知";
            }
            if ([string1 isEqualToString:@"schedule"]) {
                four.title = @"行程时间表";
            }
            four.urlString = request.URL.absoluteString;
            four.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:four animated:YES];
            [self.webView stopLoading];
        }
            break;
            case UIWebViewNavigationTypeOther:
        {
            if ([string1 isEqualToString:@"map"]) {
                four.title = @"地址";
                four.urlString = request.URL.absoluteString;
                four.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:four animated:YES];
                [self.webView stopLoading];

            }
            if ([string1 isEqualToString:@"order"]) {
                four.title = @"订单";
                four.urlString = request.URL.absoluteString;
                four.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:four animated:YES];
                [self.webView stopLoading];
                
            }

            if ([string2 isEqualToString:@"?type=info"]) {
                four.title = @"酒店详情";
                four.urlString = request.URL.absoluteString;
                four.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:four animated:YES];
                [self.webView stopLoading];

            }
            if ([string2 isEqualToString:@"?type=facility"]) {
                four.title = @"酒店设施";
                four.urlString = request.URL.absoluteString;
                four.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:four animated:YES];
                [self.webView stopLoading];

            }
            if ([string2 isEqualToString:@"?type=policy"]) {
                four.title = @"酒店声明";
                four.urlString = request.URL.absoluteString;
                four.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:four animated:YES];
                [self.webView stopLoading];

            }
            if ([urlStr rangeOfString:@"rooms"].location != NSNotFound) {
                four.title = @"酒店房型";
                four.urlString = request.URL.absoluteString;
                four.hidesBottomBarWhenPushed = YES;
                [self.navigationController pushViewController:four animated:YES];
                [self.webView stopLoading];
                
            }

            
        }
            break;
        default:
            break;
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
