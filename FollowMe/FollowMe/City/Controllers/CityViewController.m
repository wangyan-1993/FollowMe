//
//  CityViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "CityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "UIViewController+KNSemiModal.h"
#import "cityModel.h"
#import "cityFirstTableViewCell.h"


static NSString *identifier = @"cell";

@interface CityViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
//segement中遇到的属性；
@property(nonatomic, strong) UISegmentedControl *segmented;
@property(nonatomic, strong) UIView *firstView;
@property(nonatomic, strong) UIView *secondView;
@property(nonatomic, strong) UIView *thirdView;
@property(nonatomic, strong) UISearchBar *mySearchBar;
@property(nonatomic, strong) NSMutableArray *listArray;

@property(nonatomic, strong) UITableView *tableView;



@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    
    //搜索框；
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 10, kWidth, 40)];
    self.mySearchBar.delegate = self;
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.placeholder = @"搜索目的地";
    
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    
    
    //SegmentedControl :用到的方法；
    NSArray *segment = [[NSArray alloc] initWithObjects:@"主题",@"日期筛选",@"智能排序", nil];
    _segmented = [[UISegmentedControl alloc] initWithItems:segment];
    
    _segmented.frame = CGRectMake(0, 64, kWidth, 35);
    _segmented.tintColor = [UIColor grayColor];
    [_segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmented];
    
    //注册cell；
    
    
    [self.tableView registerNib:[UINib nibWithNibName:@"cityFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    
    
    [self uptataConfig];
    
    
}

#pragma mark-------------数据加载；
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0
//http://api.breadtrip.com/hunter/products/v2/metadata/?city_name=%E5%8C%97%E4%BA%AC&sign=fea9319e0234dc4846d020b1cd6df45d&with_citydata=true&with_sortdata=true
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0

//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&lat=34.6134350337019&lng=112.4140454160212&publish_date=20160316144222&sign=48bd766806c329244c91cf996f593f37&sorted_id=1&start=0
//体验详情：http://web.breadtrip.com/hunter/product/11971/?bts=app_tab
//价格日历：http://web.breadtrip.com/tp/customization/11971/calendar/10113/

//

//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&sign=8d6cd1ac4402ef780c44b3b629a07af7&start=0

-(void)uptataConfig{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&lat=34.61342700736265&lng=112.4140811801292&sign=ac6a66157da8fd3fa171fa0091e282ba&start=0" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dictio = responseObject;
        
        for (NSDictionary *dic in dictio[@"product_list"]) {
            cityModel *model = [[cityModel alloc]initWithCity:dic];
//            [cityModel setValuesForKeysWithDictionary:dic];
            [self.listArray addObject:model];
            
//            [self.listArray addObject:dic];
        }
        [self.tableView reloadData];
        
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
    
    self.firstView = [[UIView alloc]initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 500, [UIScreen mainScreen].bounds.size.width, 500)];
    _firstView.backgroundColor = [UIColor whiteColor];
    [self presentSemiView:_firstView];
    
}
//日期筛选点击方法
-(void)dataChose{
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - kHeight*2/3, kWidth, kHeight*2/3)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self presentSemiView:_segmented];
    
    
    
}
//排序点击方法
-(void)orderTitle{
    
    
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 1/3*kHeight, kWidth, 2/3*kHeight)];
    [self presentSemiView:_thirdView];
    
    
    
}



#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cityFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    
//    if (indexPath.row > self.listArray.count) {
//        
//        cell.model = self.listArray[indexPath.row];
//
//    }
    cell.model = self.listArray[indexPath.row];
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHeight*0.5;
}




#pragma mark--------------懒加载；

-(NSMutableArray *)listArray{
    
    if (_listArray == nil) {
        self.listArray = [NSMutableArray new];
    }
    return _listArray;
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 105, kWidth, kHeight - 144) style:UITableViewStylePlain];
        
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
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
