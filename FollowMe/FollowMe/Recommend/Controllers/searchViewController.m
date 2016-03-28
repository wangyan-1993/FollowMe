//
//  searchViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

/*
 1.url编码
 
 ios中http请求遇到汉字的时候，需要转化成UTF-8，用到的方法是：
 
 NSString * encodingString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
 
 */

#define ksearchDetail @"http://api.breadtrip.com/destination/place/"

#import "searchViewController.h"
#import "SearchOneCollectionViewCell.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
@interface searchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) UICollectionView *collectionViewOne;
@property (nonatomic,strong) UIImageView *headerImage;
@property (nonatomic, strong) NSDictionary *headDic;
@property (nonatomic, strong) NSDictionary *rootDic;
@property (nonatomic, strong) NSArray *pictureArray;
@end

@implementation searchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    //隐藏下方导航
    self.tabBarController.tabBar.hidden = YES;
//    WLZLog(@"%@",self.type);
//    WLZLog(@"%@",self.userId);
    [self.view addSubview:self.collectionViewOne];
    [self netWork];
//    [self addContent];

    
    
}

#pragma mark ------------网络请求
- (void)netWork{
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    [manger GET:[NSString stringWithFormat:@"%@%@/%@/",ksearchDetail,self.type,self.userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // WLZLog(@"%@",responseObject);
        self.rootDic = responseObject;
        //获取头部图片
        NSArray *arr = self.rootDic[@"hottest_places"];
        self.headDic = arr[0];
        //collectionView图片
      self.pictureArray = [NSArray arrayWithObjects:@"search1",@"search3",@"search5",@"search7",@"search9",@"search11",@"search13", nil];
        [self addContent];
        [self.collectionViewOne reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //WLZLog(@"%@",error);
    }];
}

#pragma mark -------------collectionView 代理


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.pictureArray.count;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"oneCell" forIndexPath:indexPath];
   UIImageView *imageView = [[UIImageView alloc]initWithFrame: CGRectMake(0, 0, (kWidth-23)/4, (kWidth-23)/4)];
    imageView.image = [UIImage imageNamed:self.pictureArray[indexPath.row]];
    [cell.contentView addSubview:imageView];
    
    
    return cell;
}
#pragma mark -------------collectionView 头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *head = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"head" forIndexPath:indexPath];
#pragma mark ------------图片头部视图
        [head addSubview:self.headerImage];
        return head;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
        UICollectionReusableView *foot = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"foot" forIndexPath:indexPath];
        
        
        UIButton *selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        selectBtn.frame = CGRectMake(0, 0, kWidth, kHeight/11);
        [selectBtn setTitle:@"全部热门地点" forState:UIControlStateNormal];
        [selectBtn setTitleColor:[UIColor colorWithRed:215/255.f green:215/255.f blue:214/255.f alpha:1.0] forState:UIControlStateNormal];
        selectBtn.layer.cornerRadius = kHeight/22.f;
        selectBtn.backgroundColor = kCollectionColor;
        selectBtn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:22];
        [selectBtn addTarget:selectBtn action:@selector(chickCity) forControlEvents:UIControlEventTouchUpInside];
        
        
        [foot addSubview:selectBtn];
        return foot;
    }
    return nil;
}
#pragma mark ------------全部热门地点
- (void)chickCity{
    
}
#pragma mark ------------图片头部视图方法

- (void)addContent{
    [self.headerImage sd_setImageWithURL:[NSURL URLWithString:self.headDic[@"photo"]] placeholderImage:nil];
    //城市
    UILabel *cityLable = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight/4.2, 100, 30)];
    cityLable.text = self.rootDic[@"name"];
    cityLable.font = [UIFont systemFontOfSize:22];
    cityLable.textColor = [UIColor whiteColor];
    [self.headerImage addSubview:cityLable];
    //去过次数以及喜欢人数
    UILabel *beenAndLike = [[UILabel alloc] initWithFrame:CGRectMake(10, kHeight/3.7, kWidth, 30)];
    NSString *str1 = self.rootDic[@"visited_count"];
    NSString *str2 = self.rootDic[@"wish_to_go_count"];
    beenAndLike.text = [NSString stringWithFormat:@"%@去过/%@喜欢",str1,str2];
    beenAndLike.textColor = [UIColor whiteColor];
    beenAndLike.font = [UIFont systemFontOfSize:13];

    [self.headerImage addSubview:beenAndLike];
    //多少张图片
    UILabel *pictureCount = [[UILabel alloc] initWithFrame:CGRectMake(kWidth-50, kHeight/3.7, 50, 30)];
    pictureCount.text = @"12K";
    pictureCount.textColor = [UIColor whiteColor];

    [self.headerImage addSubview:pictureCount];

}
- (UIImageView *)headerImage{
    if (_headerImage == nil) {
     self.headerImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight/3.1)];
        self.headerImage.contentMode=UIViewContentModeScaleAspectFill;
        self.headerImage.clipsToBounds=YES;

        
    }
    return _headerImage;
}

#pragma mark -------------collectionView 初始化
- (UICollectionView *)collectionViewOne{
    if (_collectionViewOne == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 1;
        layout.itemSize = CGSizeMake((kWidth-23)/4, (kWidth-23)/4);
        layout.sectionInset = UIEdgeInsetsMake(10, 10, 30, 10);
        layout.headerReferenceSize = CGSizeMake(kWidth, kHeight/3.1);
        layout.footerReferenceSize = CGSizeMake(kWidth, kHeight/10);
        self.collectionViewOne = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
        [self.collectionViewOne registerClass:[UICollectionViewCell class]forCellWithReuseIdentifier:@"oneCell"];
//        注册头部
        [self.collectionViewOne registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"head"];
        //注册尾部
        [self.collectionViewOne registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"foot"];
        
        
        
        self.collectionViewOne.backgroundColor=[UIColor whiteColor];
        self.collectionViewOne.delegate=self;
        self.collectionViewOne.dataSource=self;
        self.collectionViewOne.bounces = NO;
        
    }
    return _collectionViewOne;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  懒加载
//- (NSArray *)pictureArray{
//    if (_pictureArray == nil) {
//        self.pictureArray = [NSArray new];
//    }
//    return _pictureArray;
//}
- (NSDictionary *)headDic{
    if (_headDic == nil) {
        self.headDic = [NSDictionary new];
    }
    return _headDic;
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
