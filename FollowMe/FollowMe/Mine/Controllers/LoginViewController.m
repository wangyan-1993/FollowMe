//
//  LoginViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *login;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    self.login.layer.cornerRadius = 20;
    self.login.clipsToBounds = YES;
    self.login.layer.borderWidth = 2.0f;
    self.login.backgroundColor = kMainColor;
    self.login.layer.borderColor = [[UIColor whiteColor]CGColor];
    }
- (IBAction)backBtn:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
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
