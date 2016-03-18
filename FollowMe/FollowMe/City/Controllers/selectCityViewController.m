//
//  selectCityViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "selectCityViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "JCTagListView.h"
#import "ChoseCityModel.h"


@interface selectCityViewController ()<UIScrollViewDelegate,UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

//创建两个视图，国内，国外；
@property(nonatomic, strong) UIView *inlandView;
@property(nonatomic, strong) UIView *foreignView;
//tableview头部视图；
@property(nonatomic, strong) UIView *headView;
@property(nonatomic, strong) UIWindow *window;

//实现滑动的Scrollview
@property(nonatomic, strong) UIScrollView *nationSCView;
//选择国内国外的segment
@property(nonatomic, strong) UISegmentedControl *choseSegment;
//搜索栏
@property(nonatomic, strong) UISearchBar *mySearchBar;
//CPS定位按钮（显示效果）
@property(nonatomic, strong) UILabel *gpsLable;
//装载全部城市
@property(nonatomic, strong) NSMutableArray *allCityArray;
//@property(nonatomic, strong) NSString 
//tableview
@property(nonatomic, strong) UITableView *tableViewLeft;
@property(nonatomic, strong) UITableView *tableViewRight;
//
@property(nonatomic, strong) UILabel *inLable;
@property(nonatomic, strong) UILabel *forLable;


//collectionview自适应宽度；
@property(nonatomic, strong) JCTagListView *jctageLiseView;


@end

@implementation selectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    
    
    //设置UIScrollView的各种属性；
    
    //设置scrollview的大小
    self.nationSCView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, kHeight*0.25, kWidth*2, kHeight*0.75)];
    //是否可以滑动
//    self.nationSCView.scrollEnabled = YES;
    //头部是否不停止
//    self.nationSCView.scrollsToTop = NO;
   
    //水平边界是否定死
    self.nationSCView.showsHorizontalScrollIndicator = NO;
    //垂直边界是否定死
    self.nationSCView.showsVerticalScrollIndicator = NO;
    //内容的大小如果小于scrollView的时候仍然可以左右滑动边界；
    self.nationSCView.alwaysBounceHorizontal = NO;
//    self.nationSCView.alwaysBounceVertical = NO;
    //是否显示水平方向滚动条；
//    self.nationSCView.showsHorizontalScrollIndicator = NO;
    //设置大小
    self.nationSCView.contentSize = CGSizeMake(kWidth * 3, kHeight-kHeight/3);
    //代理
    self.nationSCView.delegate = self;
    //是否允许自适应大小的缩放；
//    self.nationSCView.bouncesZoom = NO;
//    //滑动到边界是否可以继续滑动；
//    self.nationSCView.bounces = YES;
    //整页滑动；
    self.nationSCView.pagingEnabled = YES;
    
    self.nationSCView.backgroundColor = [UIColor orangeColor];
    
   

    [self.nationSCView addSubview:self.tableViewLeft];
    [self.nationSCView addSubview:self.tableViewRight];
    [self.view addSubview:self.nationSCView];
    self.tableViewLeft.tableHeaderView = self.headView;
    
//    [self.nationSCView addSubview:self.tableViewLeft];
    
    //传值，热门城市；
    
    self.jctageLiseView.canSelectTags = YES;
    self.jctageLiseView.tagCornerRadius = 5.0f;
    [self.jctageLiseView.tags addObjectsFromArray:@[@"北京",@"上海",@"广州",@"深圳",@"天津" ]];
    
    [self.jctageLiseView setCompletionBlockWithSelected:^(NSInteger index) {
        NSLog(@"______%ld______", (long)index);
    }];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"国内",@"国外", nil];

    self.choseSegment = [[UISegmentedControl alloc] initWithItems:array];

     self.choseSegment.frame =CGRectMake(kWidth/4, 30, kWidth/2, 35);
    self.choseSegment.momentary = NO;
    self.choseSegment.tintColor = [UIColor whiteColor];
    self.choseSegment.layer.cornerRadius = 20;
    self.choseSegment.clipsToBounds = YES;
//
////    [self.view addSubview:self.choseSegment];
//    [self.choseSegment addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.choseSegment];
    
    //搜索框：
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 100, kWidth, 40)];
    self.mySearchBar.delegate = self;
//    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.backgroundColor = kMainColor;
    self.mySearchBar.placeholder = @"搜索城市名或者拼音";
//    self.mySearchBar.layer.cornerRadius = 10;
    self.mySearchBar.clipsToBounds = YES;
    
    [self.view addSubview:self.mySearchBar];
    
    
    
//    [self.foreignView addSubview:self.tablevView];
    
    //加载数据；
    [self updateSelectCity];

}

-(void)choseAction:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self inlandAction];
            break;
        case 1:
            [self foreignAction];
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)inlandAction{
    
    
    
    
    
    
}
-(void)foreignAction{
    
    
    
    
    
}
#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewLeft) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        cell.textLabel.text = self.allCityArray[indexPath.row];
        cell.backgroundColor = kMainColor;

        return cell;
    }
    else{
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
            
        }
        
        cell.backgroundColor = kMainColor;
        
        cell.textLabel.text = @"未来";
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableViewLeft) {
        return self.allCityArray.count;
    }else{
        return 40;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.tableViewLeft) {
        return 30;
    }else{
        return 30;
    }
    return 30;
}
- (void)one{
    NSLog(@"hkhkghajsgjudfquqjqfvjqf%@",self.allCityArray);
}
#pragma mark ------------------加载数据；
-(void)updateSelectCity{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.breadtrip.com/hunter/products/v2/metadata/?with_citydata&with_sortdata&city_name=%E5%8C%97%E4%BA%AC" parameters:self progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *rootDic = responseObject;
        //去出所有的城市；
        NSDictionary *citDac = rootDic[@"city_data"];
        NSDictionary *inlandDic = citDac[@"domestic_city"];
        self.allCityArray = [NSMutableArray new];
        for (NSDictionary *inName in inlandDic[@"all_city_list"]) {

            [self.allCityArray addObject:inName[@"name"]];
            
            //WLZLog(@"self.allCityArray = %@",self.allCityArray)

        }
        [self.tableViewLeft reloadData];
        
        //WLZLog(@"%@",self.allCityArray)

        
        

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark----------------------懒加载；
-(UIView *)inlandView{
    
    if (_inlandView == nil) {
        
        self.inlandView = [[UIView alloc] initWithFrame:CGRectMake(0, -kHeight*0.25,kWidth, kHeight)];
        
        self.inlandView.backgroundColor = [UIColor cyanColor];
   
    }
    return _inlandView;
}


-(UIView *)foreignView{
    if (_foreignView == nil) {
        self.foreignView = [[UIView alloc] initWithFrame:CGRectMake(kWidth, -kHeight*0.25,kWidth, kHeight)];
        self.foreignView.backgroundColor = [UIColor blueColor];
    }
    return _foreignView;
    
}

-(UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeight*0.25, kWidth, kHeight/3)];
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
        
        
        UILabel *inlable = [[UILabel alloc] initWithFrame:CGRectMake(0, 60, kWidth/2, 30)];
        inlable.backgroundColor = [UIColor clearColor];
        inlable.text = @"国内热门城市";
        inlable.textColor = [UIColor whiteColor];
        inlable.font = [UIFont systemFontOfSize:13.0];
        [_headView addSubview:inlable];
        
      
        
    }
    return _headView;
}
//
//-(UIWindow *)window{
//    if (_window == nil) {
//        self.window = [[UIApplication sharedApplication].delegate window];
//        
//    }
//    return _window;
//}


-(UITableView *)tableViewLeft{
    if (_tableViewLeft == nil) {
        self.tableViewLeft = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight*3) style:UITableViewStylePlain];
        self.tableViewLeft.backgroundColor =kMainColor;
        self.tableViewLeft.delegate = self;
        self.tableViewLeft.dataSource = self;
        self.tableViewLeft.backgroundColor = kMainColor;
        
    }
    return _tableViewLeft;
}

-(UITableView *)tableViewRight{
    if (_tableViewRight == nil) {
        self.tableViewRight = [[UITableView alloc] initWithFrame:CGRectMake(kWidth, 0, kWidth, kHeight*3) style:UITableViewStylePlain];
//        self.tableViewRight.backgroundColor = [UIColor cyanColor];
        self.tableViewRight.delegate = self;
        self.tableViewRight.dataSource = self;
        
        self.tableViewRight.backgroundColor = kMainColor;
        
    }
    return _tableViewRight;
    
    
}

-(JCTagListView *)jctageLiseView{
    if (_jctageLiseView == nil) {
        self.jctageLiseView = [[JCTagListView alloc] initWithFrame:CGRectMake(0, 80, kWidth, kHeight*0.2)];
        [self.headView addSubview:self.jctageLiseView];
        
    }
    return _jctageLiseView;
}


//在视图即将出现的时候，隐藏导航视图控制器；

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear:animated];
//    self.navigationController.navigationBar.hidden = YES;
//    
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
