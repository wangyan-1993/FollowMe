//
//  UserSignatureViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UserSignatureViewController.h"

@interface UserSignatureViewController ()
@property(nonatomic, strong) UITextField *textField;
@end

@implementation UserSignatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个性签名";
    [self shoeRightBtn];
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithRed:252/256.0f green:244/256.0f blue:230/256.0f alpha:1.0];

    self.textField = [[UITextField alloc]initWithFrame:CGRectMake(5, 100, kWidth-10, 50)];
    self.textField.placeholder = @"请输入个性签名";
    [self.view addSubview:self.textField];
    
}
- (void)collectionAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"change" object:nil userInfo:@{@"personal": self.textField.text}];
   
    

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
