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
//    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    collectionBtn.frame = CGRectMake(0, 0, 60, 44);
//    [collectionBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [collectionBtn setTitle:@"保存" forState:UIControlStateNormal];
//    [collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
//    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:collectionBtn];
//    self.navigationItem.rightBarButtonItem = right;
    [self shoeRightBtn];
    [self.usernametext resignFirstResponder];
    
    

    
}
- (void)collectionAction{
    //if ([self.newcode isEqual:self.secondNewcode] ) {
        BmobUser *user = [BmobUser getCurrentUser];
      //  [user setPassword:self.newcode.text];
    
    [user updateCurrentUserPasswordWithOldPassword:@"" newPassword:self.newcode.text block:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            WLZLog(@"success");
        }
    }];
    
    
    //}
    
  }

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view resignFirstResponder];
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