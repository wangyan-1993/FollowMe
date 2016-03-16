//
//  RecommendViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "RecommendViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
//广告轮播第三方
#import "JXBAdPageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "CollectionViewCell.h"
//全局静态变量
static NSString *collectionHeader = @"cityHeader";
static NSString *itemID = @"itemId";
//广告轮播代理（JXBAdPageViewDelegate）
@interface RecommendViewController ()<JXBAdPageViewDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDataSource,UITableViewDelegate>{
    //广告轮播数据数组
    NSMutableArray *_AdvertisementArray;
    
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
//tableView的头部试图
@property (nonatomic, strong) UIView *headerView;
//tableView
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation RecommendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _AdvertisementArray = [NSMutableArray new];
    //collectionview添加进系统视图
    [self.headerView addSubview:self.collectionView];
    //请求数据
    [self workOne];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = self.headerView;


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
    // 添加进系统视图
    [self.headerView addSubview:_AdvertisementImageView];
    
}
//第三方广告轮播代理
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl {
    [imgView sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
}
#pragma mark -------------请求网络数据---------------
- (void)workOne{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:@"http://api.breadtrip.com/v2/index/?" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //        NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = responseObject;
        //请求主要数据data
        NSDictionary *dic1 = dic[@"data"];
        //请求首页数据
        NSArray *elements = dic1[@"elements"];
        for (NSDictionary *dic2 in elements) {
            //请求广告数据
            if ([dic2[@"desc"] isEqualToString:@"广告banner"]) {
                NSArray *data = dic2[@"data"];
                NSArray *item = data[0];
                for (NSDictionary *dic3 in item) {
                    [_AdvertisementArray addObject:dic3[@"image_url"]];
                }
                [self AdvertisementArray];
            }
            
            if (dic2[@"type"] == [NSNumber numberWithInteger:10]) {
                NSArray *data = dic2[@"data"];
                for (NSDictionary *dic3 in data) {
                    if ([dic3[@"index_title"] isEqualToString:@""] ) {
                        [self.introduceLableArray addObject:dic3[@"text"]];
                    }else{
                        [self.introduceLableArray addObject:dic3[@"index_title"]];
                    }
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
            
        }
        //        NSLog(@"%@",self.nameLableArray);
        [self.collectionView reloadData];
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        NSLog(@"%@",error);
    }];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

#pragma mark ----------------UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
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
//tableView的懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) style:UITableViewStylePlain];
    }
    return _tableView;
}
//tableView头部试图的懒加载
- (UIView *)headerView{
    if (_headerView == nil) {
        self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
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
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,200, kWidth, kHeight) collectionViewLayout:layout];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
