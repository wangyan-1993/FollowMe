//
//  photoViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/31.
//  Copyright © 2016年 SCJY. All rights reserved.
//
//http://api.breadtrip.com/destination/place/5/2388522624/photos/?start=0&count=21&gallery_mode=true
#import "photoViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "MJRefresh.h"
@interface photoViewController ()<
    UICollectionViewDataSource,UICollectionViewDelegate,
    UICollectionViewDelegateFlowLayout>
{
    NSInteger _start;
}
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, assign) BOOL isRefresh;
@property (nonatomic, strong) NSMutableArray *imageArray;
@end

@implementation photoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _start = 0;
    self.title = @"图片";
    [self showWhiteBackBtn];
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
        _start += 21;
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
    WLZLog(@"%ld",_start);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.breadtrip.com/destination/place/%@/%@/photos/?start=%ld&count=21&gallery_mode=true",self.typeId,self.userId,(long)_start] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              // WLZLog(@"%@",responseObject);
        NSDictionary *dic = responseObject;
        //请求主要数据data
        NSArray *items = dic[@"items"];
        if (_isRefresh) {
            if (self.imageArray.count > 0) {
                [self.imageArray removeAllObjects];
            }
        }
       
        for (NSDictionary *dict in items) {
            [self.imageArray addObject:dict[@"photo"]];
        }
        
        [self.collectionView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
    
}

//collectionview的代理
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kWidth/3)-10, (kWidth/3)-10)];
        NSString *group = self.imageArray[indexPath.row];
//        WLZLog(@"%@",group);
        [imageView sd_setImageWithURL:[NSURL URLWithString:group] placeholderImage:nil];
    
    
    
    
    [cell.contentView addSubview:imageView];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.imageArray.count;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
   
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //创建一个布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //设置布局方向(默认垂直方向)
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置item的间距
        layout.minimumInteritemSpacing = 5;
        //设置每一列的间距
        layout.minimumLineSpacing = 5;
        //设置section的间距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //设置每个item的大小
        layout.itemSize = CGSizeMake((kWidth/3)-10, (kWidth/3)-10);
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight) collectionViewLayout:layout];
        //设置代理
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
        self.collectionView.backgroundColor = [UIColor clearColor];
        
        
    }
    return _collectionView;
}
- (NSMutableArray *)imageArray{
    if (_imageArray == nil) {
        self.imageArray = [NSMutableArray new];
    }
    return _imageArray;
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
