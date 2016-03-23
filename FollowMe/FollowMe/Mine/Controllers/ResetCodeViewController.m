//
//  ResetCodeViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ResetCodeViewController.h"
#import <BmobSDK/BmobUser.h>
#import "MineViewController.h"
@interface ResetCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *secondCode;
@property (weak, nonatomic) IBOutlet UIButton *sure;

@end

@implementation ResetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    self.sure.layer.cornerRadius = 20;
    self.sure.clipsToBounds = YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)sureAction:(id)sender {
    [BmobUser resetPasswordInbackgroundWithSMSCode:self.security andNewPassword:self.code.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
           // NSLog(@"%@",@"重置密码成功");
            [self.navigationController popToRootViewControllerAnimated:YES];

            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"密码已修改成功,请重新登录" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];

        } else {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
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
