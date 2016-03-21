//
//  ForeignViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ForeignViewController.h"




#import "JCTagListView.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CityViewController.h"

@interface ForeignViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
@property(nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UILabel *gpsLable;
@property(nonatomic, strong) UILabel *inLable;
@property(nonatomic, strong) JCTagListView *jctageLiseView;
@property(nonatomic, strong) NSMutableArray *overCityArray;
@property(nonatomic, strong) CityViewController *cityVC;


@end

@implementation ForeignViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self showBackBtn];
    
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    self.tableView.tableHeaderView = self.headView;
    
    self.tabBarController.tabBar.hidden = YES;
    
    //searchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, kWidth, 30)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入搜索您的信息";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.layer.cornerRadius = 10.0;
    self.searchBar.clipsToBounds = YES;
    [self.searchBar becomeFirstResponder];
    [self.view addSubview:self.searchBar];
    
    [self JcTagesAction];
    [self updateSelectCity];
    
}

-(void)updateSelectCity{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.breadtrip.com/hunter/products/v2/metadata/?with_citydata&with_sortdata&city_name=%E5%8C%97%E4%BA%AC" parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *rootDic = responseObject;
        //取出所有的城市；
        NSDictionary *citDac = rootDic[@"city_data"];
        
        //读取国外城市；
        NSDictionary *overDic = citDac[@"oversea_city"];
        self.overCityArray = [NSMutableArray new];
        for (NSDictionary *overName in overDic[@"all_city_list"]) {
            [self.overCityArray addObject:overName[@"name"]];
//            WLZLog(@"self.overCityArray = %@",self.overCityArray);
        }
        [self.tableView reloadData];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
}


-(void)JcTagesAction{
    
    self.jctageLiseView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, kWidth*0.25, kWidth, kHeight/6)];
    [self.jctageLiseView.tags addObjectsFromArray: @[@"日本"]];
    self.jctageLiseView.layer.cornerRadius = 15.0f;
    self.jctageLiseView.clipsToBounds = YES;
    self.jctageLiseView.tagStrokeColor = [UIColor whiteColor];
    self.jctageLiseView.tagTextColor = [UIColor whiteColor];
    [self.headView addSubview:self.jctageLiseView];
    __block ForeignViewController *weakSelf = self;
    [self.jctageLiseView setCompletionBlockWithSelected:^(NSInteger index) {
//        weakSelf.cityVC.selectStr = weakSelf.overCityArray[index];
        
        weakSelf.cityVC.stringName = weakSelf.overCityArray[index];
    
    }];
    
    
}
#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        
    }
    cell.textLabel.text = self.overCityArray[indexPath.row];
    cell.backgroundColor = kMainColor;
    
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.cityVC.stringName = self.overCityArray[indexPath.row];
    [self.navigationController pushViewController:self.cityVC animated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
//    return self.allCityArray.count;
        return 30;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 30;
}

-(UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kWidth, kHeight/4)];
        _gpsLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kWidth/2, 30)];
        _gpsLable.backgroundColor = [UIColor clearColor];
        _gpsLable.text = @"GPS定位失败";
        _gpsLable.textColor = [UIColor whiteColor];
        _gpsLable.font = [UIFont systemFontOfSize:13.0];
        
        [_headView addSubview:self.gpsLable];
        _headView.backgroundColor = kMainColor;
        
        
        self.inLable = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight/5, kWidth, 30)];
        
        self.inLable.text = @"全部城市";
        self.inLable.font = [UIFont systemFontOfSize:13];
        self.inLable.textColor = [UIColor whiteColor];
        [self.headView addSubview:self.jctageLiseView];
        [_headView addSubview:self.inLable];
        
        
        UILabel *inlable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kWidth/3, 30)];
        inlable.backgroundColor = [UIColor clearColor];
        inlable.text = @"国外热门城市";
        inlable.textColor = [UIColor whiteColor];
        inlable.font = [UIFont systemFontOfSize:13.0];
        [_headView addSubview:inlable];
        
        
        
    }
    return _headView;
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kWidth, kHeight -150)];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = kMainColor;
        [self.view addSubview:self.tableView];
        
    }
    return _tableView;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.tabBarController.tabBar.hidden = YES;
    
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    //    self.navigationItem.leftBarButtonItem.hi
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
