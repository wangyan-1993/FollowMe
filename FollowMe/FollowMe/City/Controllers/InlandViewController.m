//
//  InlandViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "InlandViewController.h"

#import <AFNetworking/AFHTTPSessionManager.h>
#import "JCTagListView.h"
#import "CityViewController.h"
#import "ChoseCityModel.h"

@interface InlandViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

//tableview头部视图；
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UITableView *tableView;

//collectionview自适应宽度；
@property(nonatomic, strong) JCTagListView *jctageLiseView;
@property(nonatomic, strong) CityViewController *cityVC;

//装载国内全部城市
@property(nonatomic, strong) NSMutableArray *allCityArray;
//装载国内热门城市
@property(nonatomic, strong) NSMutableArray *allHotCityArray;

//装载国外城市；
@property(nonatomic, strong) NSMutableArray *overCityArray;

@property(nonatomic, strong) UILabel *inLable;

@property(nonatomic, strong) UILabel *gpsLable;

@property(nonatomic, strong) UISearchBar *searchBar;


@end

@implementation InlandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.view.backgroundColor = kMainColor;
    
    self.cityVC = [[CityViewController alloc] init];
    
    self.tabBarController.tabBar.hidden = YES;
    [self showBackBtn];
    
    
    
    //searchBar
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 10, kWidth, 30)];
    self.searchBar.delegate = self;
    self.searchBar.placeholder = @"请输入搜索您的信息";
    self.searchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.searchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.searchBar.layer.cornerRadius = 10.0;
    self.searchBar.clipsToBounds = YES;
    [self.view addSubview:self.searchBar];
    self.tableView.tableHeaderView = self.headView;
    [self jcCollectionView];
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
        //读取国内城市；
        NSDictionary *inlandDic = citDac[@"domestic_city"];
        self.allCityArray = [NSMutableArray new];
        self.allHotCityArray = [NSMutableArray new];
        for (NSDictionary *inName in inlandDic[@"all_city_list"]) {
            [self.allCityArray addObject:inName[@"name"]];
        }
        for (NSString *string in inlandDic[@"hot_city_list"]) {
            [self.allHotCityArray addObject:string];
        }
        
//        for (NSDictionary *titleDic in rootDic[@"tag_data"]) {
//            
//            [ChoseCityModel setValuesForKeysWithDictionary:titleDic];
//        }

        [self jcCollectionView];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
}


-(void)jcCollectionView{
    //初始化
    self.jctageLiseView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, kHeight*0.13, kWidth, kWidth/3)];
    //边框颜色
    self.jctageLiseView.canSelectTags = YES;
    self.jctageLiseView.tagCornerRadius = 15.0f;
    //字体颜色；
    self.jctageLiseView.tagTextColor = [UIColor whiteColor];
    self.jctageLiseView.tagStrokeColor = [UIColor whiteColor];
    
//    NSArray *cityArray = [NSArray arrayWithArray:self.allHotCityArray];
//        NSArray *array = @[@"北京",@"上海",@"广州",@"深圳",@"重庆",@"成都",@"武汉",@"西安"];

    //    WLZLog(@"cityArray === %@",cityArray);
    
    //可变数组传值
    [self.jctageLiseView.tags addObjectsFromArray:self.allHotCityArray];
    
    
        __block InlandViewController *weakSelf = self;
        [self.jctageLiseView setCompletionBlockWithSelected:^(NSInteger index) {
            weakSelf.cityVC = [[CityViewController alloc] init];
    
//            [weakSelf.cityVC.selects setTitle:weakSelf.allHotCityArray[index] forState:UIControlStateNormal];
            weakSelf.cityVC.stringName = weakSelf.allHotCityArray[index];
            
            
//            weakSelf.cityVC.stringName = weakSelf.allCityArray[index];
            
            [weakSelf.navigationController pushViewController:weakSelf.cityVC animated:NO];
                }];
    
    
    [self.headView addSubview:self.jctageLiseView];
    
}

#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        cell.textLabel.text = self.allCityArray[indexPath.row];
        cell.backgroundColor = kMainColor;
        
    
        return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    self.cityVC.stringName = self.allCityArray[indexPath.row];
    
    [self.navigationController pushViewController:self.cityVC animated:YES];
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.allCityArray.count;
//    return 30;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
  
    return 30;
}


#pragma mark==== 点击空白处回收键盘；
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.searchBar resignFirstResponder];
}



-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    
  
}


-(UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 60, kWidth, kHeight/3)];
        _gpsLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, kWidth/2, 30)];
        _gpsLable.backgroundColor = [UIColor clearColor];
        _gpsLable.text = @"GPS定位失败";
        _gpsLable.textColor = [UIColor whiteColor];
        _gpsLable.font = [UIFont systemFontOfSize:13.0];
        
        [_headView addSubview:self.gpsLable];
        _headView.backgroundColor = kMainColor;
        
        
        self.inLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 190, kWidth, 30)];
        
        self.inLable.text = @"全部城市";
        self.inLable.font = [UIFont systemFontOfSize:13];
        self.inLable.textColor = [UIColor whiteColor];
        [self.headView addSubview:self.jctageLiseView];
        [_headView addSubview:self.inLable];
        
        
        UILabel *inlable = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, kWidth/3, 30)];
        inlable.backgroundColor = [UIColor clearColor];
        inlable.text = @"国内热门城市";
        inlable.textColor = [UIColor whiteColor];
        inlable.font = [UIFont systemFontOfSize:13.0];
        [_headView addSubview:inlable];
        
        
        
    }
    return _headView;
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, kWidth, kHeight - 150)];
        
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
