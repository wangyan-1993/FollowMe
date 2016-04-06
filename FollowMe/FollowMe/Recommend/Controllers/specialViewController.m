//
//  specialViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "specialViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "specialTableViewCell.h"
#import "specialModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
@interface specialViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>
@property (nonatomic, strong) UITableView *tableView;
//头部
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, retain) NSString *headImage;
@property (nonatomic, retain) NSString *userImage;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *introduce;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *daysArray;

@end

@implementation specialViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.tabBarController.tabBar.hidden = YES;
    [self workOne];
    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[specialTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = kCollectionColor;
    //不让导航栏随着tableview上下滑动
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

- (void)headWay{
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"follow" ofType:@"gif"];
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //创建一个webView，添加到界面
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [self.view addSubview:webView];
    //自动调整尺寸
    webView.scalesPageToFit = YES;
    //禁止滚动
    webView.scrollView.scrollEnabled = NO;
    //设置透明效果
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = 0;
    //加载数据
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.headView addSubview:webView];
    
    
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight*0.25)];
    headImage.backgroundColor = [UIColor blackColor];
    if ([self.headImage isEqual:[NSNull null]]) {
        headImage.image = [UIImage imageNamed:@"200"];
    }else{
        [headImage sd_setImageWithURL:[NSURL URLWithString:self.headImage] placeholderImage:nil];}
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-25, kHeight*0.25-25+64, 50, 50)];
    userImage.backgroundColor = [UIColor orangeColor];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 25.f;
    userImage.layer.borderWidth = 3;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [userImage sd_setImageWithURL:[NSURL URLWithString:self.userImage] placeholderImage:nil];
    
    UILabel *Namelable = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight*0.25+25+64, kWidth, 50)];
    Namelable.text = self.userName;
    Namelable.enabled = NO;
    Namelable.highlighted = YES;
    Namelable.font = [UIFont systemFontOfSize:13];
    Namelable.textAlignment = NSTextAlignmentCenter;
    
    UILabel *introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(70, kHeight*0.25+75+64, kWidth-140, kHeight*0.25-90)];
    introduceLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    introduceLable.text = self.introduce;
    introduceLable.numberOfLines = 0;
    introduceLable.textAlignment = NSTextAlignmentCenter;

    [self.headView addSubview:introduceLable];
    [self.headView addSubview:Namelable];
    [self.headView addSubview:headImage];
    [self.headView addSubview:userImage];
    self.tableView.tableHeaderView = self.headView;
}

- (void)workOne{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.breadtrip.com/trips/%@/waypoints/",self.userId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //WLZLog(@"%@",responseObject);
        NSDictionary *rootDic = responseObject;
        //头部图片
        self.headImage = rootDic[@"trackpoints_thumbnail_image"];
        self.introduce = rootDic[@"name"];
        //遍历用户字典
        NSDictionary *userDic = rootDic[@"user"];
        self.userImage = userDic[@"avatar_m"];
        self.userName = userDic[@"name"];
        //遍历旅游线路日程
        NSArray *daysArray = rootDic[@"days"];
        for (NSDictionary *dic in daysArray) {
            [self.daysArray addObject:dic];
            [self.sectionArray addObject:dic[@"waypoints"]];
        NSArray *wayArray = dic[@"waypoints"];
        
            NSMutableArray *group = [NSMutableArray new];
        for (NSDictionary *dic1 in wayArray) {

            specialModel *model = [[specialModel alloc] initWithDictionary:dic1];
            [group addObject:model];
        
            }
            [self.tableViewArray addObject:group];
        }
        
        [self.tableView reloadData];
        [self headWay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *group = self.tableViewArray[indexPath.section];
    specialModel *model = group[indexPath.row];
    CGFloat cellHeight = [specialTableViewCell getCellHeightWithModel:model];
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, kWidth, 20)];
    
    NSString *str1   = self.daysArray[section][@"date"];
    NSString *str2   = self.daysArray[section][@"day"];
    NSString *str    = [NSString stringWithFormat:@"第%@天  %@",str2,str1];
    
    UILabel *lable   = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,kWidth-10, 20)];
    lable.text       = str;
    lable.textColor  = [UIColor brownColor];

    [headView addSubview:lable];
    return headView;
}
//让分区头部视图随着屏幕滑动而滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat height = 26;
        if (scrollView.contentOffset.y <= height && scrollView.contentOffset.y > 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if(scrollView.contentOffset.y >= height){
            scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消cell的重用机制
    static NSString *cellid = @"cellid";
    specialTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[specialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    specialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.tableViewArray > 0) {
        NSMutableArray *group = self.tableViewArray[indexPath.section];
        cell.model = group[indexPath.row];
    }
    
    cell.owone = self;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *group = self.sectionArray[section];
    return group.count;
}
- (UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight*0.5+64)];
//        self.headView.backgroundColor = [UIColor cyanColor];
        self.headView.backgroundColor = kCollectionColor;
        
    }
    return _headView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 0, kWidth, kHeight)style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.rowHeight = 375;
        self.tableView.backgroundColor = kCollectionColor;


        
    }
    return _tableView;
}
- (NSMutableArray *)daysArray{
    if (_daysArray == nil) {
        self.daysArray = [NSMutableArray new];
    }
    return _daysArray;
}
- (NSMutableArray *)tableViewArray{
    if (_tableViewArray == nil) {
        self.tableViewArray = [NSMutableArray new];
    }
    return _tableViewArray;
}
- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil) {
        self.sectionArray = [NSMutableArray new];
    }
    return _sectionArray;
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
