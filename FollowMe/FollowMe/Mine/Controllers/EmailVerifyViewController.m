//
//  EmailVerifyViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "EmailVerifyViewController.h"
#import <BmobSDK/BmobUser.h>
@interface EmailVerifyViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UIButton *findCode;

@end

@implementation EmailVerifyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.findCode.layer.cornerRadius = 20;
    self.findCode.clipsToBounds = YES;
    self.navigationController.navigationBar.hidden = YES;self.tabBarController.tabBar.hidden = YES;
    
}
- (IBAction)findcodeAction:(id)sender {
    
    [BmobUser requestPasswordResetInBackgroundWithEmail:self.username.text];
}
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
    [self.username resignFirstResponder];
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
