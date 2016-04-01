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
#import "originalViewController.h"
//广告轮播第三方
#import "JXBAdPageView.h"
#import "specialViewController.h"
#import "CollectionViewCell.h"
#import "RecommendTableViewCell.h"
#import "RecommendModel.h"
//tableView第三方
#import "PullingRefreshTableView.h"
//菊花第三方
#import "ProgressHUD.h"
#import "JCTagListView.h"
#import "searchViewController.h"
#import "nearByViewController.h"
#import "allCollectionViewController.h"
#import "advertisingViewController.h"
#import "storyDetailsViewController.h"
#import "searchForWorldViewController.h"
#import <UIKit/UIKit.h>
//全局静态变量
//http://api.breadtrip.com/trips/2387343240/waypoints/
//http://api.breadtrip.com/v2/new_trip/?trip_id=2387101809
static NSString *cellIdentifier = @"tableViewCell";
//广告轮播代理（JXBAdPageViewDelegate）
@interface RecommendViewController ()<JXBAdPageViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITableViewDataSource,UITableViewDelegate,PullingRefreshTableViewDelegate,UISearchBarDelegate>{
    //上拉加载的时候
    NSString *_next_start;
    //控制导航栏
    NSInteger _ppp;
    
}
@property (nonatomic, strong)NSMutableArray *elementsArr;
@property (nonatomic, strong) NSMutableArray *advertisementArray;
//广告轮播图
@property (nonatomic, strong) JXBAdPageView    *AdvertisementImageView;
//collerctionView属性
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *spot_idArray;
//collerctionView请求出的数组
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
//搜索栏
@property(nonatomic, strong) UISearchBar *mySearchBar;
//搜索栏View
@property (nonatomic, strong) UIScrollView *searchView;
//国外
@property(nonatomic, strong) JCTagListView *foreignView;
//国内
@property(nonatomic, strong) JCTagListView *inLandView;
@property (nonatomic, strong) NSMutableArray *foreignListArray;
@property (nonatomic, strong) UIButton *nearBtn;
//搜索历史
@property (nonatomic, strong) JCTagListView *histroyView;
//国外搜索id
@property (nonatomic, strong) NSMutableArray *foreignsearchId;
//国内搜索id
@property (nonatomic, strong) NSMutableArray *inlandId;
//搜索框取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//广告轮播图的点击方法
@property (nonatomic, strong) NSMutableArray *htmlArray;
@property (nonatomic, strong) NSMutableArray *inlandListArray;
@property (nonatomic, strong) NSMutableArray *typeForeignArray;
@property (nonatomic, strong) NSMutableArray *typeInLandArray;
@property (nonatomic, strong) NSMutableArray *id12Array;
@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    _ppp = 0;
    _next_start = nil;


    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;
    [self.tableView launchRefreshing];
    [self near];
    [self search];
    [self tapgr];
    

}
//附近
- (void)near{
    self.nearBtn.frame = CGRectMake(kWidth-90, 0, 90, 44);
    [self.nearBtn setTitle:@"附近" forState:UIControlStateNormal];
    [self.nearBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.nearBtn addTarget:self action:@selector(nearBy) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.nearBtn];
}
- (void)nearBy{
    _ppp = 0;
    nearByViewController *nearVC = [[nearByViewController alloc] init];
    nearVC.hellow = @"附近";
    [self.navigationController pushViewController:nearVC animated:YES];
    
    
}
//搜索框
- (void)search{
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(10, 7, kWidth-80, 30)];
    self.mySearchBar.delegate = self;
    self.mySearchBar.placeholder = @"搜索目的地、游记、故事集、用户";
    self.mySearchBar.layer.masksToBounds = YES;
    self.mySearchBar.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
}
- (void)addWhiteView{
    
    
    UILabel *lable1 = [[UILabel alloc] initWithFrame:CGRectMake(100, 90, kWidth-200, 20)];
    lable1.text = @"国外热门目的地";
    UILabel *lable2 = [[UILabel alloc] initWithFrame:CGRectMake(100, 320 , kWidth-200, 20)];
    lable2.text = @"国内热门目的地";
    
    
    UILabel *lable3 = [[UILabel alloc] initWithFrame:CGRectMake(0, 475, kWidth, 20)];
    lable3.text = @"搜索历史";
    lable3.textAlignment = NSTextAlignmentCenter;
    
    lable1.textAlignment = NSTextAlignmentCenter;
    lable2.textAlignment = NSTextAlignmentCenter;
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelBtn setTitle:@"删除搜索历史" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelBtn.frame = CGRectMake(kWidth/2+20, 475, kWidth/2-20, 20);
    [cancelBtn addTarget:self action:@selector(cancelHistory) forControlEvents:UIControlEventTouchUpInside];
    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    cancelBtn.titleLabel.highlighted = YES;
    cancelBtn.titleLabel.enabled = NO;
    
    
    
    [self.searchView addSubview:cancelBtn];
    [self.searchView addSubview:lable3];
    [self.searchView addSubview:lable1];
    [self.searchView addSubview:lable2];
    self.foreignView.canSelectTags = YES;
    self.inLandView.canSelectTags = YES;
    self.foreignView.tagCornerRadius = 10.0f;
    self.inLandView.tagCornerRadius = 10.0f;
    //字体颜色
    //    self.foreignView.tagTextColor = [UIColor greenColor];
    //点击之后txt的背景颜色
//    self.foreignView.tagSelectedBackgroundColor = [UIColor whiteColor];
    //边框颜色
    //    self.inLandView.tagStrokeColor = [UIColor redColor];
    NSArray *ayyay1 = [NSArray arrayWithArray:self.foreignListArray];
    
    [self.foreignView.tags addObjectsFromArray:ayyay1];
    NSArray *array2 = [NSArray arrayWithArray:self.inlandListArray];
    [self.inLandView.tags addObjectsFromArray:array2];
    __block RecommendViewController *weakself = self;
    [self.foreignView setCompletionBlockWithSelected:^(NSInteger index) {
        //        WLZLog(@"国外%ld",(long)index);
        
        
        weakself.mySearchBar.text = weakself.foreignListArray[index];
        searchViewController *seaVC = [[searchViewController alloc] init];
        seaVC.type = weakself.typeForeignArray[index];
        seaVC.userId = weakself.foreignsearchId[index];
        [weakself.navigationController pushViewController:seaVC animated:YES];
        
    }];
    
    
    [self.inLandView setCompletionBlockWithSelected:^(NSInteger index) {
        WLZLog(@"国内%ld",(long)index);
        weakself.mySearchBar.text = weakself.inlandListArray[index];
        searchViewController *seaVC = [[searchViewController alloc] init];
        seaVC.type = weakself.typeInLandArray[index];
        seaVC.userId = weakself.inlandId[index];
        [weakself.navigationController pushViewController:seaVC animated:YES];
        
    }];
    
    
    
}
- (void)cancelHistory{
    [self.histroyView.tags removeAllObjects];
    [self.histroyView.collectionView reloadData];
    
}
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    //搜索栏输入导入时候
    _ppp = 1;
    self.nearBtn.hidden = YES;
    self.cancelBtn.hidden = NO;
    self.cancelBtn.frame = CGRectMake(kWidth-90, 0, 90, 44);
    
    [self.cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [self.cancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.navigationController.navigationBar addSubview:self.cancelBtn];
    
    
    [self addWhiteView];
    [self.mySearchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:1 animations:^{
        self.searchView.frame = self.view.frame;
    }];
    return YES;
}
- (void)cancelView{
    //取消按钮的点击方法
    _ppp = 0;
    self.nearBtn.hidden = NO;
    self.cancelBtn.hidden = YES;
    
    [self.mySearchBar resignFirstResponder];
    [self.mySearchBar setShowsCancelButton:NO animated:YES];
    [UIView animateWithDuration:0.6 animations:^{
        self.searchView.frame = CGRectMake(0, -kHeight, kWidth, kHeight);
    }];
    self.mySearchBar.text = nil;
    
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //搜索按钮的点击方法
    _ppp = 1;
    self.histroyView.canSelectTags = YES;
    
    self.histroyView.tagCornerRadius = 10.0f;
    [self.histroyView.tags addObject:searchBar.text];
    [self.histroyView.collectionView reloadData];
    [self.histroyView setCompletionBlockWithSelected:^(NSInteger index) {
        WLZLog(@"%ld",(long)index);
    }];
    NSString *encodingString = [searchBar.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    __weak RecommendViewController *weakself = self;
    [self.histroyView setCompletionBlockWithSelected:^(NSInteger index) {
        searchBar.text = weakself.histroyView.tags[index];
        searchForWorldViewController *seaVC = [[searchForWorldViewController alloc] init];
        seaVC.text = weakself.histroyView.tags[index];
        seaVC.keyId = encodingString;
        [weakself.navigationController pushViewController:seaVC animated:YES];
        
    }];
    
    
    /*
     1.url编码
     
     ios中http请求遇到汉字的时候，需要转化成UTF-8，用到的方法是：
     
     NSString * encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
     
     */
    
    searchForWorldViewController *worldVC = [[searchForWorldViewController alloc] init];
    worldVC.text = searchBar.text;
    worldVC.keyId = encodingString;
    [self.navigationController pushViewController:worldVC animated:YES];
    
    
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    //点击空白回收键盘
    [self.mySearchBar resignFirstResponder];
}
/**
 *  http://api.breadtrip.com/trips/2387095924/schedule/?offline=true
 *http://api.breadtrip.com/trips/2387095924/waypoints/
 *  @return
 */
//添加轻拍手势  回收键盘
- (void)tapgr{
        UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        tapGr.cancelsTouchesInView = NO;
        [self.view addGestureRecognizer:tapGr];
    }
-(void)viewTapped:(UITapGestureRecognizer*)tapGr
{
    [self.mySearchBar resignFirstResponder];
}
//在页面将要出现的时候
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    self.mySearchBar.hidden = NO;

    if (_ppp == 0) {
        self.nearBtn.hidden = NO;
        self.cancelBtn.hidden = YES;
        
    }else{
        self.cancelBtn.hidden = NO;
        self.nearBtn.hidden = YES;
        
    }
   
    
}
//在页面将要消失的时候，调用此方法，去掉所有的
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mySearchBar.hidden = YES;
    self.nearBtn.hidden = YES;
    self.cancelBtn.hidden = YES;
}
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
    _AdvertisementImageView = [[JXBAdPageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight*0.3)];
    _AdvertisementImageView.contentMode = UIViewContentModeScaleAspectFill;
    _AdvertisementImageView.iDisplayTime = 2;
    _AdvertisementImageView.bWebImage = YES;
    _AdvertisementImageView.delegate = self;
    if (self.advertisementArray.count>0) {
//        NSArray *arr = self.advertisementArray;
        [_AdvertisementImageView startAdsWithBlock:self.advertisementArray block:^(NSInteger clickIndex){
            advertisingViewController *adVC = [[advertisingViewController alloc] init];
            adVC.html = self.htmlArray[clickIndex];
            [self.navigationController pushViewController:adVC animated:NO];
           
//            NSLog(@"%d",(int)clickIndex);
        }];

    }
        //collectionview 头部
    UILabel *collectionViewSectionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight*0.305, kWidth-100, 40)];
   collectionViewSectionLable.text = self.collectionViewSectionArray[@"title"];
    UIButton *collectionViewSectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(kWidth - 80, kHeight*0.305, 60, 40)];
    [collectionViewSectionBtn setTitle:@"全部" forState:UIControlStateNormal];
    [collectionViewSectionBtn addTarget:self action:@selector(allCollection) forControlEvents:UIControlEventTouchUpInside];
    [collectionViewSectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //tableView头部
    UILabel *tableViewSectionLable = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight*1.05, kWidth, 40)];
    tableViewSectionLable.text = self.tableViewSectionArray[@"title"];
  
    [self.headerView addSubview:tableViewSectionLable];
    [self.headerView addSubview:collectionViewSectionBtn];
    [self.headerView addSubview:collectionViewSectionLable];
    // 添加进系统视图
    [self.headerView addSubview:_AdvertisementImageView];
    [self.headerView addSubview:self.collectionView];

}
//广告轮播全部的点击方法
- (void)allCollection{
    allCollectionViewController *allVC = [[allCollectionViewController alloc] init];
    [self.navigationController pushViewController:allVC animated:NO];
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
       
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [ProgressHUD showSuccess:@"请求成功"];
//        WLZLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        //请求主要数据data
        NSDictionary *dic1 = dic[@"data"];
        //请求首页数据
        
        NSArray *elements = dic1[@"elements"];
        _next_start = dic1[@"next_start"];
        NSArray *searchArray = dic1[@"search_data"];
        if (_refreshing) {
            if (self.advertisementArray.count > 0) {
                [self.advertisementArray removeAllObjects];
                [self.introduceImageArray removeAllObjects];
                [self.introduceLableArray removeAllObjects];
                [self.elementsArr removeAllObjects];
                [self.id12Array removeAllObjects];
                [self.nameImageArray removeAllObjects];
                [self.nameLableArray removeAllObjects];
                [self.spot_idArray removeAllObjects];
                [self.tableViewArray removeAllObjects];
                [self.htmlArray removeAllObjects];
                [self.foreignListArray removeAllObjects];
                [self.inlandListArray removeAllObjects];
                [self.foreignsearchId removeAllObjects];
                [self.inlandId removeAllObjects];
            }
        }
        for (NSDictionary *dicSearch in searchArray) {
            if ([dicSearch[@"title"]isEqualToString:@"国外热门目的地"]) {
                for (NSDictionary *dicForeign  in dicSearch[@"elements"]) {
                    [self.foreignListArray addObject:dicForeign[@"name"]];
                    [self.foreignsearchId addObject:dicForeign[@"id"]];
                    [self.typeForeignArray addObject:dicForeign[@"type"]];
                }
            }
            if ([dicSearch[@"title"]isEqualToString:@"国内热门目的地"]) {
                for (NSDictionary *dicInland  in dicSearch[@"elements"]) {
                    [self.inlandListArray addObject:dicInland[@"name"]];
                     [self.inlandId addObject:dicInland[@"id"]];
                     [self.typeInLandArray addObject:dicInland[@"type"]];
                }

            }
            
        }
      for (NSDictionary *dic2 in elements) {
            //请求广告数据
          
            if ([dic2[@"desc"] isEqualToString:@"广告banner"]) {
                NSArray *data = dic2[@"data"];
                NSArray *item = data[0];
                for (NSDictionary *dic3 in item) {
                    [self.advertisementArray addObject:dic3[@"image_url"]];
                    [self.htmlArray addObject:dic3[@"html_url"]];
                    
                }
                
            }
            //请求出来的数据是NSString类型  但转换为数据却是NSNumber类型
           else if (dic2[@"type"] == [NSNumber numberWithInteger:10]) {
                NSArray *data = dic2[@"data"];
                for (NSDictionary *dic3 in data) {
                    [self.spot_idArray addObject:dic3[@"spot_id"]];
                    
                    
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
               
                
            }
          else if (dic2[@"type"] == [NSNumber numberWithInteger:4]||[dic2[@"desc"] isEqualToString:@"热门游记"]) {
              [self.elementsArr addObject:dic2[@"type"]];
              NSArray *data = dic2[@"data"];
              for (NSDictionary *dic4 in data) {
                  RecommendModel *model = [[RecommendModel alloc] initWithDictionary:dic4];
                  [self.id12Array addObject:dic4[@"id"]];
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
        [self addWhiteView];
        
        //刷新tableView
        [self.tableView reloadData];
       //刷新collectionview
        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [ProgressHUD showError:@"请求失败"];
        
    }];
//    WLZLog(@"刷新网络请求");
}
#pragma mark ----------------UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.tableViewArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    RecommendTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[RecommendTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
         cell.model = self.tableViewArray[indexPath.row];
    
   
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.id12Array[indexPath.row];
           if (self.elementsArr[indexPath.row] == [NSNumber numberWithInteger:12]) {
            originalViewController *orVC = [[originalViewController alloc] init];
            
               orVC.userId = str;
            [self.navigationController pushViewController:orVC animated:YES];
        }
        else if (self.elementsArr[indexPath.row] == [NSNumber numberWithInteger:4]) {
            specialViewController *specialVC = [[specialViewController alloc] init];
           
            specialVC.userId = str;
            [self.navigationController pushViewController:specialVC animated:YES];
        
        
    }
    
    
}
#pragma mark ----------------UICollectionViewDataSource
//返回分区有多少条目
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.nameLableArray.count;
  
    
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
    storyDetailsViewController *storyVC = [[storyDetailsViewController alloc] init];
    storyVC.spot_id = self.spot_idArray[indexPath.row];
    [self.navigationController pushViewController:storyVC animated:YES];
}

//返回这个UICollectionView是否可以被选择
-(BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (void)selectItemAtIndexPath:(nullable NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UICollectionViewScrollPosition)scrollPosition{
    scrollPosition = UICollectionViewScrollPositionTop;
}
#pragma mark     -------------懒加载--------------

- (NSMutableArray *)id12Array{
    if (_id12Array == nil) {
        self.id12Array = [NSMutableArray new];
    }
    return _id12Array;
}
- (NSMutableArray *)elementsArr{
    if (_elementsArr == nil) {
        self.elementsArr = [NSMutableArray new];
    }
    return _elementsArr;
}
- (NSMutableArray *)typeForeignArray{
    if (_typeForeignArray == nil) {
        self.typeForeignArray = [NSMutableArray new];
    }
    return _typeForeignArray;
}
- (NSMutableArray *)typeInLandArray{
    if (_typeInLandArray == nil) {
        self.typeInLandArray = [NSMutableArray new];
    }
    return _typeInLandArray;
}
//取消按钮
- (UIButton *)cancelBtn{
    if (_cancelBtn == nil) {
        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    return _cancelBtn;
}
//搜索id
- (NSMutableArray *)foreignsearchId{
    if (_foreignsearchId == nil) {
        self.foreignsearchId = [NSMutableArray new];
    }
    return _foreignsearchId;
}
//国内
- (NSMutableArray *)inlandId{
    if (_inlandId == nil) {
        self.inlandId = [NSMutableArray new];
    }
    return _inlandId;
}
- (NSMutableArray *)spot_idArray{
    if (_spot_idArray == nil ) {
        self.spot_idArray = [NSMutableArray new];
    }
    return _spot_idArray;
}
//html懒加载
- (NSMutableArray *)htmlArray{
    if (_htmlArray == nil) {
        self.htmlArray = [NSMutableArray new];
    }
    return _htmlArray;
}
- (JCTagListView *)histroyView{
    if (_histroyView == nil) {
        self.histroyView = [[JCTagListView alloc] initWithFrame:CGRectMake(30, 500, kWidth-60, kHeight*0.4)];
        [self.searchView addSubview:self.histroyView];
        
    }
    return _histroyView;
}
- (UIButton *)nearBtn{
    if (_nearBtn == nil) {
        self.nearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
    }
    return _nearBtn;
}
- (JCTagListView *)foreignView{
    if (_foreignView == nil) {
        self.foreignView = [[JCTagListView alloc] initWithFrame:CGRectMake(30, 120, kWidth-60, kHeight*0.4)];
        self.foreignView.tag = 1;
        [self.searchView addSubview:self.foreignView];
     
    }
    return _foreignView;
}
- (JCTagListView *)inLandView{
    if (_inLandView == nil ) {
        self.inLandView = [[JCTagListView alloc] initWithFrame:CGRectMake(30, 350, kWidth-60, kHeight*0.4)];
        self.inLandView.tag = 2;
        [self.searchView addSubview:self.inLandView];
       
    }
    return _inLandView;
}
- (UIScrollView *)searchView{
    if (_searchView == nil) {
        self.searchView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, -kHeight, kWidth, kHeight*0.7)];
        self.searchView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:self.searchView];
        self.searchView.contentSize = CGSizeMake(kWidth, 700);
    }
    return _searchView;
}
- (NSMutableArray *)foreignListArray{
    if (_foreignListArray == nil) {
        self.foreignListArray = [NSMutableArray new];
    }
    return _foreignListArray;
}
- (NSMutableArray *)inlandListArray{
    if (_inlandListArray == nil) {
        self.inlandListArray = [NSMutableArray new];
    }
    return _inlandListArray;
}
//广告轮播数据
- (NSMutableArray *)advertisementArray{
    if (_advertisementArray == nil) {
        self.advertisementArray = [NSMutableArray new];
    }
    return _advertisementArray;
}
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
        self.tableView = [[PullingRefreshTableView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight-108) pullingDelegate:self];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
        self.tableView.rowHeight = 250;
        [self.tableView registerNib:[UINib nibWithNibName:@"RecommendTableViewCell" bundle:nil] forCellReuseIdentifier:cellIdentifier];
    }
    return _tableView;
}
//tableView头部试图的懒加载
- (UIView *)headerView{
    if (_headerView == nil) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth,kHeight*1.1 )];
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
        layout.itemSize = CGSizeMake(kWidth*0.48, kHeight*0.315);
        //通过一个layout来创建一个UICollectionView
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kHeight*0.37, kWidth, kHeight) collectionViewLayout:layout];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        
    }
    return _collectionView;
}
//collerctionViewArray数组懒加载
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
