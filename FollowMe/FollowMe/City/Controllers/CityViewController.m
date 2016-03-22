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
#import "DetailViewController.h"
#import "PersonViewController.h"
#import "selectCityViewController.h"
#import "selectHotViewController.h"
#import "InlandViewController.h"
#import "ForeignViewController.h"

#import "JRSegmentViewController.h"
#import "ProgressHUD.h"



static NSString *identifier = @"cell";

#define huiSE [UIColor colorWithRed:235/255 green:237/255 blue:235/255 alpha:0.5];
#define master [UIColor colorWithRed:239/255 green:192/255 blue:650/255 alpha:0.6];
@interface CityViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>



//segement中遇到的属性；
@property(nonatomic, strong) UISegmentedControl *segmented;
@property(nonatomic, strong) UIView *firstView;
@property(nonatomic, strong) UIView *secondView;
@property(nonatomic, strong) UIView *thirdView;

@property(nonatomic, strong) NSMutableArray *listArray;

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) UILabel *clasifyLable;


@property(nonatomic, strong) UIButton *clasifyButton;

@property(nonatomic, strong) UIButton *presonButton;

//@property(nonatomic, strong) UIButton *selectButton;









@end

@implementation CityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = huiSE;
    
//    self.title = @"城市猎人带你玩";
    self.navigationController.navigationItem.title= @"城市猎人带你玩";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    
//导航左侧视图按钮：
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, 80,44);

    

    [self.selectButton addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageview.image = [UIImage imageNamed:@"yyb_icon_back"];

  

    [self.selectButton setImage:imageview.image forState:UIControlStateNormal];
    //调整button图片的位置，四个数字分别指，图片距离button边界位置上下左右的距离；
    [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(10, self.selectButton.frame.size.width-25, 10, 0)];
    [self.selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 10)];
    if (self.selectStr == nil) {
        [self.selectButton setTitle:@"北京" forState:UIControlStateNormal];
    }else{
        [self.selectButton setTitle:self.stringName forState:UIControlStateNormal];
    }
    

    [self.navigationController.navigationBar addSubview:self.selectButton];

    
//导航右侧图片显示搜索
    self.presonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.presonButton.frame = CGRectMake(kWidth - 60, 10, 44,44);
    [self.presonButton addTarget:self action:@selector(presonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.presonButton setImage:[UIImage imageNamed:@"yyb_appdetail_showmore"] forState:UIControlStateNormal];

    

    

    //调整button图片的位置，四个数字分别指，图片距离button边界位置上下左右的距离；
//    [self.clasifyButton setImageEdgeInsets:UIEdgeInsetsMake(0, self.clasifyButton.frame.size.width-25, 0, 0)];
    [self.presonButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 10)];
    [self.navigationController.navigationBar addSubview:self.presonButton];
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithCustomView:self.presonButton];
    self.navigationItem.rightBarButtonItem = rightBar;
  
    UIBarButtonItem *leftbar = [[UIBarButtonItem alloc] initWithCustomView:self.presonButton];
    self.navigationItem.leftBarButtonItem = leftbar;
    leftbar.tintColor = [UIColor whiteColor];
    
    
    //SegmentedControl :用到的方法；
    NSArray *segment = [[NSArray alloc] initWithObjects:@"主题",@"日期筛选",@"智能排序", nil];
    _segmented = [[UISegmentedControl alloc] initWithItems:segment];
    _segmented.selectedSegmentIndex = 0;
    _segmented.tintColor = [UIColor whiteColor];
    
    
    _segmented.frame = CGRectMake(0, 64, kWidth, 35);
    _segmented.tintColor = [UIColor whiteColor];
    self.segmented.momentary = NO;
    [_segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmented];
    
    //首页图片
    
    
    
    //注册cell；
    
    [self.tableView registerNib:[UINib nibWithNibName:@"cityFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    if (self.stringName == nil) {
        self.stringName = @"北京";
    }
    
//    WLZLog(@"%@",self.stringName);
    
    //请求数据
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


//城市接口：http://api.breadtrip.com/hunter/products/v2/metadata/?with_citydata&with_sortdata&city_name=%E5%8C%97%E4%BA%AC
//点击城市详细接口：http://api.breadtrip.com/hunter/products/more/?city_name=%E8%A5%BF%E5%AE%89&start=0&lat=34.613475705487886&lng=112.41399171556088
//点击城市详细接口：http://api.breadtrip.com/hunter/products/more/?city_name=%E6%B7%B1%E5%9C%B3&start=0&lat=34.613475705487886&lng=112.41399171556088


//搜索图案接口：http://api.breadtrip.com/hunter/products/v2/search/hotkeywords/?city_name=%E5%8C%97%E4%BA%AC
//搜索点击城市接口：http://api.breadtrip.com/hunter/products/v2/search/?city_name=%E5%8C%97%E4%BA%AC&lat=34.613476&lng=112.413994&q=%E6%91%84%E5%BD%B1
//搜索点击城市接口：http://api.breadtrip.com/hunter/products/v2/search/?city_name=%E5%8C%97%E4%BA%AC&lat=34.613476&lng=112.413994&q=%E6%B2%B9%E7%94%BB


//主页点击原型图片接口：http://api.breadtrip.com/v3/user/2384305001/

-(void)uptataConfig{
    
    /*
     NSString *string = [NSString stringWithFormat:@"%@%@&offset=%d", kListData, self.name, _pageCount * 9];
     NSString *url = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     */
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/hunter/products/v2/?city_name=%@&lat=34.61342700736265&lng=112.4140811801292&sign=ac6a66157da8fd3fa171fa0091e282ba&start=0",self.stringName];
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
     
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [ProgressHUD show:@"正在为您请求数据"];
        NSDictionary *dictio = responseObject;
        
        for (NSDictionary *dic in dictio[@"product_list"]) {
            cityModel *model = [[cityModel alloc]initWithCity:dic];

            
            [self.listArray addObject:model];
            

        }
        [self.tableView reloadData];
        
        [ProgressHUD showSuccess:@"已成功"];
        
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
    
    [self.firstView removeFromSuperview];
    
    self.secondView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight - kHeight*2/3, kWidth, kHeight*2/3)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self presentSemiView:_segmented];
    
    
    
}
//排序点击方法
-(void)orderTitle{
    
    
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, 1/3*kHeight, kWidth, 2/3*kHeight)];
    //模态视图
    [self presentSemiView:_thirdView];
    
    
    
}



#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cityFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    cell.model = self.listArray[indexPath.row];
    [cell.ClassifyButton addTarget:self action:@selector(classAction) forControlEvents:UIControlEventTouchUpInside];
   
    
    
    
    return cell;
    
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    DetailViewController *detail = [[DetailViewController alloc] init];
    [self.navigationController pushViewController:detail animated:NO];

    
    
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;
//    return 10;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHeight*0.5;
}

#pragma mark---------------导航栏点击方法；

-(void)classAction{
    
    PersonViewController *person = [[PersonViewController alloc] init];
    [self.navigationController pushViewController:person animated:NO];

}

-(void)selectCity{
    
//    selectCityViewController *selectVC = [[selectCityViewController alloc] init];
//    [self.navigationController pushViewController:selectVC animated:YES];
    

//     InlandViewController *firstVC = [[InlandViewController alloc] init];
//     ForeignViewController *secondVC = [[ForeignViewController alloc] init];
//     
//     JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
//     vc.segmentBgColor = [UIColor colorWithRed:18.0f/255 green:50.0f/255 blue:110.0f/255 alpha:1.0f];
//     vc.indicatorViewColor = [UIColor whiteColor];
//     vc.titleColor = [UIColor whiteColor];
//     
//     [vc setViewControllers:@[firstVC, secondVC]];
//     [vc setTitles:@[@"热点", @"聚焦"]];
//     
//     [self.navigationController pushViewController:vc animated:YES];

     InlandViewController *firstVC = [[InlandViewController alloc] init];
    //隐藏功能
    firstVC.navigationItem.hidesBackButton = YES;
    firstVC.hidesBottomBarWhenPushed = YES;
    
     ForeignViewController *secondVC = [[ForeignViewController alloc] init];
    //隐藏功能
    secondVC.navigationItem.hidesBackButton = YES;
    secondVC.hidesBottomBarWhenPushed = YES;
    
     JRSegmentViewController *vc = [[JRSegmentViewController alloc] init];
    vc.navigationItem.hidesBackButton = YES;
    vc.hidesBottomBarWhenPushed = YES;
    [vc showBackBtn];
     vc.segmentBgColor = kMainColor;
     vc.indicatorViewColor = [UIColor whiteColor];
     vc.titleColor = [UIColor whiteColor];
     
     [vc setViewControllers:@[firstVC, secondVC]];
     [vc setTitles:@[@"国内", @"国外"]];
     
     [self.navigationController pushViewController:vc animated:YES];

    
    
 
}


-(void)presonAction{
    
    selectHotViewController *hotCity = [[selectHotViewController alloc] init];
    [self.navigationController pushViewController:hotCity animated:NO];
    
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
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 99, kWidth, kHeight - 144) style:UITableViewStylePlain];
        self.tableView.rowHeight = 285;
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.backgroundColor = master;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//   
//    self.hidesBottomBarWhenPushed = YES;
//    
//}

//-(UILabel *)clasifyLable{
//    if (_clasifyLable == nil) {
//        self.clasifyLable = [[UILabel alloc] init];
//    }
//    return _clasifyLable;
//}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
    self.selectButton.hidden = YES;

    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.selectButton.hidden = NO;
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
