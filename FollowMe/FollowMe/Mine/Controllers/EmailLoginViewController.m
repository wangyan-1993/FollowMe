//
//  EmailLoginViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "EmailLoginViewController.h"
#import <BmobSDK/BmobUser.h>
@interface EmailLoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation EmailLoginViewController

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
- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)loginAction:(id)sender {
    [BmobUser loginInbackgroundWithAccount:self.username.text andPassword:self.code.text block:^(BmobUser *user, NSError *error) {
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
