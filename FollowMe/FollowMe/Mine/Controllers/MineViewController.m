//
//  MineViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "EmailLoginViewController.h"
#import "EmailVerifyViewController.h"
#import "FindCodeByPhoneViewController.h"
#import "ResignViewController.h"
#import "WeiboSDK.h"
@interface MineViewController ()

@property(nonatomic, strong) UIButton *emailBtn;
@property(nonatomic, strong) UIButton *phoneBtn;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"我的";
    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(kWidth*0.2, kHeight*0.13, kWidth*0.58, kHeight*0.08)];
    title.text = @"你好,面粉!";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:36];
    title.textColor = [UIColor whiteColor];
    [self.view addSubview:title];
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.132, kHeight*0.27, kWidth*0.16, kWidth*0.16)];
    image1.image = [UIImage imageNamed:@"weixin"];
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn1.frame = CGRectMake(kWidth*0.112, kHeight*0.27, kWidth*0.2, kWidth*0.24);
    [btn1 setTitle:@"微信登陆" forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
    btn1.titleEdgeInsets = UIEdgeInsetsMake(kWidth*0.16, 0, 0, 0);
    [btn1 addTarget:self action:@selector(weixinlogin) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn1];
    [self.view addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.43, kHeight*0.27, kWidth*0.16, kWidth*0.16)];
    image2.image = [UIImage imageNamed:@"weibo"];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(kWidth*0.41, kHeight*0.27, kWidth*0.2, kWidth*0.24);
    [btn2 setTitle:@"微博登陆" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.titleEdgeInsets = UIEdgeInsetsMake(kWidth*0.16, 0, 0, 0);
    [btn2 addTarget:self action:@selector(weibologin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn2];
    [self.view addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.76, kHeight*0.27, kWidth*0.16, kWidth*0.16)];
    image3.image = [UIImage imageNamed:@"qq"];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(kWidth*0.74, kHeight*0.27, kWidth*0.2, kWidth*0.24);
    [btn3 setTitle:@"QQ登陆" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    btn3.titleEdgeInsets = UIEdgeInsetsMake(kWidth*0.16, 0, 0, 0);
    [btn3 addTarget:self action:@selector(qqlogin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn3];
    [self.view addSubview:image3];
    if (kWidth < 375) {
        btn1.titleLabel.font = [UIFont systemFontOfSize:13];
        btn2.titleLabel.font = [UIFont systemFontOfSize:13];

        btn3.titleLabel.font = [UIFont systemFontOfSize:13];
        
    }
    UILabel *title1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0.45*kHeight, kWidth, kHeight*0.057)];
    title1.text = @"————使用面包账号登录————";
    title1.textAlignment = NSTextAlignmentCenter;
    title1.font = [UIFont systemFontOfSize:16];
    title1.textColor = [UIColor darkGrayColor];
    title1.alpha = 0.8;
    [self.view addSubview:title1];
    self.phoneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.phoneBtn.frame = CGRectMake(kWidth*0.19, kHeight*0.546, kWidth*0.605, kHeight*0.057);
    [self.phoneBtn setTitle:@"使用手机号登陆" forState:UIControlStateNormal];
    self.emailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    if (kWidth < 375) {
        self.emailBtn.titleLabel.font =[UIFont systemFontOfSize:15];
    }
    self.emailBtn.frame = CGRectMake(kWidth*0.19, kHeight*0.64, kWidth*0.605, kHeight*0.057);
    [self.emailBtn setTitle:@"使用面包账号或邮箱登陆" forState:UIControlStateNormal];
    self.phoneBtn.backgroundColor = [UIColor whiteColor];
    self.view.backgroundColor = kMainColor;
    self.phoneBtn.layer.cornerRadius = 20;
    self.phoneBtn.clipsToBounds = YES;
    self.emailBtn.layer.cornerRadius = 20;
    self.emailBtn.clipsToBounds = YES;
    self.emailBtn.layer.borderWidth = 2.0f;
    self.emailBtn.backgroundColor = kMainColor;
    self.emailBtn.layer.borderColor = [[UIColor whiteColor]CGColor];
    [self.phoneBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.phoneBtn addTarget:self action:@selector(phonelogin) forControlEvents:UIControlEventTouchUpInside];
    [self.emailBtn addTarget:self action:@selector(emaillogin) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:self.phoneBtn];
    [self.view addSubview:self.emailBtn];
    UIButton *btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn4.frame = CGRectMake(0.03*kWidth, 0.75*kHeight, kWidth*0.365, 0.063*kHeight);
    [btn4 setTitle:@"忘记密码" forState:UIControlStateNormal];
    [btn4 addTarget:self action:@selector(forget) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn4];
    UIButton *btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn5.frame = CGRectMake(kWidth*0.605, 0.75*kHeight, kWidth*0.365, 0.063*kHeight);
    [btn5 setTitle:@"注册账号" forState:UIControlStateNormal];
    [btn5 addTarget:self action:@selector(resign) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn5];

    
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)weixinlogin{
    
}

- (void)weibologin{
        //向新浪发送请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kWeiboRedirectURI;
        request.scope = @"all";
    
        [WeiboSDK sendRequest:request];
    
    
}
- (void)qqlogin{
    
}
- (void)phonelogin{
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    
    LoginViewController *login = [mineStoryBoard instantiateViewControllerWithIdentifier:@"phone"];
   login.navigationItem.hidesBackButton = YES;

    [self.navigationController pushViewController:login animated:YES];
}
- (void)emaillogin{
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    
    EmailLoginViewController *emaillogin = [mineStoryBoard instantiateViewControllerWithIdentifier:@"emaillogin"];
    emaillogin.navigationItem.hidesBackButton = YES;

    [self.navigationController pushViewController:emaillogin animated:YES];
}

- (void)forget{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"通过手机号找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        FindCodeByPhoneViewController *findcode = [mineStoryBoard instantiateViewControllerWithIdentifier:@"findbyphone"];
        findcode.navigationItem.hidesBackButton = YES;

        [self.navigationController pushViewController:findcode animated:YES];
        
        
    }];
    [alert addAction:action2];
    
    
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"通过用户名或邮箱找回" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
        
        
        EmailVerifyViewController *emailverify = [mineStoryBoard instantiateViewControllerWithIdentifier:@"emailverify"];
        emailverify.navigationItem.hidesBackButton = YES;

        [self.navigationController pushViewController:emailverify animated:YES];
    }];
    [alert addAction:action3];
    [self presentViewController:alert animated:YES completion:nil];
    
}
- (void)resign{
    
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    
    ResignViewController *resign = [mineStoryBoard instantiateViewControllerWithIdentifier:@"resign"];
   resign.navigationItem.hidesBackButton = YES;

    [self.navigationController presentViewController:resign animated:YES completion:nil];
    
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
