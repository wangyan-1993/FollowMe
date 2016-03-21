//
//  storyDetailsViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//
#define kstoryDetails @"http://api.breadtrip.com/v2/new_trip/spot/?"
#import "storyDetailsViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "storyDetailsView.h"
@interface storyDetailsViewController ()
@property (nonatomic, strong) storyDetailsView *storyDetailView;

@end

@implementation storyDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self workOne];
    
    [self.view addSubview:self.storyDetailView];
    
}
- (storyDetailsView *)storyDetailView{
    if (_storyDetailView == nil) {
        self.storyDetailView = [[storyDetailsView alloc] initWithFrame:self.view.frame];
    }
    return _storyDetailView;
}
- (void)workOne{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@spot_id=%@&spot_id=%@",kstoryDetails,self.spot_id,self.spot_id] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WLZLog(@"%@",responseObject);
        NSDictionary *rootDic = responseObject;
         if (rootDic[@"status"] == [NSNumber numberWithInteger:0]) {
             NSDictionary *dataDic = rootDic[@"data"];
        self.storyDetailView.dataDic = dataDic;
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
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
