//
//  SettingCodeViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/23.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SettingCodeViewController.h"
#import <BmobSDK/BmobUser.h>
@interface SettingCodeViewController ()
@property (weak, nonatomic) IBOutlet UITextField *usernametext;
@property (weak, nonatomic) IBOutlet UITextField *newcode;
@property (weak, nonatomic) IBOutlet UITextField *secondNewcode;

@end

@implementation SettingCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"修改密码";
    [self showBackBtn];
    self.usernametext.text = self.username;
    self.view.backgroundColor = kMainColor;
    [self shoeRightBtn];
    [self.usernametext resignFirstResponder];
    
    

    
}
- (void)collectionAction{
    BmobUser *user = [BmobUser getCurrentUser];
    
    [user updateCurrentUserPasswordWithOldPassword:self.secondNewcode.text newPassword:self.newcode.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            WLZLog(@"success");
        }
    }];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
    [self.usernametext resignFirstResponder];
    [self.newcode resignFirstResponder];
    [self.secondNewcode resignFirstResponder];
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
