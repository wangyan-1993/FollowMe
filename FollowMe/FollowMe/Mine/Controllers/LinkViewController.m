//
//  LinkViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/28.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "LinkViewController.h"
#import "WeiboSDK.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/TencentOAuthObject.h>
#import <TencentOpenAPI/TencentApiInterface.h>
#import "AppDelegate.h"
@interface LinkViewController ()<TencentLoginDelegate, TencentSessionDelegate, WBHttpRequestDelegate>

@property (weak, nonatomic) IBOutlet UISwitch *weiboSwitch;


@property (weak, nonatomic) IBOutlet UISwitch *QQSwitch;
@property(nonatomic, strong)TencentOAuth *tencentOAuth;
@property (weak, nonatomic) IBOutlet UIImageView *image1;
@property (weak, nonatomic) IBOutlet UIImageView *image2;

@end

@implementation LinkViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:kQQAppID andDelegate:self];
    self.tencentOAuth.redirectURI = @"www.qq.com";
//    self.image1.layer.cornerRadius = 25;
//    self.image1.clipsToBounds = YES;
    self.image1.layer.borderWidth = 2.0;
    self.image1.layer.borderColor = [[UIColor whiteColor]CGColor];
//    self.image2.layer.cornerRadius = 25;
//    self.image2.clipsToBounds = YES;
    self.image2.layer.borderWidth = 2.0;
    self.image2.layer.borderColor = [[UIColor whiteColor]CGColor];

    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"switch1"] isEqualToString:@"weibo"]) {
        self.weiboSwitch.on = YES;
    }else{
        self.weiboSwitch.on = NO;

    }
    
    if ([[[NSUserDefaults standardUserDefaults]valueForKey:@"switch2"] isEqualToString:@"qq"]) {
        self.QQSwitch.on = YES;
    }else{
        self.QQSwitch.on = NO;

    }

}
- (IBAction)weiboAction:(id)sender {
     UISwitch *weiboswitch = sender;
    if (weiboswitch.on) {
        WBAuthorizeRequest *request = [WBAuthorizeRequest request];
        request.redirectURI = kWeiboRedirectURI;
        request.scope = @"all";
        
        [WeiboSDK sendRequest:request];

    }else{
        AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
        [WeiboSDK logOutWithToken:myDelegate.wbtoken delegate:self withTag:@"user1"];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setValue:@"weiboout" forKey:@"switch1"];
        self.weiboSwitch.on = NO;
    }

}
- (IBAction)QQAction:(id)sender {
    UISwitch *qqswitch = sender;
    if (qqswitch.on) {
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
        

    }else{
        [self.tencentOAuth logout:self];
        NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
        [userDef setValue:@"qqout" forKey:@"switch2"];
        self.QQSwitch.on = NO;

    }
    
    
}
/**
 * 登录成功后的回调
 */
- (void)tencentDidLogin{
    NSUserDefaults *userDef = [NSUserDefaults standardUserDefaults];
    [userDef setValue:@"qq" forKey:@"switch2"];
    self.QQSwitch.on = YES;

}

/**
 * 登录失败后的回调
 * \param cancelled 代表用户是否主动退出登录
 */
- (void)tencentDidNotLogin:(BOOL)cancelled{
    
}

/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    
}
#pragma mark---weibo delegate

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response{

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
