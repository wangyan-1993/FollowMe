//
//  ResignViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ResignViewController.h"

@interface ResignViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phonenum;
@property (weak, nonatomic) IBOutlet UITextField *verifycode;
@property (weak, nonatomic) IBOutlet UITextField *logincode;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation ResignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    self.loginBtn.layer.cornerRadius = 20.0f;
    self.loginBtn.clipsToBounds = YES;
    self.loginBtn.layer.borderWidth = 2.0f;
    self.loginBtn.backgroundColor = kMainColor;
    self.loginBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    self.verifyBtn.layer.cornerRadius = 15.0f;
    self.verifyBtn.clipsToBounds = YES;
    [self.verifyBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    

    
    
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)verifyAction:(id)sender {
}
- (IBAction)loginAction:(id)sender {
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
