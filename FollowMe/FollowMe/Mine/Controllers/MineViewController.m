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
#import "WXApi.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobObject.h>
#import "InformationViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobUser.h>
#import "InformationViewController.h"
@interface MineViewController ()<TencentLoginDelegate, TencentSessionDelegate>

@property(nonatomic, strong) UIButton *emailBtn;
@property(nonatomic, strong) UIButton *phoneBtn;
@property(nonatomic, strong)TencentOAuth *tencentOAuth;

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
//    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.132, kHeight*0.27, kWidth*0.16, kWidth*0.16)];
//    image1.image = [UIImage imageNamed:@"weixin"];
//    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
//    btn1.frame = CGRectMake(kWidth*0.112, kHeight*0.27, kWidth*0.2, kWidth*0.24);
//    [btn1 setTitle:@"微信登陆" forState:UIControlStateNormal];
//    btn1.titleLabel.font = [UIFont systemFontOfSize:15];
//    btn1.titleEdgeInsets = UIEdgeInsetsMake(kWidth*0.16, 0, 0, 0);
//    [btn1 addTarget:self action:@selector(weixinlogin) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn1];
//    [self.view addSubview:image1];
    UIImageView *image2 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.27, kHeight*0.27, kWidth*0.16, kWidth*0.16)];
    image2.image = [UIImage imageNamed:@"weibo"];
    UIButton *btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn2.frame = CGRectMake(kWidth*0.25, kHeight*0.27, kWidth*0.2, kWidth*0.24);
    [btn2 setTitle:@"微博登陆" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:15];
    btn2.titleEdgeInsets = UIEdgeInsetsMake(kWidth*0.16, 0, 0, 0);
    [btn2 addTarget:self action:@selector(weibologin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn2];
    [self.view addSubview:image2];
    UIImageView *image3 = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth*0.61, kHeight*0.27, kWidth*0.16, kWidth*0.16)];
    image3.image = [UIImage imageNamed:@"qq"];
    UIButton *btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn3.frame = CGRectMake(kWidth*0.59, kHeight*0.27, kWidth*0.2, kWidth*0.24);
    [btn3 setTitle:@"QQ登陆" forState:UIControlStateNormal];
    btn3.titleLabel.font = [UIFont systemFontOfSize:15];
    btn3.titleEdgeInsets = UIEdgeInsetsMake(kWidth*0.16, 0, 0, 0);
    [btn3 addTarget:self action:@selector(qqlogin) forControlEvents:UIControlEventTouchUpInside];

    [self.view addSubview:btn3];
    [self.view addSubview:image3];
    if (kWidth < 375) {
        //btn1.titleLabel.font = [UIFont systemFontOfSize:13];
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

    self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:kQQAppID andDelegate:self];
 self.tencentOAuth.redirectURI = @"www.qq.com";
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([BmobUser getCurrentUser]) {
        [BmobUser loginInbackgroundWithAccount:[BmobUser getCurrentUser].username andPassword:[BmobUser getCurrentUser].username block:^(BmobUser *user, NSError *error) {
            InformationViewController *info = [[InformationViewController alloc]init];
            info.username = [BmobUser getCurrentUser].username;
            [self.navigationController pushViewController:info animated:YES];
            BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for (BmobObject *obj in array) {
                    if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
                    {
                        return ;
                    }
                }
                BmobObject *object = [BmobObject objectWithClassName:@"info"];
                [object setObject:[BmobUser getCurrentUser].username forKey:@"user"];
                [object saveInBackground];
            }];

        }];
    }
    self.navigationController.navigationBar.hidden = NO;
    self.tabBarController.tabBar.hidden = NO;
}

- (void)weixinlogin{
    SendAuthReq* req =[[SendAuthReq alloc]init];
    req.scope = @"all" ;
    req.state = @"123" ;
    //第三方向微信终端发送一个SendAuthReq消息结构
    [WXApi sendReq:req];
}

- (void)weibologin{
        //向新浪发送请求
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kWeiboRedirectURI;
        request.scope = @"all";
    
        [WeiboSDK sendRequest:request];
    
    
}
- (void)qqlogin{
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
                            kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                            kOPEN_PERMISSION_ADD_ALBUM,
                            kOPEN_PERMISSION_ADD_ONE_BLOG,
                            kOPEN_PERMISSION_ADD_SHARE,
                            kOPEN_PERMISSION_ADD_TOPIC,
                            kOPEN_PERMISSION_CHECK_PAGE_FANS,
                            kOPEN_PERMISSION_GET_INFO,
                            kOPEN_PERMISSION_GET_OTHER_INFO,
                            kOPEN_PERMISSION_LIST_ALBUM,
                            kOPEN_PERMISSION_UPLOAD_PIC,
                            kOPEN_PERMISSION_GET_VIP_INFO,
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    
    
[self.tencentOAuth authorize:permissions inSafari:NO];
  
   

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



#pragma mark---腾讯代理
- (void)tencentDidLogin{
    
if (self.tencentOAuth.accessToken && 0 != [self.tencentOAuth.accessToken length])
{
        
        WLZLog(@"登陆成功");
        NSDictionary *responseDictionary = @{@"access_token": self.tencentOAuth.accessToken,@"uid":self.tencentOAuth.openId,@"expirationDate":self.tencentOAuth.expirationDate};
        WLZLog(@"%@", self.tencentOAuth.passData);
        AFHTTPSessionManager *manager=[AFHTTPSessionManager manager];
        manager.responseSerializer.acceptableContentTypes=[NSSet setWithObject:@"text/html"];
        
        [manager GET:[NSString stringWithFormat:@"https://graph.qq.com/user/get_user_info?access_token=%@&oauth_consumer_key=%@&openid=%@",self.tencentOAuth.accessToken,self.tencentOAuth.appId,self.tencentOAuth.openId] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            NSLog(@"%lld",downloadProgress.totalUnitCount);
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSLog(@"%@",responseObject);
           
            
            
            
           
            
            
            [BmobUser loginInBackgroundWithAuthorDictionary:responseDictionary platform:BmobSNSPlatformQQ block:^(BmobUser *user, NSError *error) {
                if (user) {
                    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
                    [userDef setValue:@"qq" forKey:@"switch2"];

                    InformationViewController *info = [[InformationViewController alloc]init];
                    info.username = responseObject[@"nickname"];
                    info.headerImage = responseObject[@"figureurl_qq_2"];
                    self.tabBarController.selectedIndex = 0;
                    [self.navigationController pushViewController:info animated:NO];
                }else{
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户登录失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
                    [alert show];
                }
            }];
            BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                for (BmobObject *obj in array) {
                    if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]]) {
                        return ;
                    }
                }
                
                BmobObject *object = [BmobObject objectWithClassName:@"info"];
                [object setObject:[BmobUser getCurrentUser].username forKey:@"user"];
                [object setObject:responseObject[@"nickname"] forKey:@"name"];
                [object setObject:responseObject[@"city"] forKey:@"city"];
                [object setObject:responseObject[@"year"] forKey:@"year"];
                [object setObject:responseObject[@"figureurl_qq_2"] forKey:@"image"];
                [object setObject:responseObject[@"gender"] forKey:@"gender"];
                [object saveInBackground];
                
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"%@",error);
        }];
}
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"用户登录失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
  
    }
    
    
    
}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    if (cancelled)
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您已取消登录" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"登录失败" delegate:self cancelButtonTitle:@"我知道了" otherButtonTitles: nil];
        [alert show];
    }
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    
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
