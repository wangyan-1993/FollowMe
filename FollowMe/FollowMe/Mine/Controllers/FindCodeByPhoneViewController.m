//
//  FindCodeByPhoneViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FindCodeByPhoneViewController.h"
#import "ResetCodeViewController.h"
#import <BmobSDK/BmobSMS.h>
#import <BmobSDK/BmobUser.h>
@interface FindCodeByPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userphone;
@property (weak, nonatomic) IBOutlet UITextField *verifycode;
@property (weak, nonatomic) IBOutlet UIButton *getSecurity;
@property (weak, nonatomic) IBOutlet UIButton *getcode;

@end

@implementation FindCodeByPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = YES;

    self.getSecurity.layer.cornerRadius = 15;
    self.getSecurity.clipsToBounds = YES;
    [self.getSecurity setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getSecurity.backgroundColor = kMainColor;
    self.getcode.layer.cornerRadius = 20;
    self.getcode.clipsToBounds = YES;
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];

}
- (IBAction)getVerifycode:(id)sender {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.userphone.text andTemplate:@"" resultBlock:^(int number, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error]delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"短信验证码已发送成功,请注意查收" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];

}

- (IBAction)findAction:(id)sender {
    if (self.verifycode.text.length == 6) {
        UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        
        
        ResetCodeViewController *reset = [mineStoryBoard instantiateViewControllerWithIdentifier:@"reset"];
        reset.security = self.verifycode.text;
        [self presentViewController:reset animated:YES completion:nil];
    }else{
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请注意检查验证码,长度为6位" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
    }
   
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
    [self.userphone resignFirstResponder];
    [self.verifycode resignFirstResponder];
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
