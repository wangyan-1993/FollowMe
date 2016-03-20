//
//  NoCodeLoginViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "NoCodeLoginViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobSMS.h>
@interface NoCodeLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *get;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *phonenum;
@property (weak, nonatomic) IBOutlet UITextField *security;

@end

@implementation NoCodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    self.view.backgroundColor = kMainColor;
    self.loginBtn.layer.cornerRadius = 20;
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.layer.borderWidth = 2.0f;
    self.loginBtn.backgroundColor = kMainColor;
    
    self.loginBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.get.layer.cornerRadius = 15;
    self.get.clipsToBounds = YES;
    [self.get setTitleColor:kMainColor forState:UIControlStateNormal];
    
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}

- (IBAction)getSecurity:(id)sender {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phonenum.text andTemplate:@"" resultBlock:^(int number, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error]delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"短信验证码已发送成功,请注意查收" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];

    
}


- (IBAction)login:(id)sender {
    [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:self.phonenum.text andSMSCode:self.security.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error]delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            
        }

    }];
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
