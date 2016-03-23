//
//  allCollectionViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//
#define kAllCollection @"http://api.breadtrip.com/v2/new_trip/spot/hot/list/?"
#import "allCollectionViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "CollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"
#import "storyDetailsViewController.h"
@interface allCollectionViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>{
    NSInteger _start;
}
//collerctionView请求出的数组
@property (nonatomic, strong) NSMutableArray *collerctionViewArray;
@property (nonatomic, strong) NSMutableArray *introduceImageArray;
@property (nonatomic, strong) NSMutableArray *introduceLableArray;
@property (nonatomic, strong) NSMutableArray *nameImageArray;
@property (nonatomic, strong) NSMutableArray *nameLableArray;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *spot_idArray;
@property (nonatomic, assign) BOOL isRefresh;
@end

@implementation allCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"精选故事";
    self.view.backgroundColor = kCollectionColor;
    //设置导航栏标题颜色
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor] }];
    // Do any additional setup after loading the view.
    _start = 0;
    
    //下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //增加数据
        [self.collectionView.mj_header beginRefreshing];
        _start = 0;
        self.isRefresh = YES;
        [self workOne];
        [self.collectionView.mj_header endRefreshing];
    }];
    
    //上拉加载
    self.collectionView.mj_footer = [MJRefreshAutoFooter footerWithRefreshingBlock:^{
        [self.collectionView.mj_footer beginRefreshing];
        _start += 12;
        self.isRefresh = NO;
        [self workOne];
        //结束刷新
        [self.collectionView.mj_footer endRefreshing];
    }];
    //网络请求
    [self workOne];
    [self.view addSubview:self.collectionView];
    
}

- (void)workOne{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@start=%ld",kAllCollection,(long)_start] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WLZLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        //请求主要数据data
        NSDictionary *dic1 = dic[@"data"];
        if (_isRefresh) {
            if (self.introduceLableArray.count > 0) {
                [self.introduceLableArray removeAllObjects];
                [self.introduceImageArray removeAllObjects];
                [self.nameImageArray removeAllObjects];
                [self.nameLableArray removeAllObjects];
                [self.collerctionViewArray removeAllObjects];
                [self.spot_idArray removeAllObjects];
                
            }

        }
                   if (dic[@"status"] == [NSNumber numberWithInteger:0]) {
            NSArray *data = dic1[@"hot_spot_list"];
            for (NSDictionary *dic3 in data) {
                if ([dic3[@"index_title"] isEqualToString:@""] ) {
                    [self.introduceLableArray addObject:dic3[@"text"]];
                }else{
                    [self.introduceLableArray addObject:dic3[@"index_title"]];
                }
                //获取属性传值数组
                [self.spot_idArray addObject:dic3[@"spot_id"]];
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
        
        [self.collectionView reloadData];
     
     
     
     
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];

}

//collectionview的代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    [cell.introduceImageView sd_setImageWithURL:[NSURL URLWithString:self.introduceImageArray[indexPath.row]] placeholderImage:nil];
    cell.introduceLable.text = self.introduceLableArray[indexPath.row];
    cell.introduceLable.numberOfLines = 0;
    cell.introduceLable.font = [UIFont systemFontOfSize:13];
    [cell.nameImageView sd_setImageWithURL:[NSURL URLWithString:self.nameImageArray[indexPath.row]] placeholderImage:nil];
    cell.nameLable.text = self.nameLableArray[indexPath.row];
    cell.nameLable.numberOfLines = 0;
    cell.nameLable.font = [UIFont systemFontOfSize:11];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.nameLableArray.count;

}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    storyDetailsViewController *storyVC = [[storyDetailsViewController alloc] init];
    storyVC.spot_id = self.spot_idArray[indexPath.row];
    [self.navigationController pushViewController:storyVC animated:YES];
}
#pragma mark spotid_Array   属性传值数组
- (NSMutableArray *)spot_idArray{
    if (_spot_idArray == nil) {
        self.spot_idArray = [NSMutableArray new];
    }
    return _spot_idArray;
}

#pragma mark collection-----懒加载

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //创建一个布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认垂直方向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置item的间距
        layout.minimumInteritemSpacing = 1;
        //设置每一列的间距
        layout.minimumLineSpacing = 10;
        //设置section的间距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //设置每个item的大小
        layout.itemSize = CGSizeMake(kWidth * 0.48, kHeight*0.315);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:layout];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        
    }
    return _collectionView;
}
#pragma mark collerctionViewArray数组懒加载 
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
