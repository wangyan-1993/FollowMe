//
//  LoginViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "LoginViewController.h"
#import <BmobSDK/BmobUser.h>
#import "MineViewController.h"
#import "InformationViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *login;
@property (weak, nonatomic) IBOutlet UITextField *phonenum;
@property (weak, nonatomic) IBOutlet UITextField *code;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;
    self.view.backgroundColor = kMainColor;
    self.login.layer.cornerRadius = 20;
    self.login.clipsToBounds = YES;
    self.login.layer.borderWidth = 2.0f;
    self.login.backgroundColor = kMainColor;
    self.login.layer.borderColor = [[UIColor whiteColor]CGColor];
    }
- (IBAction)backBtn:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginAction:(id)sender {
    [BmobUser loginInbackgroundWithAccount:self.phonenum.text andPassword:self.code.text block:^(BmobUser *user, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error]delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            InformationViewController *info = [[InformationViewController alloc]init];
            info.username = self.phonenum.text;
            [self.navigationController pushViewController:info animated:YES];
        }
    }];
    
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
   // self.phonenum
    [self.view resignFirstResponder];
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
