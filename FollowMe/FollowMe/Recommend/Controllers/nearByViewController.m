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
#import <AMapLocationKit/AMapLocationKit.h>
#import "nearDetailsViewController.h"
@interface nearByViewController ()<UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,AMapLocationManagerDelegate>{
    NSString *kNearBy;
    NSInteger _pagecount;
    //经纬度
    CGFloat _lat;
    CGFloat _lon;
    NSString *kAllDistance;
    NSString *kNetWork;
}
@property (nonatomic, strong) VOSegmentedControl *segment;
@property (nonatomic, strong) PullingRefreshTableView *tableView;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, assign) BOOL refreash;
@property (nonatomic, strong) AMapLocationManager *manger;
@property (nonatomic, strong) NSMutableArray *detailIdArray;
@property (nonatomic, strong) NSMutableArray *typeArray;
@end

@implementation nearByViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self mapLocation];
    [self showWhiteBackBtn];

    
    kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=0&count=20";
    //在模拟器上运行
//    _lat=34.612575;
//    _lon=112.42039799999998;
    
    
    _pagecount = 0;
    [self.view addSubview:self.segment];
    self.title = @"我的附近";
   // [self netWork];
    [self.view addSubview:self.tableView];
    //[self.tableView launchRefreshing];
    //添加轻扫手势
    //向左滑动
    UISwipeGestureRecognizer *recognizer;
    recognizer = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromleft:)];
    [recognizer setDirection:(UISwipeGestureRecognizerDirectionLeft)];
    [self.tableView addGestureRecognizer:recognizer];
    //向右滑动
    UISwipeGestureRecognizer *recognizer1;
    recognizer1 = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFromright:)];
    [recognizer1 setDirection:(UISwipeGestureRecognizerDirectionRight)];
    [self.tableView addGestureRecognizer:recognizer1];
 
    [self.tableView launchRefreshing];
    
   
}
- (void)mapLocation{
    [AMapLocationServices sharedServices].apiKey = (NSString *)kZhGaodeMapKey;
    self.manger = [[AMapLocationManager alloc] init];
    
    // 带逆地理信息的单次定位（返回坐标和地址信息）
    [self.manger setDesiredAccuracy:kCLLocationAccuracyHundredMeters];
    //   定位超时时间，可修改，最小2s
    self.manger.locationTimeout = 3;
    //    //   逆地理请求超时时间，可修改，最小2s
    self.manger.reGeocodeTimeout = 3;
    // 带逆地理（返回坐标和地址信息） YES改为NO,将不会返回地理信息
    [self.manger requestLocationWithReGeocode:YES completionBlock:^(CLLocation *location, AMapLocationReGeocode *regeocode, NSError *error) {
        if (error) {
            WLZLog(@"locError:{%ld - %@}",(long)error,error.localizedDescription);
            if (error.code == AMapLocationErrorLocateFailed) {
                return ;
            }
        }
        WLZLog(@"location:{lat:%.20f; lon:%f; accuracy:%.10f}", location.coordinate.latitude, location.coordinate.longitude, location.horizontalAccuracy);
        //在真机
        _lat = location.coordinate.latitude;
        _lon = location.coordinate.longitude;
        if (regeocode)
        {
           
            NSLog(@"reGeocode:%@", regeocode);
            
          
        }
    }];

}
//
#pragma mark -----网络请求------
- (void)netWork{
    [self mapLocation];
        kNetWork = [NSString stringWithFormat:@"%@&start=%ld&latitude=%.15f&longitude=%.15f",kNearBy,(long)_pagecount,_lat,_lon];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:kNetWork parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"")
//        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (_pagecount == 0) {
            [ProgressHUD showSuccess:@"请求成功"];
        }else{
            [ProgressHUD showSuccess:@"加载成功"];
        }
        //WLZLog(@"%@",responseObject);
        
        
        NSDictionary *allDic = responseObject;
        NSArray *itemsArray = allDic[@"items"];
        //解析boolean类型
        Boolean more = [allDic[@"more"] boolValue];
        if (_refreash) {
            if (self.allArray.count > 0) {
                [self.allArray removeAllObjects];
                [self.detailIdArray removeAllObjects];
                [self.typeArray removeAllObjects];
            }

        }
               if (more == 1) {
           for (NSDictionary *dic in itemsArray) {
               nearByModel *model = [[nearByModel alloc] initWithDictionary:dic];
               [self.allArray addObject:model];
               [self.detailIdArray addObject:dic[@"id"]];
               [self.typeArray addObject: dic[@"type"]];
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
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    nearDetailsViewController *nearVC = [[nearDetailsViewController alloc] init];
    nearVC.detailId = self.detailIdArray[indexPath.row];
    nearVC.typeId = self.typeArray[indexPath.row];
    [self.navigationController pushViewController:nearVC animated:YES];
    
}
#pragma mark ---- PullingRefreshTableView代理方法
//下拉刷新
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [ProgressHUD show:@"正在刷新，请稍候"];
    _pagecount = 0;
    self.refreash = YES;
    [self mapLocation];
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
            [self.detailIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
             kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=0&count=20";
            [self netWork];
            [self.tableView reloadData];
           
//            self.refreash = YES;
            break;
        case 1:
            _pagecount = 0;

            [self.allArray removeAllObjects];
            [self.detailIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=11&count=20";
            [self netWork];
            [self.tableView reloadData];
            break;
        case 2:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            [self.detailIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=10&count=20";
             [self netWork];
            [self.tableView reloadData];
            break;
        case 3:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            [self.detailIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=5&count=20";
             [self netWork];
            [self.tableView reloadData];
            break;
        case 4:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            [self.detailIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=21&count=20";
             [self netWork];
            [self.tableView reloadData];
            break;
        case 5:
            _pagecount = 0;
            [self.allArray removeAllObjects];
            [self.detailIdArray removeAllObjects];
            [self.typeArray removeAllObjects];
            kNearBy = @"http://api.breadtrip.com/place/pois/nearby/?category=6&count=20";
             [self netWork];
            [self.tableView reloadData];
            break;
            
        default:
            break;
    }
}
//添加向右滑动的轻扫手势
- (void)handleSwipeFromleft:(UISwipeGestureRecognizer *)recoginer {
    if (recoginer.direction == UISwipeGestureRecognizerDirectionLeft) {
      
            self.segment.selectedSegmentIndex = self.segment.selectedSegmentIndex + 1;

    }    [self segmentCtrlValuechange:self.segment];
}
//添加向左滑动的轻扫手势
- (void)handleSwipeFromright:(UISwipeGestureRecognizer *)recoginer {
    if (recoginer.direction == UISwipeGestureRecognizerDirectionRight) {
        
        self.segment.selectedSegmentIndex = self.segment.selectedSegmentIndex - 1;
        
    }    [self segmentCtrlValuechange:self.segment];
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
- (NSMutableArray *)detailIdArray{
    if (_detailIdArray == nil) {
        self.detailIdArray = [NSMutableArray new];
    }
    return _detailIdArray;
}
- (NSMutableArray *)typeArray{
    if (_typeArray == nil) {
        self.typeArray = [NSMutableArray new];
    }
    return _typeArray;
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
