//
//  UIViewController+Common.m
//  FollowMe
//
//  Created by SCJY on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UIViewController+Common.h"

@implementation UIViewController (Common)
- (void)showBackBtn{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 44, 44);
    [backBtn setImage:[UIImage imageNamed:@"back.png"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
}
- (void)shoeRightBtn{
    UIButton *collectionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    collectionBtn.frame = CGRectMake(0, 0, 60, 44);
    [collectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [collectionBtn setTitle:@"保存" forState:UIControlStateNormal];
    [collectionBtn addTarget:self action:@selector(collectionAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithCustomView:collectionBtn];
    self.navigationItem.rightBarButtonItem = right;
}

- (void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
