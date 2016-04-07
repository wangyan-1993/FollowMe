//
//  likeViewController.m
//  FollowMe
//
//  Created by scjy on 16/4/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "likeViewController.h"
#import <BmobSDK/Bmob.h>
#import <AFNetworking/AFHTTPSessionManager.h>
#import "likeModel.h"
#import "likeTableViewCell.h"
#import "specialViewController.h"
#import "messageTwoViewController.h"
@interface likeViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *group;
@property (nonatomic, strong) NSMutableArray *idArray;
@property (nonatomic, strong) NSMutableArray *allArray;
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation likeViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
//    [self bmob];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"喜欢";
    [self bmob];
    [self showWhiteBackBtn];
    self.edgesForExtendedLayout = UIRectEdgeNone;
}
- (void)workOne{
    for (NSString *str in self.group) {
        AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
        [manger GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//            WLZLog(@"%@",downloadProgress);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//            WLZLog(@"%@",responseObject);
            NSDictionary *rootDic = responseObject;
            [self.idArray addObject:rootDic[@"id"]];
            likeModel *model = [[likeModel alloc] initWithDictionary:rootDic];
            [self.allArray addObject:model];
            
            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            WLZLog(@"%@",error);
        }];
    }

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.allArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    likeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = self.allArray[indexPath.row];
//    cell.backgroundColor = kCollectionColor;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    specialViewController *spVC = [[specialViewController alloc] init];
    spVC.userId = self.idArray[indexPath.row];
    [self.navigationController pushViewController:spVC animated:YES];
}
- (void)bmob{
    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"like"];
  

    
//      if (user.username != nil) {
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([user.username isEqualToString:[obj objectForKey:@"userName"]]) {
                
                    [self.group addObject:[obj objectForKey:@"tavelLikeId"]];
                    [self.view addSubview:self.tableView];
                    self.tableView.backgroundColor = kCollectionColor;
                
            
            } else{
                [self.tableView removeFromSuperview];
                [self nilimage];
            }
            
            
        }
        
        [self workOne];

    }];
    
}
- (void)nilimage{
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, kWidth, kHeight-144)];
    imageView.image = [UIImage imageNamed:@"geren"];
    
    
    UILabel *lable = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight-144, kWidth, 44)];
    lable.text = @"sorry,您暂时还没有数据";
    lable.textAlignment = NSTextAlignmentCenter;
    
    [imageView addSubview:lable];
    
    [self.view addSubview:imageView];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight+44) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 120;
        [self.tableView registerNib:[UINib nibWithNibName:@"likeTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}
- (NSMutableArray *)idArray{
    if (_idArray == nil) {
        self.idArray = [NSMutableArray new];
    }
    return _idArray;
}
- (NSMutableArray *)group{
    if (_group == nil) {
        self.group = [NSMutableArray new];
    }
    return _group;
}
- (NSMutableArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSMutableArray new];
    }
    return _allArray;
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
