//
//  UsernameViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/23.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UsernameViewController.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobObject.h>
@interface UsernameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;

@property (weak, nonatomic) IBOutlet UITextField *newusername;
@property (weak, nonatomic) IBOutlet UITextField *currentusername;


@end

@implementation UsernameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"修改用户名";
    [self shoeRightBtn];
    [self.currentusername resignFirstResponder];
    self.view.backgroundColor = [UIColor colorWithRed:252/256.0f green:244/256.0f blue:230/256.0f alpha:1.0];

    
}
- (void)collectionAction{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"change" object:nil userInfo:@{@"name":self.newusername.text}];
    
    [self.navigationController popViewControllerAnimated:YES];

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
