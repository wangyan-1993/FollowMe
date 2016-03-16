//
//  CityViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "CityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

@interface CityViewController ()

@property(nonatomic, strong) UISegmentedControl *segmented;



@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //SegmentedControl :用到的方法；
    NSArray *segment = [[NSArray alloc] initWithObjects:@"主题",@"日期筛选",@"智能排序", nil];
    _segmented = [[UISegmentedControl alloc] initWithItems:segment];
    
    _segmented.frame = CGRectMake(0, 64, kWidth, 35);
    _segmented.tintColor = [UIColor redColor];
    [_segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmented];
    
    
    
    [self uptataConfig];
    
    
}

#pragma mark-------------数据加载；
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0
//http://api.breadtrip.com/hunter/products/v2/metadata/?city_name=%E5%8C%97%E4%BA%AC&sign=fea9319e0234dc4846d020b1cd6df45d&with_citydata=true&with_sortdata=true
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0

-(void)uptataConfig{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //        WLZLog(@"%@",responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
     
    }];
    

}
#pragma mark---------segmentControl委托方法的实现

-(void)segmentedAction:(UISegmentedControl *)segmen{
    NSInteger index = segmen.selectedSegmentIndex;
    

    
    switch (index) {
        case 0:
            [self mainTitle];

            break;
        case 1:
            [self dataChose];
            break;
        case 2:
            [self orderTitle];
            break;
            
        default:
            break;
    }
    
}
//主题点击方法
-(void)mainTitle{
    
    
}
//日期筛选点击方法
-(void)dataChose{
    
    
}
//排序点击方法
-(void)orderTitle{
    
    
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
