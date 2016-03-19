//
//  FindCodeByPhoneViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FindCodeByPhoneViewController.h"
#import "ResetCodeViewController.h"
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
    self.getSecurity.layer.cornerRadius = 15;
    self.getSecurity.clipsToBounds = YES;
    [self.getSecurity setTitleColor:kMainColor forState:UIControlStateNormal];
    self.getcode.layer.cornerRadius = 20;
    self.getcode.clipsToBounds = YES;
}
- (IBAction)back:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];

}
- (IBAction)getVerifycode:(id)sender {
}

- (IBAction)findAction:(id)sender {
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    
    ResetCodeViewController *reset = [mineStoryBoard instantiateViewControllerWithIdentifier:@"reset"];
    [self presentViewController:reset animated:YES completion:nil];
    
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
