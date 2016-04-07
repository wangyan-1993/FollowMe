//
//  searchForWorldViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//
#define kSearchWorldFirst @"http://api.breadtrip.com/v2/search/?key="
#define kSearchWorldLast @"&start=0&count=20&data_type=";
#import "searchForWorldViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "VOSegmentedControl.h"
#import "destinationTableViewCell.h"
#import "correlationStoryTableViewCell.h"
#import "farinaTableViewCell.h"
#import "destination.h"
#import "correlation.h"
#import "farina.h"
#import "searchViewController.h"
#import "specialViewController.h"
#import "PersonViewController.h"
@interface searchForWorldViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>{
//    NSInteger _page;
}
@property (nonatomic, strong) UISearchBar *mySearchBar;
@property (nonatomic, strong) UITableView *tableView1;
@property (nonatomic, strong) UITableView *tableView2;
@property (nonatomic, strong) UITableView *tableView3;
@property (nonatomic, strong) VOSegmentedControl *segementedControl;
//相关目的地
@property (nonatomic, strong) NSMutableArray *placeCityNameArray;
@property (nonatomic, strong) NSMutableArray *tripsArray;
@property (nonatomic, strong) NSMutableArray *usersArray;
@property (nonatomic, strong) NSMutableArray *placeTypeArray;
@property (nonatomic, strong) NSMutableArray *placeIdArray;
@property (nonatomic, strong) NSMutableArray *tripsIdArray;
@property (nonatomic, strong) NSMutableArray *userIdArray;
@end

@implementation searchForWorldViewController
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mySearchBar.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tabBarController.tabBar.hidden = YES;
    [self showWhiteBackBtn];
    // Do any additional setup after loading the view.
//    WLZLog(@"%@",self.keyId);
    [self workOne];
    [self.view addSubview:self.segementedControl];
    [self.view addSubview:self.tableView1];
    //搜索框
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
}



#pragma mark    ----------分段选择---------
- (VOSegmentedControl *)segementedControl{
    if (_segementedControl == nil) {
        self.segementedControl = [[VOSegmentedControl alloc] initWithSegments:@[@{VOSegmentText: @"相关目的地"},@{VOSegmentText:@"相关游记&故事集"},@{VOSegmentText: @"个人"}]];
        self.segementedControl.contentStyle = VOContentStyleTextAlone;
        self.segementedControl.indicatorStyle = VOSegCtrlIndicatorStyleBottomLine;
        self.segementedControl.backgroundColor = [UIColor groupTableViewBackgroundColor];
        self.segementedControl.selectedBackgroundColor = self.segementedControl.backgroundColor;
        self.segementedControl.selectedTextColor = kMainColor;
        self.segementedControl.selectedIndicatorColor = kMainColor;
        self.segementedControl.allowNoSelection = NO;
        self.segementedControl.frame = CGRectMake(0, 64, kWidth, 44);
        self.segementedControl.indicatorThickness = 4;
        self.segementedControl.tag = 1;
        [self.segementedControl setIndexChangeBlock:^(NSInteger index) {
//            WLZLog(@"1: block --> %@", @(index));
        }];
        [self.segementedControl addTarget:self action:@selector(segmentCtrlValuechange:) forControlEvents:UIControlEventValueChanged];
    }
    return _segementedControl;

}
- (void)segmentCtrlValuechange: (VOSegmentedControl *)segmentCtrl{
    NSInteger index = segmentCtrl.selectedSegmentIndex;
    switch (index) {
        case 0:
//            WLZLog(@"0 clicked");
            [self viewDidLoad];
            break;
        case 1:
//            WLZLog(@"1 clicked");
   
            [self.tableView1 removeFromSuperview];
            [self.tableView3 removeFromSuperview];
            [self.view addSubview:self.tableView2];
            [self workOne];

            break;
        case 2:
//            WLZLog(@"2 clicked");
            [self.tableView2 removeFromSuperview];
            [self.tableView1 removeFromSuperview];
            [self.view addSubview:self.tableView3];
            [self workOne];
            
            break;
        default:
            break;
    }
}
#pragma mark    ----------搜索框传值---------
- (UISearchBar *)mySearchBar{
    if (_mySearchBar == nil) {
        self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(70, 7, kWidth-80, 30)];
        self.mySearchBar.delegate = self;
        self.mySearchBar.placeholder = @"搜索目的地、游记、故事集、用户";
        self.mySearchBar.text = self.text;
        self.mySearchBar.backgroundColor = [UIColor clearColor];
    }
    return _mySearchBar;
}
#pragma mark --------------网络请求
- (void)workOne{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
 [manger GET:[NSString stringWithFormat:@"http://api.breadtrip.com/v2/search/?key=%@&start=0&count=20&data_type=",self.keyId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
     //WLZLog(@"%@",downloadProgress);
 } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
     
     
    // WLZLog(@"%@",responseObject);
     NSDictionary *rootDic = responseObject;
     NSDictionary *dataDic = rootDic[@"data"];
     //请求相关目的地
     NSArray *placesArray = dataDic[@"places"];
     if (self.placeCityNameArray.count > 0) {
         [self.placeCityNameArray removeAllObjects];
     }
          for (NSDictionary *dic in placesArray) {
         destination *model = [[destination alloc] initWithDictionary:dic];
              [self.placeTypeArray addObject:dic[@"type"]];
              [self.placeIdArray addObject:dic[@"id"]];
         [self.placeCityNameArray addObject:model];
     }
     //请求相关游记
     if (self.tripsArray.count > 0) {
         [self.tripsArray removeAllObjects];
     }

     NSArray *tripsArray = dataDic[@"trips"];
     for (NSDictionary *dic in tripsArray) {
         correlation *model = [[correlation alloc] initWithDictionary:dic];
         [self.tripsIdArray addObject:dic[@"id"]];
         [self.tripsArray addObject:model];
     }
     if (self.usersArray.count>0) {
         [self.usersArray removeAllObjects];
     }
     NSArray *users = dataDic[@"users"];
     for (NSDictionary *dic in users) {
         farina *model = [[farina alloc] initWithDictionary:dic];
         [self.usersArray addObject:model];
         [self.userIdArray addObject:dic[@"id"]];
         
     }
     
    [self.tableView1 reloadData];
     [self.tableView2 reloadData];
     [self.tableView3 reloadData];
     
 } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//     WLZLog(@"%@",error);
 }];
}
#pragma mark --------------tableView的代理

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
    
        destinationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView1" forIndexPath:indexPath];
             cell.model = self.placeCityNameArray[indexPath.row];
       cell.backgroundColor = kCollectionColor;
        return cell;
    }
else if ([tableView isEqual:self.tableView2])
    {
        correlationStoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView2" forIndexPath:indexPath];
        cell.model = self.tripsArray[indexPath.row];
        cell.backgroundColor = kCollectionColor;
        return cell;
    }
    else {
        farinaTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableView3" forIndexPath:indexPath];
        cell.model = self.usersArray[indexPath.row];
        cell.backgroundColor = kCollectionColor;
        return cell;
    }}
    

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([tableView isEqual:self.tableView1]) {
    return self.placeCityNameArray.count;
            }
    else if ([tableView isEqual:self.tableView2]){
        return self.tripsArray.count;
    }
    else {
        return self.usersArray.count;
    
    }
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if ([tableView isEqual:self.tableView1]) {
        searchViewController *seaVC = [[searchViewController alloc] init];
        seaVC.type = self.placeTypeArray[indexPath.row];
        seaVC.userId = self.placeIdArray[indexPath.row];
        [self.navigationController pushViewController:seaVC animated:YES];
    }
    else if ([tableView isEqual:self.tableView2]){
        specialViewController *specialVC = [[specialViewController alloc] init];
        
        specialVC.userId = self.tripsIdArray[indexPath.row];
        WLZLog(@"%@",specialVC.userId);
        [self.navigationController pushViewController:specialVC animated:YES];
    }
    else if ([tableView isEqual:self.tableView3]){
        PersonViewController *person = [[PersonViewController alloc] init];
        
        person.personId = self.userIdArray[indexPath.row];
        [self.navigationController pushViewController:person animated:NO];
    }
}
#pragma mark --------------tableView懒加载
- (UITableView *)tableView1{
    if (_tableView1 == nil) {
        self.tableView1 = [[UITableView alloc] initWithFrame:CGRectMake(0, 109, kWidth, kHeight) style:UITableViewStylePlain];
        [self.tableView1 registerNib:[UINib nibWithNibName:@"destinationTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableView1"];
        self.tableView1.delegate = self;
        self.tableView1.dataSource = self;
        self.tableView1.rowHeight = 60;
        self.tableView1.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView1.tag = 1;

    }
    return _tableView1;
}
- (UITableView *)tableView2{
    if (_tableView2 == nil) {
        self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(0, 109, kWidth, kHeight-109) style:UITableViewStylePlain];
        self.tableView2.delegate = self;
        self.tableView2.dataSource = self;
        [self.tableView2 registerNib:[UINib nibWithNibName:@"correlationStoryTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableView2"];
        self.tableView2.rowHeight = 130;
        self.tableView2.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView2.tag = 2;

    }
    return _tableView2;

}
- (UITableView *)tableView3{
    if (_tableView3 == nil) {
        self.tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(0, 109, kWidth, kHeight) style:UITableViewStylePlain];
        self.tableView3.delegate = self;
        self.tableView3.dataSource = self;
      [self.tableView3 registerNib:[UINib nibWithNibName:@"farinaTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableView3"];
        self.tableView3.rowHeight = 60;
        self.tableView3.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        self.tableView3.tag = 3;
    }
    return _tableView3;
    
}
#pragma mark ----------------数组懒加载
- (NSMutableArray *)userIdArray{
    if (_userIdArray == nil) {
        self.userIdArray = [NSMutableArray new];
    }
    return _userIdArray;
}
- (NSMutableArray *)tripsIdArray{
    if (_tripsIdArray == nil) {
        self.tripsIdArray = [NSMutableArray new];
    }
    return _tripsIdArray;
}
- (NSMutableArray *)placeIdArray{
    if (_placeIdArray == nil) {
        self.placeIdArray = [NSMutableArray new];
    }
    return _placeIdArray;
}
- (NSMutableArray *)placeTypeArray {
    if (_placeTypeArray == nil) {
        self.placeTypeArray = [NSMutableArray new];
    }
    return _placeTypeArray;
}
- (NSMutableArray *)placeCityNameArray{
    if (_placeCityNameArray == nil) {
        self.placeCityNameArray = [NSMutableArray new];
    }
    return _placeCityNameArray;
}
- (NSMutableArray *)tripsArray{
    if (_tripsArray == nil) {
        self.tripsArray = [NSMutableArray new];
    }
    return _tripsArray;
}
- (NSMutableArray *)usersArray{
    if (_usersArray == nil) {
        self.usersArray = [NSMutableArray new];
    }
    return _usersArray;
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
