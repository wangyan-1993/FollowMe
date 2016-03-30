//
//  CityViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "CityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>

//#import "UIViewController+KNSemiModal.h"

#import "cityModel.h"


#import "cityFirstTableViewCell.h"
#import "DetailViewController.h"
#import "PersonViewController.h"

#import "selectCityViewController.h"
#import "selectHotViewController.h"
//左右视图
#import "InlandViewController.h"
#import "ForeignViewController.h"


#import "JRSegmentViewController.h"
#import "ProgressHUD.h"
#import "JCTagListView.h"
#import "InformationViewController.h"

#import "ChoseCityModel.h"

#import "LDCalendarView.h"
#import "NSDate+extend.h"



static NSString *identifier = @"cell";

//#define huiSE [UIColor colorWithRed:235/255 green:237/255 blue:235/255 alpha:0.5];
#define master [UIColor colorWithRed:217/255 green:205/255 blue:202/255 alpha:1];

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface CityViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>



//segement中遇到的属性；
@property(nonatomic, strong) UISegmentedControl *segmented;
@property(nonatomic, strong) UIView *firstView;
@property(nonatomic, strong) UIView *secondView;
@property(nonatomic, strong) UIView *thirdView;
@property(nonatomic, strong) UIWindow *window;
/**
 *  背景视图
 */
@property(nonatomic, strong) UIView *backView;
//主页面数据
@property(nonatomic, strong) NSMutableArray *listArray;
//城市返回数据
@property(nonatomic, strong) NSMutableArray *backCityArray;
@property(nonatomic, strong) NSMutableArray *backIdArray;

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) UITableView *titleTableView;

@property(nonatomic, strong) UILabel *clasifyLable;


@property(nonatomic, strong) UIButton *clasifyButton;

@property(nonatomic, strong) UIButton *presonButton;


@property(nonatomic, strong) JCTagListView *tageListView;

//@property(nonatomic, strong) UIButton *selectButton;

//日历控件
@property (nonatomic, strong)LDCalendarView    *calendarView;//日历控件
@property (nonatomic, strong)NSMutableArray *seletedDays;//选择的日期
@property (nonatomic, copy)NSString *showStr;



//主题活动：
@property(nonatomic, strong) NSString *clasifyStr;
@property(nonatomic, strong) NSString *idStr;
@property(nonatomic, strong) NSString *dataStr;
@end
@implementation CityViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    if (self.stringName == nil) {
        self.stringName = @"北京";
    }
    self.idStr = @"1";
    self.clasifyStr = @"104";
//    self.dataStr = @"1";
//    self.title = @"城市猎人带你玩";
    self.navigationItem.title= @"城市猎人带你玩";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    
//导航左侧视图按钮：
    self.selectButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.selectButton.frame = CGRectMake(0, 0, 80,44);

    

    [self.selectButton addTarget:self action:@selector(selectCity) forControlEvents:UIControlEventTouchUpInside];

    
    UIImageView *imageview = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    imageview.image = [UIImage imageNamed:@"back"];

    [self.selectButton setImage:imageview.image forState:UIControlStateNormal];
    //调整button图片的位置，四个数字分别指，图片距离button边界位置上下左右的距离；
    [self.selectButton setImageEdgeInsets:UIEdgeInsetsMake(10, self.selectButton.frame.size.width-25, 10, 0)];
    [self.selectButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 10)];
    
    
    if (self.stringName == nil) {
        [self.selectButton setTitle:@"北京" forState:UIControlStateNormal];
        
//        self.stringName = @"北京";
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
//    _segmented.selectedSegmentIndex = 0;
    _segmented.tintColor = [UIColor whiteColor];
    
    
    _segmented.frame = CGRectMake(0, 64, kWidth, 35);
    _segmented.tintColor = [UIColor whiteColor];
    self.segmented.momentary = NO;
    [_segmented addTarget:self action:@selector(segmentedAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmented];
    
    //首页图片
    
    
    
    //注册cell；
    
    [self.tableView registerNib:[UINib nibWithNibName:@"cityFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    
    
//    WLZLog(@"%@",self.stringName);3
    
    //请求数据：主页面主要数据
    
    [self uptataConfig];
    
    //请求数据：主页面城市数据；
    [self updateCity];
    
    
    [self backFrrameCity];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   self.selectButton.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}
//点击上海，返回主页面主题日期筛选接口：
//http://api.breadtrip.com/hunter/products/v2/metadata/?city_name=%E5%8C%97%E4%BA%AC&sign=d8c4c7cc232d1b05a8b2e1c52b3e0020
//重庆：
//http://api.breadtrip.com/hunter/products/v2/metadata/?city_name=%E9%87%8D%E5%BA%86&sign=82e1194031afb5cb834881a9e1a88aa2
//主页面显示信息；
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E5%8C%97%E4%BA%AC&lat=34.61341401561965&lng=112.4141287407534&sign=8d8f4ba7e51d4f3a8440134ac5cbd58f&sorted_id=1&start=0
//http://api.breadtrip.com/hunter/products/v2/?city_name=%E9%87%8D%E5%BA%86&lat=34.61339564423128&lng=112.4140786252068&sign=bd55703bac6a8494569e982d3bfeed09&sorted_id=1&start=0



#pragma mark-------------数据加载；

-(void)uptataConfig{
    
   //&sign=ac6a66157da8fd3fa171fa0091e282ba
    
    NSString *idurl = [NSString stringWithFormat:@"&sorted_id=%@",self.idStr];
    NSString *dataUrl = [NSString stringWithFormat:@"&data_list=20%@",self.dataStr];
    NSString *clasilyScr = [NSString stringWithFormat:@"&tab_list%@",self.clasifyStr];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/hunter/products/v2/?city_name=%@&lat=34.61342700736265&lng=112.4140811801292%@%@%@&start=0",self.stringName,idurl,clasilyScr,dataUrl];
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [ProgressHUD show:@"正在为您请求数据"];
        
        if (self.listArray != nil) {
            [self.listArray removeAllObjects];
        }
        
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

-(void)updateCity{
    
}
-(void)backFrrameCity{
    
    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/hunter/products/v2/metadata/?city_name=%@",self.stringName];
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        self.backCityArray = [NSMutableArray new];
        self.backIdArray = [NSMutableArray new];
        for (NSDictionary *dict in dic[@"tag_data"]) {
            [self.backCityArray addObject:dict[@"name"]];
            [self.backIdArray addObject:dict[@"id"]];
        }

        [self clasifyWays];
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

-(void)clasifyWays{
    
//    [self clasifyWays];
    //collection的自定义方法
    self.tageListView = [[JCTagListView alloc] initWithFrame:CGRectMake(kWidth/10, kHeight*0.1, kWidth*0.8, kHeight*0.5)];
    self.tageListView.backgroundColor = [UIColor whiteColor];
    
    self.tageListView.layer.cornerRadius = 15.0f;
    self.tageListView.clipsToBounds = YES;
    self.tageListView.tagStrokeColor = [UIColor grayColor];
    self.tageListView.tagTextColor = [UIColor grayColor];
    
    [self.tageListView.tags addObjectsFromArray:self.backCityArray];
    
    
    __block CityViewController *weakSelf = self;
    [self.tageListView setCompletionBlockWithSelected:^(NSInteger index) {
      
        weakSelf.idStr = weakSelf.backIdArray[index];
        [weakSelf.firstView removeFromSuperview];
        [weakSelf.backView removeFromSuperview];
        
       
        [weakSelf uptataConfig];
        
        
        
    }];

    
}
//主题点击方法
-(void)mainTitle{
    
    [self.window addSubview:self.backView];
    
    self.firstView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _firstView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.firstView];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kWidth-60, 44)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"主题";
    [self.firstView addSubview:lable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(kWidth-30, 10, 30, 30);
    [button addTarget:self action:@selector(RemoveViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.firstView addSubview:button];
    
    
    UIButton *enSure = [UIButton buttonWithType:UIButtonTypeCustom];
    enSure.frame = CGRectMake(20, kHeight-220, kWidth - 40, 44);
    [enSure setTitle:@"确定" forState:UIControlStateNormal];
    [enSure addTarget:self action:@selector(Ensure) forControlEvents:UIControlEventTouchUpInside];
    enSure.layer.cornerRadius = 15.0;
    enSure.clipsToBounds = YES;
    enSure.backgroundColor = kMainColor;
    [self.firstView addSubview:enSure];
    
    
    

    [self.firstView addSubview:self.tageListView];
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha  = 0.6;
        self.firstView.frame = CGRectMake(0, kScreenHeight - 500, kScreenWidth, 500);
    }];
    
    
    
}

- (NSString *)showStr {
    
    NSMutableString *str = [NSMutableString string];
    
    [str appendString:@""];
    //从小到大排序
    [self.seletedDays sortUsingComparator:^NSComparisonResult(NSNumber *obj1, NSNumber *obj2) {
        return [obj1 compare:obj2];
    }];
    
    for (NSNumber *interval in self.seletedDays) {
        NSString *partStr = [NSDate stringWithTimestamp:interval.doubleValue/1000.0 format:@"yy-MM-dd"];
        [str appendFormat:@"%@ ",partStr];
    }
    return [str copy];
    
}

-(void)calanderAction{
    

        _calendarView = [[LDCalendarView alloc] initWithFrame:CGRectMake(0, -100, SCREEN_WIDTH,SCREEN_HEIGHT)];
        [self.secondView addSubview:_calendarView];
        
        __weak typeof(self) weakSelf = self;
        _calendarView.complete = ^(NSArray *result) {
            if (result) {
                weakSelf.seletedDays = [result mutableCopy];
                //                NSLog(@"%@",weakSelf.showStr);
                weakSelf.dataStr = weakSelf.showStr;
                
            }
        };

    [self.calendarView show];
    self.calendarView.defaultDates = _seletedDays;
    
}

//日期筛选点击方法
-(void)dataChose{
    [self.window addSubview:self.backView];
    self.secondView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    self.secondView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.secondView];

    [self calanderAction];
    
    
    UIButton *enSure = [UIButton buttonWithType:UIButtonTypeCustom];
    enSure.frame = CGRectMake(20, kHeight-320, kWidth - 40, 44);
    [enSure setTitle:@"确定" forState:UIControlStateNormal];
    [enSure addTarget:self action:@selector(EnsureSecond) forControlEvents:UIControlEventTouchUpInside];
    enSure.layer.cornerRadius = 15.0;
    enSure.clipsToBounds = YES;
    enSure.backgroundColor = kMainColor;
    [self.secondView addSubview:enSure];
    
    
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha  = 0.6;
        self.secondView.frame = CGRectMake(0, kHeight-500, kScreenWidth, 500);
    }];
}



//排序点击方法
-(void)orderTitle{
    
    
    [self.window addSubview:self.backView];
    
    self.thirdView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreenHeight, kScreenWidth, kScreenHeight)];
    _thirdView.backgroundColor = [UIColor whiteColor];
    [self.window addSubview:self.thirdView];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kWidth-60, 44)];
    lable.textAlignment = NSTextAlignmentCenter;
    lable.text = @"主题";
    [self.thirdView addSubview:lable];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    button.frame = CGRectMake(kWidth-30, 10, 30, 30);
    [button addTarget:self action:@selector(RemoveThirdViewAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.thirdView addSubview:button];
    [self.thirdView addSubview:self.titleTableView];
 
    [UIView animateWithDuration:0.5 animations:^{
        self.backView.alpha  = 0.6;
        self.thirdView.frame = CGRectMake(0, kScreenHeight - 500, kScreenWidth, 500);
    }];
  
}

-(void)RemoveViewAction{
    [UIView animateWithDuration:1.0 animations:^{
        [self.firstView removeFromSuperview];
        [self.backView removeFromSuperview];
        
    }];
    
}
-(void)Ensure{
    [UIView animateWithDuration:1.0 animations:^{

    [self.firstView removeFromSuperview];
    [self.backView removeFromSuperview];
    }];
}

-(void)EnsureSecond{
    
    [self calanderAction];
    [UIView animateWithDuration:1.0 animations:^{
        [self.calendarView removeFromSuperview];
        [self.secondView removeFromSuperview];
        [self.backView removeFromSuperview];
        
    }];
    if (self.listArray != nil) {
        [self.listArray removeAllObjects];
    }
    [self uptataConfig];
  
}

-(void)RemoveThirdViewAction{
    [UIView animateWithDuration:1.0 animations:^{
        [self.thirdView removeFromSuperview];
        [self.backView removeFromSuperview];
        
    }];

}



#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _tableView) {
        
        cityFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.model = self.listArray[indexPath.row];
        
//        cityModel *Cmodel = self.listArray[indexPath.row];
        
        [cell.ClassifyButton addTarget:self action:@selector(classAction:event:) forControlEvents:UIControlEventTouchUpInside];
//        cell.ClassifyButton.tag = (long)Cmodel.user[@"id"];
        
        return cell;
    }else{
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            switch (indexPath.row) {
                case 0:
                    cell.textLabel.text = @"智能排序";
                    break;
                case 1:
                    cell.textLabel.text = @"距离最近";
                    break;
                case 2:
                    cell.textLabel.text = @"价格最低";
                    break;
                case 3:
                    cell.textLabel.text = @"人气最高";
                    break;
                case 4:
                    cell.textLabel.text = @"销量最好";
                    break;
                
                    
                default:
                    break;
            }
            
        }
        
       return cell;
    }
    
 
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    cityModel *model = self.listArray[indexPath.row];
    
    if (tableView == self.tableView) {
        DetailViewController *detail = [[DetailViewController alloc] init];
        detail.IDString = model.product_id;
        self.hidesBottomBarWhenPushed = YES;

        
        [self.navigationController pushViewController:detail animated:NO];
    }else{
        switch (indexPath.row) {
            case 0:
                
                self.idStr = @"1";
                break;
            case 1:
                
                self.idStr = @"2";
                break;
            case 2:
                
                self.idStr = @"5";
                break;
            case 3:
                
                self.idStr = @"3";
                break;
            case 4:
               
                self.idStr = @"4";
                break;
                
                
            default:
                break;
        }

        
        
        [self.thirdView removeFromSuperview];
        [self.backView removeFromSuperview];
        
        if (self.listArray != nil) {
            [self.listArray removeAllObjects];
        }
        
     
        
        [self uptataConfig];
        
    }
 
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return self.listArray.count;
    }else{
        return 5;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableView) {
        return kHeight*0.42;
    }else{
        return 40;
    }
    
}

#pragma mark---------------导航栏点击方法；

-(void)classAction:(UIButton *)button event:(UIEvent *)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    cityModel *Cmodel = self.listArray[indexPath.row];

    
    
    PersonViewController *person = [[PersonViewController alloc] init];
    
    person.personId = Cmodel.user[@"id"];
    [self.navigationController pushViewController:person animated:NO];

}

-(void)selectCity{
    

     InlandViewController *firstVC = [[InlandViewController alloc] init];
    //隐藏功能
    firstVC.navigationItem.hidesBackButton = YES;
    firstVC.navigationController.navigationBar.hidden = YES;
    
     ForeignViewController *secondVC = [[ForeignViewController alloc] init];
    //隐藏功能
    secondVC.navigationItem.hidesBackButton = YES;
    secondVC.navigationController.navigationBar.hidden = YES;
    
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
    hotCity.IDName = self.stringName;
    
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
        self.tableView.backgroundColor = kMainColor;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

-(UITableView *)titleTableView{
    if (_titleTableView == nil) {
        self.titleTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, kWidth, kHeight) style:UITableViewStylePlain];
        self.titleTableView.delegate = self;
        self.titleTableView.dataSource = self;
        [self.thirdView addSubview:self.titleTableView];
        
    }
    return _titleTableView;
}
-(UIView *)backView{
    
    if (_backView == nil) {
        self.backView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:1];

    }
    return _backView;
    
}


-(UIWindow *)window{
    if (_window == nil) {
        self.window = [[UIApplication sharedApplication].delegate window];
    }
    return _window;
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









/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
