//
//  nearByViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "nearByViewController.h"
#import "VOSegmentedControl.h"
#import "PullingRefreshTableView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "nearByTableViewCell.h"
#import "nearByModel.h"
#import "ProgressHUD.h"
#import "AppDelegate.h"

@interface nearByViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate>{
    NSString *kNearBy;
    NSInteger _pagecount;
}
@property (nonatomic, strong) VOSegmentedControl *segment;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, assign) BOOL refreash;
@end

@implementation nearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=0&count=20&latitude=34.612575&longitude=112.42039799999998";
    _pagecount = 0;
    [self.view addSubview:self.segment];
    self.title = @"我的附近";
    [self netWork];
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];
    
 
    
    
   
}

#pragma mark -----网络请求------
- (void)netWork{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:[NSString stringWithFormat:@"%@&start=%ld",kNearBy,(long)_pagecount] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_pagecount == 0) {
            [ProgressHUD showSuccess:@"请求成功"];
        }else{
            [ProgressHUD showSuccess:@"加载成功"];
        }
//        WLZLog(@"%@",responseObject);
        
        NSDictionary *allDic = responseObject;
        NSArray *itemsArray = allDic[@"items"];
        //解析boolean类型
        Boolean more = [allDic[@"more"] boolValue];
        if (_refreash) {
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
            }

        }
               if (more == 1) {
           for (NSDictionary *dic in itemsArray) {
               nearByModel *model = [[nearByModel alloc] initWithDictionary:dic];
               [self.allArray addObject:model];
           }
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

    }];
}
#pragma mark ---- tableView代理方法
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    nearByTableViewCell *nearByCell = [tableView dequeueReusableCellWithIdentifier:@"nearByCell" forIndexPath:indexPath];
    nearByCell.model = self.allArray[indexPath.row];
    return nearByCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
        return self.allArray.count;
}
#pragma mark ---- PullingRefreshTableView代理方法
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [ProgressHUD show:@"正在刷新，请稍候"];
    _pagecount = 0;
    self.refreash = YES;
    
    [self performSelector:@selector(netWork) withObject:nil afterDelay:1.0];
}
//上拉加载
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [ProgressHUD show:@"正在为您加载，请稍候"];
    _pagecount += 20;
    self.refreash = NO;
    
    [self performSelector:@selector(netWork) withObject:nil afterDelay:1.0];
}
//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

#pragma mark ---- 第三方segment懒加载
- (VOSegmentedControl *)segment{
    if (_segment == nil) {
        self.segment = [[VOSegmentedControl alloc]
                        initWithSegments:@[@{VOSegmentText: @"全部"},@{VOSegmentText: @"景点"},@{VOSegmentText: @"住宿"},@{VOSegmentText: @"餐厅"},@{VOSegmentText: @"休闲娱乐"},@{VOSegmentText: @"购物"}]];
        self.segment.contentStyle = VOContentStyleTextAlone;
//        self.segment.indicatorStyle = VOSegCtrlIndicatorStyleBox;
        self.segment.animationType = VOSegCtrlAnimationTypeSmooth;
        self.segment.backgroundColor = [UIColor whiteColor];
        self.segment.selectedTextColor = [UIColor whiteColor];
        self.segment.selectedBackgroundColor = kMainColor;
        self.segment.allowNoSelection = NO;
        self.segment.frame = CGRectMake(0, 68, kWidth, 30);
        self.segment.indicatorThickness = 10;
        self.segment.indicatorCornerRadius = 15;
        
        [self.view addSubview:self.segment];
        [self.segment setIndexChangeBlock:^(NSInteger index) {
        }];
        [self.segment addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];

    }
    return _segment;
}
#pragma mark  ------ segment的点击方法------
- (void)segmentCtrlValuechange:(VOSegmentedControl *)segmentctrl{
 
    switch (segmentctrl.selectedSegmentIndex) {
        case 0:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            [self netWork];
            [self.tableView reloadData];

            self.refreash = YES;
            break;
        case 1:
            _pagecount = 0;

            [self.allArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=11&start=0&count=20&latitude=34.612591&longitude=112.42038000000002";
            [self netWork];
            [self.tableView reloadData];
            break;
        case 2:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=10&start=0&count=20&latitude=34.612591&longitude=112.42038000000002";
             [self netWork];
            [self.tableView reloadData];
            break;
        case 3:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=5&start=0&count=20&latitude=34.612591&longitude=112.42038000000002";
             [self netWork];
            [self.tableView reloadData];
            break;
        case 4:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=21&start=0&count=20&latitude=34.612591&longitude=112.42038000000002";
             [self netWork];
            [self.tableView reloadData];
            break;
        case 5:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=6&start=0&count=20&latitude=34.612591&longitude=112.42038000000002";
             [self netWork];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}
#pragma mark  ------ tableView的懒加载------
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 100, kWidth, kHeight-144) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 120;
        [self.tableView registerNib:[UINib nibWithNibName:@"nearByTableViewCell" bundle:nil] forCellReuseIdentifier:@"nearByCell"];
        
    }
    return _tableView;
}

#pragma mark ---------allArray的懒加载
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
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
