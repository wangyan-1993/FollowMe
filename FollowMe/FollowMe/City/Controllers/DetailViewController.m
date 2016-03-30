//
//  DetailViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<UIWebViewDelegate>
@property(nonatomic, strong) UIWebView *webView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSString *strUrl = [NSString stringWithFormat:@"http://web.breadtrip.com/hunter/product/%@/?bts=app_tab",self.IDString];
    WLZLog(@"%@", strUrl);
    self.webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    NSURL *url = [NSURL URLWithString:strUrl];
    [self.webView loadRequest:[NSURLRequest requestWithURL:url]];
    self.webView.delegate = self;

    [self.view addSubview:self.webView];
    
    
    
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('affix')[0].style.display = 'none'"];
    //[webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('btn show show-hunter')[0].style.display = 'none'"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.getElementsByClassName('btn-contact')[0].style.display = 'none'"];
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
