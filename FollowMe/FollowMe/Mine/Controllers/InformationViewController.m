//
//  InformationViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.



#import "InformationViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "BecomeHunterViewController.h"
#import "SettingsViewController.h"
#import "UserInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobQuery.h>

@interface InformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSArray *titleArray;
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BmobUser *user = [BmobUser getCurrentUser];
    self.imageArray = [user objectForKey:@"array"];
    self.titleArray = [user objectForKey:@"titlwArray"];
    
    
    [self.view addSubview:self.tableView];
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                self.username = [obj objectForKey:@"name"];
                 [self addheaderView];
                [self.tableView reloadData];
            }
        }
    }];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                self.username = [obj objectForKey:@"name"];

                [self addheaderView];
                [self.tableView reloadData];
            }
        }
    }];


}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return self.titleArray.count;
   }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"123";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    //[cell.imageView sd_setImageWithURL:self.imageArray[indexPath.row][0]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.textLabel.numberOfLines = 0;
        return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        NSString *str =self.titleArray[indexPath.row];
       CGRect textRect = [str boundingRectWithSize:CGSizeMake(kWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}  context:nil];
        return textRect.size.height;
    }
    return kWidth;
}

- (void)addheaderView{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*0.8+20)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:header.frame];
    imageview.image = [UIImage imageNamed:@"200"];
    [header addSubview:imageview];
    UIImageView *black = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*0.8)];
    black.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0
 alpha:0.3];
    [header addSubview:black];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(kWidth-50, 15, 30, 30);
    [settingBtn setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:settingBtn];
    UIImageView *imageviewHeader = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3, kWidth/6, kWidth/3, kWidth/3)];
    imageviewHeader.layer.cornerRadius = kWidth/3/2;
    imageviewHeader.clipsToBounds = YES;
  //  WLZLog(@"%@", self.headerImage);
        [imageviewHeader sd_setImageWithURL:[NSURL URLWithString:self.headerImage] placeholderImage:[UIImage imageNamed:@"123456"]];
        
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = imageviewHeader.frame;
    [headerBtn addTarget:self action:@selector(headerInformation) forControlEvents:UIControlEventTouchUpInside];
    
    // UIImageView默认不允许用户交互，headerBtn不能直接加载到其上面，如果需要把btn加载到它上面，需要打开UIImageView的交互
    //打开交互     imageView.userInteractionEnabled = YES;
    
    [header addSubview:headerBtn];
    [header addSubview:imageviewHeader];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth/2+10, kWidth, 20)];
    label.textAlignment = NSTextAlignmentCenter;
   
    label.text = self.username;
    label.textColor = [UIColor whiteColor];
    [header addSubview:label];
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    messageBtn.frame = CGRectMake(kWidth/6, kWidth/2+40, kWidth/3-10, 30);
    [messageBtn setTitle:@"消息" forState:UIControlStateNormal];
    messageBtn.layer.cornerRadius = 15.0;
    messageBtn.clipsToBounds = YES;
    messageBtn.backgroundColor = [UIColor whiteColor];
    [messageBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [messageBtn addTarget:self action:@selector(message) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:messageBtn];
    
    UIButton *orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    orderBtn.frame = CGRectMake(kWidth/2+10, kWidth/2+40, kWidth/3-10, 30);
    orderBtn.backgroundColor = [UIColor whiteColor];
    [orderBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    orderBtn.layer.cornerRadius = 15.0;
    orderBtn.clipsToBounds = YES;
    [orderBtn setTitle:@"订单" forState:UIControlStateNormal];
    [orderBtn addTarget:self action:@selector(order) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:orderBtn];
    
    UIButton *moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    moneyBtn.frame = CGRectMake(kWidth/2-100, kWidth/2 + 75, 200, 20);
    [moneyBtn setTitle:@"👛 我的钱包 >" forState:UIControlStateNormal];
    [moneyBtn addTarget:self action:@selector(moneyAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:moneyBtn];
    UILabel *diaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth*0.8, kWidth, 20)];
    diaryLabel.text = @"生活点滴";
    diaryLabel.textAlignment = NSTextAlignmentCenter;
    diaryLabel.textColor = kMainColor;
    [header addSubview:diaryLabel];
    self.tableView.tableHeaderView = header;
    
}




- (void)settingsAction{
    SettingsViewController *settingVC = [[SettingsViewController alloc]init];
    settingVC.imageStr = self.headerImage;
    settingVC.username = self.username;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)headerInformation{
    UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
    userinfo.urlImage = self.headerImage;
    [self.navigationController pushViewController:userinfo animated:YES];
}
- (void)message{
    
}

- (void)order{
    
}
- (void)moneyAction{
    
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = kWidth;
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
