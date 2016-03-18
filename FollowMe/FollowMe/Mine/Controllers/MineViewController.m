//
//  MineViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
@interface MineViewController ()

@property (weak, nonatomic) IBOutlet UIButton *emailBtn;

@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    self.phoneBtn.layer.cornerRadius = 20;
    self.phoneBtn.clipsToBounds = YES;
    self.emailBtn.layer.cornerRadius = 20;
    self.emailBtn.clipsToBounds = YES;
    self.emailBtn.layer.borderWidth = 2.0f;
    self.emailBtn.backgroundColor = kMainColor;
    self.emailBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.phoneBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    
}


- (IBAction)weixinLogin:(id)sender {
}


- (IBAction)xinlangLogin:(id)sender {
}


- (IBAction)qqLogin:(id)sender {
}

- (IBAction)phoneLogin:(id)sender {
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    

    LoginViewController *login = [mineStoryBoard instantiateViewControllerWithIdentifier:@"phone"];
    [self.navigationController presentViewController:login animated:YES completion:nil];
    
    
}
- (IBAction)emailLogin:(id)sender {
}
- (IBAction)forgetCode:(id)sender {
}
- (IBAction)resignAccount:(id)sender {
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
