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
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "LinkViewController.h"
static NSString *cacheStr;
@interface SettingsViewController ()<UITableViewDataSource, UITableViewDelegate, UIWebViewDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate>
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
    //self.view.backgroundColor = kMainColor;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self showBackBtn];
    [self addRightBtn];
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    cacheStr = [NSString stringWithFormat:@"清除缓存(%.2fM)", (CGFloat)cacheSize / 1024 / 1024];
  
    

    [self.view addSubview:self.tableView];
//    self.allArray = @[@[self.username],@[@"添加朋友",@"修改账户密码",@"连接社交网络",cacheStr,@"喜欢我吗？给个评分吧",@"意见反馈"]];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                self.username = [obj objectForKey:@"name"];
                self.allArray = @[@[@"个人基本信息"],@[@"添加朋友",@"修改账户密码",@"连接社交网络",cacheStr,@"喜欢我吗？给个评分吧",@"意见反馈",@"我的收藏"]];
                [self.tableView reloadData];
                
            }
        }
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
}
- (void)logout{
    [BmobUser logout];
    [self.navigationController popToRootViewControllerAnimated:YES];
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
//    if (indexPath.section == 0) {
//        
////        [cell.imageView sd_setImageWithURL:[NSURL URLWithString:self.imageStr] placeholderImage:[UIImage imageNamed:@"123456"]];
//        
////        cell.imageView.layer.cornerRadius = cell.imageView.frame.size.width/2;
////        cell.imageView.clipsToBounds = YES;
//
//    }
    cell.textLabel.text = self.allArray[indexPath.section][indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
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
        
        if (indexPath.row == 0) {
            [self sendMessage];
        }
        
        //修改账户密码
        if (indexPath.row == 1) {
            UIStoryboard *main = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            SettingCodeViewController *setcode = [main instantiateViewControllerWithIdentifier:@"settingcode"];
            setcode.username = self.username;
            [self.navigationController pushViewController:setcode animated:YES];
            
        }
        //添加社交网络
        if (indexPath.row == 2) {
             UIStoryboard *main = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
            LinkViewController *link = [main instantiateViewControllerWithIdentifier:@"link"];
            [self.navigationController pushViewController:link animated:YES];
        }
        
        //清除缓存
        if (indexPath.row == 3) {
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            
            self.allArray = @[@[self.username],@[@"添加朋友",@"修改账户密码",@"连接社交网络",@"清除缓存",@"喜欢我吗？给个评分吧",@"意见反馈",@"我的收藏"]];
            [self.tableView reloadData];

        }
        //关于我们
        if (indexPath.row == 4) {
            NSString *str = @"itms-apps://itunes.apple.com";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];

        }
        //意见反馈
        if (indexPath.row == 5) {
            [self sendEmail];
            
        }
        //我的收藏
        if (indexPath.row == 6) {
            
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
- (void)sendMessage{
    if( [MFMessageComposeViewController canSendText] ){
        
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc]init];
        
        controller.body = @"珍惜身边最美的风景，给自己一次说走就走的旅行,FollowMe,https://itunes.apple.com";
        controller.messageComposeDelegate = self;
        
        [self presentViewController:controller animated:YES completion:nil];
        
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:@"FollowMe"];//修改短信界面标题
    }else{
                [self alertWithTitle:@"提示信息" msg:@"设备没有短信功能"];
        
    }
}
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result{
    
    [controller dismissViewControllerAnimated:NO completion:nil];//关键的一句   不能为YES
    
    switch ( result ) {
            
        case MessageComposeResultCancelled:
            
            [self alertWithTitle:@"提示信息" msg:@"发送取消"];
            break;
        case MessageComposeResultFailed:// send failed
            [self alertWithTitle:@"提示信息" msg:@"发送成功"];
            break;
        case MessageComposeResultSent:
            [self alertWithTitle:@"提示信息" msg:@"发送失败"];
            break;
        default:
            break;
    }
}


- (void) alertWithTitle:(NSString *)title msg:(NSString *)msg {
    
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"确定", nil];
    
    [alert show];  
    
}
- (void)sendEmail{
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    // 设置邮件主题
    [mailCompose setSubject:@"我是邮件主题"];
    // 设置收件人
    [mailCompose setToRecipients:@[@"843668546@qq.com"]];
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"我是邮件内容";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    [self presentViewController:mailCompose animated:YES completion:nil];
}

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
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
