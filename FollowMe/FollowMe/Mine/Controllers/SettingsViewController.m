//
//  SettingsViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SettingsViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserInfoViewController.h"
#import "SettingCodeViewController.h"
@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *allArray;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = YES;
    self.title = @"设置";
    self.view.backgroundColor = kMainColor;
    [self showBackBtn];
    [self addRightBtn];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除缓存(%.2fM)", (CGFloat)cacheSize / 1024 / 1024];
    
   
    self.allArray = @[@[self.username],@[@"添加朋友",@"修改账户密码",@"推送通知设置",@"连接社交网络",cacheStr,@"关于我们",@"喜欢我吗？给个评分吧",@"意见反馈"]];
    [self.view addSubview:self.tableView];
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                self.username = [obj objectForKey:@"name"];
                [self.tableView reloadData];
            }
        }
    }];

}
- (void)addRightBtn{
    UIButton *right = [UIButton buttonWithType:UIButtonTypeCustom];
    right.frame = CGRectMake(0, 0, 44, 44);
    [right setTitle:@"退出" forState:UIControlStateNormal];
    [right setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [right addTarget:self action:@selector(logout) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarBtn = [[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.rightBarButtonItem = rightBarBtn;
}

- (void)logout{
    [BmobUser logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *array = self.allArray[section];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    if (indexPath.section == 0) {
        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"123456"]];
        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
        cell.imageView.clipsToBounds = YES;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.allArray[indexPath.section][indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section== 0) {
        UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
        userinfo.urlImage = self.imageStr;
        userinfo.username = self.username;
        WLZLog(@"%@", userinfo.username);
        [self.navigationController pushViewController:userinfo animated:YES];
    }
    
    if (indexPath.section == 1) {
        
        //修改账户密码
        if (indexPath.row == 1) {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            SettingCodeViewController *setcode = [main instantiateViewControllerWithIdentifier:@"settingcode"];
            setcode.username = self.username;
            [self.navigationController pushViewController:setcode animated:YES];
            
        }
        //清除缓存
        if (indexPath.row == 4) {
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            self.allArray = @[@[self.username],@[@"添加朋友",@"修改账户密码",@"推送通知设置",@"连接社交网络",@"清除缓存",@"关于我们",@"喜欢我吗？给个评分吧",@"意见反馈"]];
            [self.tableView reloadData];

        }
        //关于我们
        if (indexPath.row == 5) {
            NSString *str = @"itms-apps://itunes.apple.com";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        }
        
    }
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.allArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 100;
    }
    return 50;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kWidth, kHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (NSArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSArray new];
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
