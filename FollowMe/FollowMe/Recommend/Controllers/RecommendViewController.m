//
//  RecommendViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//
#define kRecommend @"http://api.breadtrip.com/v2/index/?"
#import "RecommendViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
//广告轮播第三方
#import "JXBAdPageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CollectionViewCell.h"
#import "RecommendTableViewCell.h"
#import "RecommendModel.h"
//tableView第三方
#import "PullingRefreshTableView.h"
//菊花第三方
#import "ProgressHUD.h"
//全局静态变量
static NSString *collectionHeader = @"cityHeader";
static NSString *itemID = @"itemId";
//广告轮播代理（JXBAdPageViewDelegate）
@interface RecommendViewController ()<JXBAdPageViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UISearchBarDelegate,UITextFieldDelegate>{
    //广告轮播数据数组
    NSMutableArray *_AdvertisementArray;
    //上拉加载的时候
    NSString *_next_start;

}
//广告轮播图
@property (nonatomic, strong) JXBAdPageView    *AdvertisementImageView;
//collerctionView属性
@property (nonatomic, strong) UICollectionView *collectionView;
//collerctionView请求出的数组
@property (nonatomic, strong) NSMutableArray *collerctionViewArray;
@property (nonatomic, strong) NSMutableArray *introduceImageArray;
@property (nonatomic, strong) NSMutableArray *introduceLableArray;
@property (nonatomic, strong) NSMutableArray *nameImageArray;
@property (nonatomic, strong) NSMutableArray *nameLableArray;
//tableView数据数组
@property (nonatomic, strong) NSMutableArray *tableViewArray;
//tableView的头部试图
@property (nonatomic, strong) UIView *headerView;
//tableView
@property (nonatomic, strong) PullingRefreshTableView *tableView;
//collectionViewSection头部标题
@property (nonatomic, strong) NSDictionary *collectionViewSectionArray;
//tableViewSection头部标题
@property (nonatomic, strong) NSDictionary *tableViewSectionArray;
@property(nonatomic, assign) BOOL refreshing;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.backgroundColor = kMainColor;
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 44)];
    
    UIButton *nearbyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    nearbyBtn.frame = CGRectMake(kWidth-90, 0, 90, 44);
    [nearbyBtn setTitle:@"附近" forState:UIControlStateNormal];
    [nearbyBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [titleView addSubview:nearbyBtn];
    
    UITextField *searchField = [[UITextField alloc] initWithFrame:CGRectMake(5, 7, kWidth-95, 30)];
    
    //设置输入框的背景颜色
    searchField.backgroundColor = [UIColor redColor];
    searchField.placeholder = @"搜索目的地、游记、故事集、用户";
    //设置字体颜色
    searchField.textColor = [UIColor whiteColor];
    //输入框中是否有个叉号，在什么时候显示，用于一次性删除输入框中的内容
    searchField.clearButtonMode = UITextFieldViewModeAlways;
    //设置代理
    searchField.delegate = self;
    [titleView addSubview:searchField];
    
    self.navigationItem.titleView = titleView;
    
    
  
    // Do any additional setup after loading the view.
    _AdvertisementArray = [NSMutableArray new];
    //collectionview添加进系统视图
    [self.headerView addSubview:self.collectionView];
    //请求数据
    [self workOne];
    self.tableView.tableHeaderView = self.headerView;
//注册tableView
    [self.tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:@"tableViewCell"];
    _next_start = nil;
    [self.tableView launchRefreshing];
    [self.view addSubview:self.tableView];
  
    
    


}
//在页面将要消失的时候，调用此方法，去掉所有的
- (void)viewDidDisappear:(BOOL)animated{
    [ProgressHUD dismiss];
}
#pragma mark -------------------------------- PullingRefreshTableView

//下拉刷新
-(void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    [ProgressHUD show:@"正在为您刷新"];
    _next_start = nil;
    self.refreshing = YES;
    [self performSelector:@selector(workOne) withObject:nil afterDelay:1.0];
    
}

//上拉加载
-(void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    [ProgressHUD show:@"正在为您加载"];
       self.refreshing = NO;
    [self performSelector:@selector(workOne) withObject:nil afterDelay:1.0];
}


//手指开始拖动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    [self.tableView tableViewDidScroll:scrollView];
    
}

//手指结束拖动
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    [self.tableView tableViewDidEndDragging:scrollView];
}

//请求广告轮播
- (void)AdvertisementArray{
    //使用SDWebImage
    _AdvertisementImageView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200)];
    _AdvertisementImageView.contentMode = UIViewContentModeScaleAspectFill;
    _AdvertisementImageView.iDisplayTime = 2;
    _AdvertisementImageView.bWebImage = YES;
    _AdvertisementImageView.delegate = self;
    NSArray *arr = _AdvertisementArray;
    [_AdvertisementImageView startAdsWithBlock:arr block:^(NSInteger clickIndex){
        NSLog(@"%d",(int)clickIndex);
    }];
    //collectionview 头部
    UILabel *collectionViewSectionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 210, kWidth-100, 40)];
   collectionViewSectionLable.text = self.collectionViewSectionArray[@"title"];
    UIButton *collectionViewSectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth - 80, 210, 60, 40)];
    [collectionViewSectionBtn setTitle:@"全部" forState:UIControlStateNormal];
    [collectionViewSectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //tableView头部
    UILabel *tableViewSectionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, 740, kWidth, 40)];
    tableViewSectionLable.text = self.tableViewSectionArray[@"title"];
  
    [self.headerView addSubview:tableViewSectionLable];
    [self.headerView addSubview:collectionViewSectionBtn];
    [self.headerView addSubview:collectionViewSectionLable];
    // 添加进系统视图
    [self.headerView addSubview:_AdvertisementImageView];
    
}
//第三方广告轮播代理
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl {
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}
#pragma mark -------------请求网络数据--------------
- (void)workOne{
    NSString *httpStr;
    if (_next_start == nil) {
        httpStr = kRecommend;
    }else{
        httpStr = [NSString stringWithFormat:@"%@next_start=%@",kRecommend,_next_start];}
    
    [ProgressHUD show:@"请稍后"];
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:httpStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
        NSDictionary *dic = responseObject;
        //请求主要数据data
        NSDictionary *dic1 = dic[@"data"];
        //请求首页数据
        NSArray *elements = dic1[@"elements"];
        _next_start = dic1[@"next_start"];
       
        if (_refreshing) {
            if (self.collerctionViewArray.count > 0) {
                [self.collerctionViewArray removeAllObjects];
                [_AdvertisementArray removeAllObjects];
                [self.introduceImageArray removeAllObjects];
                [self.introduceLableArray removeAllObjects];
               
                [self.nameImageArray removeAllObjects];
                [self.nameLableArray removeAllObjects];
             
                [self.tableViewArray removeAllObjects];
                
               
                
            }
        }
        for (NSDictionary *dic2 in elements) {
            //请求广告数据
            if ([dic2[@"desc"] isEqualToString:@"广告banner"]) {
                NSArray *data = dic2[@"data"];
                NSArray *item = data[0];
                for (NSDictionary *dic3 in item) {
                    [_AdvertisementArray addObject:dic3[@"image_url"]];
                }
            }
            //请求出来的数据是NSString类型  但转换为数据却是NSNumber类型
           else if (dic2[@"type"] == [NSNumber numberWithInteger:10]) {
                NSArray *data = dic2[@"data"];
                for (NSDictionary *dic3 in data) {
                    //判断这个key值里面有数据没  没有的话就用下一个key值里的数据
                    if ([dic3[@"index_title"] isEqualToString:@""] ) {
                        [self.introduceLableArray addObject:dic3[@"text"]];
                    }else{
                        [self.introduceLableArray addObject:dic3[@"index_title"]];
                    }
                    //判断这个key值里面有数据没  没有的话就用下一个key值里的数据
                    if ([dic3[@"index_cover"] isEqualToString:@""]) {
                        [self.introduceImageArray addObject:dic3[@"cover_image_w640"]];
                    }else{
                        [self.introduceImageArray addObject:dic3[@"index_cover"]];
                    }
                    NSDictionary *user = dic3[@"user"];
                    [self.nameLableArray addObject:user[@"name"]];
                    [self.nameImageArray addObject:user[@"avatar_s"]];
                }
                [self.collerctionViewArray addObject:self.introduceImageArray];
                [self.collerctionViewArray addObject:self.introduceLableArray];
                [self.collerctionViewArray addObject:self.nameImageArray];
                [self.collerctionViewArray addObject:self.nameLableArray];
                
            }
          else if (dic2[@"type"] == [NSNumber numberWithInteger:4]||[dic2[@"desc"] isEqualToString:@"热门游记"]) {
              NSArray *data = dic2[@"data"];
              for (NSDictionary *dic4 in data) {
                  RecommendModel *model = [[RecommendModel alloc] initWithDictionary:dic4];
                  [self.tableViewArray addObject:model];
              }
            }
          else if (dic2[@"type"] == [NSNumber numberWithInteger:11]){
              NSArray *data = dic2[@"data"];
              self.collectionViewSectionArray = data[0];
            
          }
          else if (dic2[@"type"] == [NSNumber numberWithInteger:9]){
              NSArray *data = dic2[@"data"];
              self.tableViewSectionArray = data[0];

          }
        }
        [self.tableView tableViewDidFinishedLoading];
        self.tableView.reachedTheEnd = NO;
        [self AdvertisementArray];

        //刷新tableView
        [self.tableView reloadData];
       //刷新collectionview
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        //        NSLog(@"%@",error);
    }];
    
}
#pragma mark ----------------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tableViewCell" forIndexPath:indexPath];
    cell.model = self.tableViewArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

#pragma mark ----------------UICollectionViewDataSource
//返回分区有多少条目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.nameLableArray.count;
    
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}
//collerctionView cell显示内容
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.introduceImageView sd_setImageWithURL:[NSURL URLWithString:self.introduceImageArray[indexPath.row]] placeholderImage:nil];
    cell.introduceLable.text = self.introduceLableArray[indexPath.row];
    cell.introduceLable.numberOfLines = 0;
    cell.introduceLable.font = [UIFont systemFontOfSize:13];
    [cell.nameImageView sd_setImageWithURL:[NSURL URLWithString:self.nameImageArray[indexPath.row]] placeholderImage:nil];
    cell.nameLable.text = self.nameLableArray[indexPath.row];
    cell.nameLable.numberOfLines = 0;
    cell.nameLable.font = [UIFont systemFontOfSize:11];
    
    
    return cell;
}

#pragma mark -------------------------------- UICollectionViewDelegete
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * cell = (UICollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor whiteColor];
}
//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    scrollPosition = UICollectionViewScrollPositionTop;
}
#pragma mark     -------------懒加载----------------
////collectionViewSection头部标题
//- (NSMutableArray *)collectionViewSectionArray{
//    if (_collectionViewSectionArray == nil) {
//        self.collectionViewSectionArray = [NSMutableArray new];
//    }
//    return _collectionViewSectionArray;
//}
////tableViewSection头部标题
//- (NSMutableArray *)tableViewSectionArray{
//    if (_tableViewSectionArray == nil) {
//        self.tableViewSectionArray = [NSMutableArray new];
//    }
//    return _tableViewSectionArray;
//}
//tableViewArray的懒加载
- (NSMutableArray *)tableViewArray{
    if (_tableViewArray == nil) {
        self.tableViewArray = [NSMutableArray new];
    }
    return _tableViewArray;
}
//tableView的懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight+44) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 250;
    }
    return _tableView;
}
//tableView头部试图的懒加载
- (UIView *)headerView{
    if (_headerView == nil) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,780 )];
    }
    return _headerView;
}
//collerctionView懒加载
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //创建一个布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向为垂直方向(默认为垂直方向)
        layout.scrollDirection = UICollectionViewScrollPositionCenteredVertically;
        
        //设置item的间距
        layout.minimumInteritemSpacing = 1;
        //设置每一列的间距
        layout.minimumLineSpacing = 10;
        //设置section的间距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //        [layout setHeaderReferenceSize:CGSizeMake(kWidth, 100)];
        //设置每个Item的大小
        layout.itemSize = CGSizeMake(180, 240);
        //通过一个layout来创建一个UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,250, kWidth, kHeight) collectionViewLayout:layout];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        
    }
    return _collectionView;
}


//collerctionViewArray数组懒加载
- (NSMutableArray *)collerctionViewArray{
    if (_collerctionViewArray == nil) {
        self.collerctionViewArray = [NSMutableArray new];
    }
    return _collerctionViewArray;
}
//
- (NSMutableArray *)introduceImageArray{
    if (_introduceImageArray == nil) {
        self.introduceImageArray = [NSMutableArray new];
    }
    return _introduceImageArray;
}
- (NSMutableArray *)introduceLableArray{
    if (_introduceLableArray == nil) {
        self.introduceLableArray = [NSMutableArray new];
    }
    return _introduceLableArray;
}
- (NSMutableArray *)nameImageArray{
    if (_nameImageArray == nil) {
        self.nameImageArray = [NSMutableArray new];
    }
    return _nameImageArray;
}
- (NSMutableArray *)nameLableArray{
    if (_nameLableArray == nil) {
        self.nameLableArray = [NSMutableArray new];
    }
    return _nameLableArray;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];    //主要是[receiver resignFirstResponder]在哪调用就能把receiver对应的键盘往下收
    return YES;
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
