//
//  MineViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/15.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "MineViewController.h"
#import "LoginViewController.h"
@interface MineViewController ()

@property(nonatomic, strong) UIButton *emailBtn;
@property(nonatomic, strong) UIButton *phoneBtn;

@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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


- (void)weixinlogin{
    
}
- (void)resign{
    
}
- (void)weibologin{
    
}
- (void)qqlogin{
    
}
- (void)phonelogin{
    UIStoryboard *mineStoryBoard = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    
    
    LoginViewController *login = [mineStoryBoard instantiateViewControllerWithIdentifier:@"phone"];
    [self.navigationController presentViewController:login animated:YES completion:nil];
}
- (void)emaillogin{
    
}

- (void)forget{
    
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
