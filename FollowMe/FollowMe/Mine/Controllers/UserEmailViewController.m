//
//  UserEmailViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UserEmailViewController.h"
#import <BmobSDK/BmobUser.h>
@interface UserEmailViewController ()
@property (weak, nonatomic) IBOutlet UITextField *emailText;

@end

@implementation UserEmailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self shoeRightBtn];
    [self showBackBtn];
    self.title = @"绑定邮箱";
    self.view.backgroundColor = [UIColor colorWithRed:252/256.0f green:244/256.0f blue:230/256.0f alpha:1.0];
}
- (void)collectionAction{
    BmobUser *user = [BmobUser getCurrentUser];
    //应用开启了邮箱验证功能
//    if ([user objectForKey:@"emailVerified"]) {
//        //用户没验证过邮箱
//        if (![[user objectForKey:@"emailVerified"] boolValue]) {
            [user verifyEmailInBackgroundWithEmailAddress:self.emailText.text];
            [BmobUser getCurrentUser].email = self.emailText.text;
            
            [self.navigationController popViewControllerAnimated:YES];

//        }
//    }
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
