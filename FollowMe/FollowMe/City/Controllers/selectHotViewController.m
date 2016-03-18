//
//  selectHotViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "selectHotViewController.h"

@interface selectHotViewController ()

@end

@implementation selectHotViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //http://api.breadtrip.com/hunter/products/v2/search/hotkeywords/?city_name=%E6%AD%A6%E6%B1%89&sign=181bd33c9e5b30fd73e4725b68c5fdcc
    
    //点击明信片：http://api.breadtrip.com/hunter/products/v2/search/?city_name=%E6%AD%A6%E6%B1%89&lat=34.6134073236616&lng=112.414083492134&q=%E6%98%8E%E4%BF%A1%E7%89%87&start=0
    //点击聚会  ：http://api.breadtrip.com/hunter/products/v2/search/?city_name=%E6%AD%A6%E6%B1%89&lat=34.6134073236616&lng=112.414083492134&q=%E8%81%9A%E4%BC%9A&start=0
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
