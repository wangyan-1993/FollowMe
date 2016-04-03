//
//  originalViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
////http://api.breadtrip.com/v2/new_trip/?trip_id=2387101809

#import "originalViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "originalTableViewCell.h"
@interface originalViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UITableView *tableView;

//头部
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, retain) NSString *headImage;
@property (nonatomic, retain) NSString *userImage;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *introduce;
@end

@implementation originalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor redColor];
    [self workOne];
    [self.view addSubview:self.tableView];
    [self headWay];
}
- (void)workOne{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"http://api.breadtrip.com/v2/new_trip/?trip_id=%@",self.userId] parameters:self.userId progress:^(NSProgress * _Nonnull downloadProgress) {
        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // WLZLog(@"%@",responseObject);
        NSDictionary *rootDic = responseObject;
        //头部图片
        NSDictionary *dataDic = rootDic[@"data"];
        self.headImage = dataDic[@"cover_image_1600"];
        self.introduce = dataDic[@"name"];
        //遍历用户字典
        NSDictionary *userDic = dataDic[@"user"];
        self.userImage = userDic[@"avatar_m"];
        self.userName = userDic[@"name"];
        [self.tableView reloadData];
        [self headWay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
    
    
}
- (void) headWay {
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight*0.25)];
    headImage.backgroundColor = [UIColor blackColor];
    [headImage sd_setImageWithURL:[NSURL URLWithString:self.headImage] placeholderImage:nil];
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-25, kHeight*0.25-25, 50, 50)];
    userImage.backgroundColor = [UIColor orangeColor];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 25.f;
    userImage.layer.borderWidth = 3;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [userImage sd_setImageWithURL:[NSURL URLWithString:self.userImage] placeholderImage:nil];
    
    UILabel *Namelable = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight*0.25+25, kWidth, 50)];
    Namelable.text = self.userName;
    Namelable.enabled = NO;
    Namelable.highlighted = YES;
    Namelable.font = [UIFont systemFontOfSize:13];
    Namelable.textAlignment = NSTextAlignmentCenter;
    
    UILabel *introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(70, kHeight*0.25+75, kWidth-140, kHeight*0.25-90)];
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
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消cell的重用机制
    static NSString *cellid = @"cellid";
    originalTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[originalTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return 10;
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
        self.tableView.rowHeight = 80;
        self.tableView.backgroundColor = kCollectionColor;
        
        
        
    }
    return _tableView;
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
