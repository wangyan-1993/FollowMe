//
//  PersonViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "PersonViewController.h"

@interface PersonViewController ()

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://api.breadtrip.com/v3/user/2384156923/
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
    //http://web.breadtrip.com/hunter/2384305001/v2/
    NSURL *url = [NSURL URLWithString:@"http://web.breadtrip.com/hunter/2384305001/v2/"];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
