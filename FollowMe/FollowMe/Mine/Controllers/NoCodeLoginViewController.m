//
//  NoCodeLoginViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "NoCodeLoginViewController.h"

@interface NoCodeLoginViewController ()
@property (weak, nonatomic) IBOutlet UIButton *get;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation NoCodeLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
    [self dismissViewControllerAnimated:YES completion:nil];

}

- (IBAction)getSecurity:(id)sender {
}


- (IBAction)login:(id)sender {
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
