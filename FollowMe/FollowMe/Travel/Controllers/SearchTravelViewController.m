//
//  SearchTravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SearchTravelViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "SearchModel.h"
#import "SearchCollectionViewCell.h"
#import "ThirdTravelViewController.h"
@interface SearchTravelViewController ()<UISearchBarDelegate, UICollectionViewDataSource, UICollectionViewDelegate>
@property(nonatomic, strong) UISearchBar *mySearchBar;
@property(nonatomic, strong) NSMutableArray *numArray;
@property(nonatomic, strong) NSMutableArray *urlArray;
@property(nonatomic, strong) UICollectionView *collectionView;
@end

@implementation SearchTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 10, kWidth-40, 40)];
    self.mySearchBar.delegate = self;
    self.mySearchBar.text = self.cityName;
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self showBackBtn];
    [self.view addSubview:self.collectionView];
    [self loadData];
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mySearchBar.hidden = YES;
}
- (void)loadData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *str = [NSString stringWithFormat:@"%@%@",@"http://api.breadtrip.com/product/search/?keyword=", self.cityName];
    NSString *urlString = [str stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //WLZLog(@"%@", responseObject);
        NSDictionary *dictionary = responseObject;
        
        NSDictionary *dict = dictionary[@"data"];
        NSArray *array = dict[@"product"];
        for (NSDictionary *dic in array) {

            NSMutableArray *allArray = [NSMutableArray new];
            NSArray *arr = dic[@"data"];
            NSString *url = dic[@"url"];
            for (NSDictionary *dataDic in arr) {
                SearchModel *model = [[SearchModel alloc]initWithDictionary:dataDic];
                [allArray addObject:model];
                WLZLog(@"%@", model.title);
            }
            [self.numArray addObject:allArray];
            [self.urlArray addObject:url];
        }

        [self.collectionView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@", error);
    }];

}

#pragma mark---UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    NSArray *array = self.numArray[section];
    return array.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    SearchCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"city" forIndexPath:indexPath];
    
    SearchModel *model = self.numArray[indexPath.section][indexPath.row];
    WLZLog(@"%@", model.title);
   cell.backgroundColor = [UIColor whiteColor];
    cell.model = model;
    cell.layer.cornerRadius = 5;
    cell.clipsToBounds = YES;
    return cell;
}
#pragma mark---UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ThirdTravelViewController *third = [[ThirdTravelViewController alloc]init];
    SearchModel *model = self.numArray[indexPath.section][indexPath.row];
    third.urlString = model.url;
    third.hidesBottomBarWhenPushed = YES;
    self.mySearchBar.hidden = YES;
    [self.navigationController pushViewController:third animated:YES];
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return self.numArray.count;
}

#pragma mark---懒加载

- (NSMutableArray *)numArray{
    if (_numArray == nil) {
        self.numArray = [NSMutableArray new];
    }
    return _numArray;
}
- (NSMutableArray *)urlArray{
    if (_urlArray == nil) {
        self.urlArray = [NSMutableArray new];
    }
    return _urlArray;
}
//--------

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //创建一个layout布局类
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        //设置布局方向,垂直方向
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置每个item的大小
        layout.itemSize = CGSizeMake(kWidth*0.48, kWidth/9*5);
        //每一行的间距
        layout.minimumLineSpacing = 10;
        //item的间距
        layout.minimumInteritemSpacing = 1;
        //section的边距
        layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
        //通过一个layout布局来创建一个collectionView
        self.collectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:layout];
        //设置代理
        self.collectionView.dataSource = self;
        self.collectionView.delegate = self;
        self.collectionView.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
        
        //注册item类型
        [self.collectionView registerClass:[SearchCollectionViewCell class] forCellWithReuseIdentifier:@"city"];
        //注册区头
        [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];

    }
    return _collectionView;
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
