//
//  UserPhoneViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UserPhoneViewController.h"
#import <BmobSDK/BmobSMS.h>
#import <BmobSDK/BmobUser.h>
@interface UserPhoneViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userphone;
@property (weak, nonatomic) IBOutlet UITextField *verifyCode;
@property (weak, nonatomic) IBOutlet UIButton *getCode;

@end

@implementation UserPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"绑定手机号";
    [self shoeRightBtn];
    self.getCode.layer.cornerRadius = 10;
    self.getCode.clipsToBounds = YES;
    [self.getCode setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getCode.backgroundColor = kMainColor;
    self.view.backgroundColor = [UIColor colorWithRed:252/256.0f green:244/256.0f blue:230/256.0f alpha:1.0];

}
- (void)collectionAction{
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.userphone.text andSMSCode:self.verifyCode.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            //修改绑定手机
            BmobUser *buser = [BmobUser getCurrentUser];
            buser.mobilePhoneNumber = self.userphone.text;
            
            [buser setObject:[NSNumber numberWithBool:YES] forKey:@"mobilePhoneNumberVerified"];
            [buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    NSLog(@"%@",buser);
                    [self.navigationController popViewControllerAnimated:YES];
                } else {
                
               
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"%@", error] preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alert addAction:action1];
            UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
            [alert addAction:action2];
            [self presentViewController:alert animated:YES completion:nil];

                }
            }];
            
            
        } else {
            NSLog(@"%@",error);
        }
    }];
}
- (IBAction)getVerify:(id)sender {
    
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.userphone.text andTemplate:@"" resultBlock:^(int number, NSError *error) {
        if (error) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error]delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }else{
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"短信验证码已发送成功,请注意查收" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
        }
    }];

    
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
