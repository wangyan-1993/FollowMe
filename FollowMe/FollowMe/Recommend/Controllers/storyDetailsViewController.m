//
//  storyDetailsViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//
#define kstoryDetails @"http://api.breadtrip.com/v2/new_trip/spot/?"
#import "storyDetailsViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "storyDetailsView.h"
#import "storyDetailTableViewCell.h"
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "AppDelegate.h"
#import "WBHttpRequest+WeiboShare.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>

//#import <TencentOpenAPI/QQApiInterfaceObject.h>
//#import <TencentOpenAPI/QQApiInterface.h>
//#import <TencentOpenAPI/TencentOAuth.h>
@interface storyDetailsViewController ()
@property (nonatomic, strong) storyDetailsView *storyDetailView;
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIView *attentionView;

@end

@implementation storyDetailsViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.shareBtn.hidden = NO;

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shareBtn.hidden = YES;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self showWhiteBackBtn];
    // Do any additional setup after loading the view.
    self.title = @"故事详情";
    [self workOne];
    self.storyDetailView.owner = self;
    self.view = self.storyDetailView;
//分享
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(kWidth-35, 10, 24, 24);
    [self.shareBtn setImage:[UIImage imageNamed:@"sharePicture"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.shareBtn];
    
//    [self initTencention];
    
}
////注册QQ
//- (void)initTencention{
//    self.tencentOAuth=[[TencentOAuth alloc]initWithAppId:kQQAppID andDelegate:self];
//    self.tencentOAuth.redirectURI = @"www.qq.com";
//}
////分享
- (void)share{
    
    NSMutableArray *obj = [NSMutableArray array];
    
    for (NSInteger i = 0; i < [self titles].count; i++) {
        WBPopMenuModel *info = [WBPopMenuModel new];
        
        info.title = [self titles][i];
        [obj addObject:info];
    }
    [[WBPopMenuSingleton shareManager] showPopMenuSelecteWithFrame:160 item:obj action:^(NSInteger index) {
//       NSLog(@"index:%ld",(long)index);
        switch ((long)index) {
            case 0:
                //微信分享
                [self weixinShare];
                break;
            case 1:
                //朋友圈分享
                [self friendShare];
                break;
            case 2:
                //微博分享
                [self weiboShare];
                break;
            default:
                break;
        }
        
        
    }];
    
}
- (void)friendShare{
    WXMediaMessage *message = [WXMediaMessage message];
    [message setThumbImage:[UIImage imageNamed:@""]];
    
    WXImageObject *ext = [WXImageObject object];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"001" ofType:@".jpg"];
    
    ext.imageData = [NSData dataWithContentsOfFile:filePath];
    
    
    UIImage* image = [UIImage imageWithData:ext.imageData];
    ext.imageData = UIImagePNGRepresentation(image);
    
    
    message.mediaObject = ext;
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    
    //朋友圈
    req.scene =WXSceneTimeline;
    
    [WXApi sendReq:req];
}
- (void)weixinShare{
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.text = @"follow";
    req.bText = YES;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
}
//QQ分享
//- (void)qqshare{
//   
//}
//- (void)tencentDidNotNetWork{
//    WLZLog(@"dafa");
//}
//- (void)tencentDidLogin{
//    
//   
//}
//- (void)tencentDidNotLogin:(BOOL)cancelled{
//    WLZLog(@"dasa");
//}
//- (void)handleSendResult:(QQApiSendResultCode)sendResult{
//    switch (sendResult)
//    {
//        case EQQAPIAPPNOTREGISTED:
//        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"App未注册" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
//            
//            break;
//        }
//        case EQQAPIMESSAGECONTENTINVALID:
//        case EQQAPIMESSAGECONTENTNULL:
//        case EQQAPIMESSAGETYPEINVALID:
//        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送参数错误" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
//            
//            break;
//        }
//        case EQQAPIQQNOTINSTALLED:
//        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"未安装手Q" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
//            
//            break;
//        }
//        case EQQAPIQQNOTSUPPORTAPI:
//        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"API接口不支持" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
//            
//            break;
//        }
//        case EQQAPISENDFAILD:
//        {
//            UIAlertView *msgbox = [[UIAlertView alloc] initWithTitle:@"Error" message:@"发送失败" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//            [msgbox show];
//            
//            break;
//        }
//        default:
//        {
//            break;
//        }
//    }
//
//}

- (void)weiboShare{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kWeiboRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare] authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}
- (WBMessageObject *)messageToShare{
    WBMessageObject *message = [WBMessageObject message];
    message.text = NSLocalizedString(@"更多美食尽在 吃货伙伴app 我在吃货伙伴等你哦！！！", nil);
    return message;
}

- (NSArray *) titles {
    return @[@"微信分享",
             @"朋友圈分享",
             @"微博分享"
             ];
}




- (storyDetailsView *)storyDetailView{
    if (_storyDetailView == nil) {
        self.storyDetailView = [[storyDetailsView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
    }
    return _storyDetailView;
}
- (void)workOne{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:[NSString stringWithFormat:@"%@spot_id=%@&spot_id=%@",kstoryDetails,self.spot_id,self.spot_id] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //WLZLog(@"%@",responseObject);
        NSDictionary *rootDic = responseObject;
         if (rootDic[@"status"] == [NSNumber numberWithInteger:0]) {
             NSDictionary *dataDic = rootDic[@"data"];
        self.storyDetailView.dataDic = dataDic;
         }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
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
