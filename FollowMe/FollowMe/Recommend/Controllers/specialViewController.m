//
//  specialViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/27.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "specialViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "specialTableViewCell.h"
#import "specialModel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "WBPopMenuModel.h"
#import "WBPopMenuSingleton.h"
#import "WXApi.h"
#import "WXApiObject.h"
#import "AppDelegate.h"
#import "WBHttpRequest+WeiboShare.h"
#import "WeiboSDK.h"
#import <MessageUI/MessageUI.h>
#import "ProgressHUD.h"
#import <BmobSDK/Bmob.h>
#import "DataBaseManager.h"
#import "MineViewController.h"
@interface specialViewController ()<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate>{
    NSString *_kURL;
    NSInteger _likepage;
    NSString *_objectID;
}
@property (nonatomic, strong) UITableView *tableView;
//头部
@property (nonatomic, strong) UIButton *shareBtn;
@property (nonatomic, strong) UIView *headView;
@property (nonatomic, retain) NSString *headImage;
@property (nonatomic, retain) NSString *userImage;
@property (nonatomic, retain) NSString *userName;
@property (nonatomic, retain) NSString *introduce;
@property (nonatomic, strong) NSMutableArray *sectionArray;
@property (nonatomic, strong) NSMutableArray *tableViewArray;
@property (nonatomic, strong) NSMutableArray *daysArray;
@property (nonatomic, strong) UIButton *likeBtn;
@property (nonatomic, assign) BOOL exist;
@end

@implementation specialViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = YES;
    self.shareBtn.hidden = NO;
    self.likeBtn.hidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.shareBtn.hidden = YES;
    self.likeBtn.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _kURL = [NSString stringWithFormat:@"http://api.breadtrip.com/trips/%@/waypoints/",self.userId];
    self.navigationController.navigationBar.tintColor = kCollectionColor;
    [self showWhiteBackBtn];
    [self shareRightBtn];
    self.tabBarController.tabBar.hidden = YES;
    [self workOne];
    [self.view addSubview:self.tableView];
//    [self.tableView registerClass:[specialTableViewCell class] forCellReuseIdentifier:@"cell"];
    self.view.backgroundColor = kCollectionColor;
    //不让导航栏随着tableview上下滑动
    self.edgesForExtendedLayout = UIRectEdgeNone;
    _likepage = 0;
    [self bmob];
}
- (void)bmob{
    BmobUser *user = [BmobUser getCurrentUser];
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"like"];
    //查询
    if (user.username != nil) {
        [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                WLZLog(@"tavelLikeId==%@",[obj objectForKey:@"tavelLikeId"]);
                WLZLog(@"userName == %@",[obj objectForKey:@"userName"]);
                
                NSMutableArray *group = [NSMutableArray new];
                if ([[obj objectForKey:@"userName"]isEqualToString:user.username]) {
                    [group addObject:[obj objectForKey:@"tavelLikeId"]];
                    for (NSString *str in group) {
                        if ([str isEqualToString: _kURL]) {
                            _objectID = [obj objectForKey:@"objectId"];
                            WLZLog(@"%@",_objectID);
                            _likepage = 1;
                            
                        }
                        
                    }
                }
                
            }
            [self likeWay];

        }];
        
    }
    else{
        
        _likepage = 10;
    }
    
    [self likeWay];

}
- (void)likeWay{
    self.likeBtn.frame = CGRectMake(kWidth-70, 10, 24, 24);
    if (_likepage == 1) {
        [self.likeBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
    }else{
        [self.likeBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
    }
    
    
    [self.likeBtn addTarget:self action:@selector(like) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.likeBtn];
}
- (void)like{
        BmobUser *user = [BmobUser getCurrentUser];
    if (_likepage == 0) {
        [self.likeBtn setImage:[UIImage imageNamed:@"like2"] forState:UIControlStateNormal];
        [ProgressHUD showSuccess:@"收藏成功"];
        
        BmobObject *obj = [BmobObject objectWithClassName:@"like"];
        [obj setObject:user.username forKey:@"userName"];
        [obj setObject:_kURL forKey:@"tavelLikeId"];
        [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                WLZLog(@"保存成功%@",obj);
                [self bmob];
                
            }
            else{
                WLZLog(@"失败");
            }
        }];
        
        
        _likepage = 1;
    }
    else if(_likepage == 1){
        [self.likeBtn setImage:[UIImage imageNamed:@"like1"] forState:UIControlStateNormal];
        
        BmobObject *bmobObject = [BmobObject objectWithoutDatatWithClassName:@"like"  objectId:_objectID];
        [bmobObject deleteInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
            if (isSuccessful) {
                //删除成功后的动作
                NSLog(@"successful");
            } else if (error){
                NSLog(@"%@",error);
            } else {
                NSLog(@"UnKnow error");
            }
        }];
        
        
        
        _likepage = 0;

    }
    else if (_likepage == 10){
        //提示框
//        WLZLog(@"dsawdadw")
       
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您还没有登录，请先登录" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                self.tabBarController.selectedIndex = 4;
//                WLZLog(@"sasdadad");
            }];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:sureAction];
            [alert addAction:cancelAction];
            //添加提示框
            [self presentViewController:alert animated:YES completion:nil];
            
            
        

        
        
    }
}
- (void)shareRightBtn{
    self.shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.shareBtn.frame = CGRectMake(kWidth-35, 10, 24, 24);
    [self.shareBtn setImage:[UIImage imageNamed:@"sharePicture"] forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(share) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:self.shareBtn];
}
- (void)headWay{
    //得到图片的路径
    NSString *path = [[NSBundle mainBundle] pathForResource:@"follow" ofType:@"gif"];
    //将图片转为NSData
    NSData *gifData = [NSData dataWithContentsOfFile:path];
    //创建一个webView，添加到界面
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kWidth, 64)];
    [self.view addSubview:webView];
    //自动调整尺寸
    webView.scalesPageToFit = YES;
    //禁止滚动
    webView.scrollView.scrollEnabled = NO;
    //设置透明效果
    webView.backgroundColor = [UIColor clearColor];
    webView.opaque = 0;
    //加载数据
    [webView loadData:gifData MIMEType:@"image/gif" textEncodingName:nil baseURL:nil];
    [self.headView addSubview:webView];
    
    
    
    UIImageView *headImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight*0.25)];
    headImage.backgroundColor = [UIColor blackColor];
    if ([self.headImage isEqual:[NSNull null]]) {
        headImage.image = [UIImage imageNamed:@"200"];
    }else{
        [headImage sd_setImageWithURL:[NSURL URLWithString:self.headImage] placeholderImage:nil];}
    
    UIImageView *userImage = [[UIImageView alloc] initWithFrame:CGRectMake(kWidth/2-25, kHeight*0.25-25+64, 50, 50)];
    userImage.backgroundColor = [UIColor orangeColor];
    userImage.layer.masksToBounds = YES;
    userImage.layer.cornerRadius = 25.f;
    userImage.layer.borderWidth = 3;
    userImage.layer.borderColor = [UIColor whiteColor].CGColor;
    [userImage sd_setImageWithURL:[NSURL URLWithString:self.userImage] placeholderImage:nil];
    
    UILabel *Namelable = [[UILabel alloc] initWithFrame:CGRectMake(0, kHeight*0.25+25+64, kWidth, 50)];
    Namelable.text = self.userName;
    Namelable.enabled = NO;
    Namelable.highlighted = YES;
    Namelable.font = [UIFont systemFontOfSize:13];
    Namelable.textAlignment = NSTextAlignmentCenter;
    
    UILabel *introduceLable = [[UILabel alloc] initWithFrame:CGRectMake(70, kHeight*0.25+75+64, kWidth-140, kHeight*0.25-90)];
    introduceLable.font = [UIFont fontWithName:@"Helvetica-Bold" size:21];
    introduceLable.text = self.introduce;
    introduceLable.numberOfLines = 0;
    introduceLable.textAlignment = NSTextAlignmentCenter;

    [self.headView addSubview:introduceLable];
    [self.headView addSubview:Namelable];
    [self.headView addSubview:headImage];
    [self.headView addSubview:userImage];
    self.tableView.tableHeaderView = self.headView;
}

- (void)workOne{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];

    [manager GET:_kURL parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        WLZLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WLZLog(@"%@",responseObject);
        NSDictionary *rootDic = responseObject;
        //头部图片
        self.headImage = rootDic[@"trackpoints_thumbnail_image"];
        self.introduce = rootDic[@"name"];
        //遍历用户字典
        NSDictionary *userDic = rootDic[@"user"];
        self.userImage = userDic[@"avatar_m"];
        self.userName = userDic[@"name"];
        //遍历旅游线路日程
        NSArray *daysArray = rootDic[@"days"];
        for (NSDictionary *dic in daysArray) {
            [self.daysArray addObject:dic];
            [self.sectionArray addObject:dic[@"waypoints"]];
        NSArray *wayArray = dic[@"waypoints"];
        
            NSMutableArray *group = [NSMutableArray new];
        for (NSDictionary *dic1 in wayArray) {

            specialModel *model = [[specialModel alloc] initWithDictionary:dic1];
            [group addObject:model];
        
            }
            [self.tableViewArray addObject:group];
        }
        
        [self.tableView reloadData];
        [self headWay];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSMutableArray *group = self.tableViewArray[indexPath.section];
    specialModel *model = group[indexPath.row];
    CGFloat cellHeight = [specialTableViewCell getCellHeightWithModel:model];
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 26.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 3, kWidth, 20)];
    
    NSString *str1   = self.daysArray[section][@"date"];
    NSString *str2   = self.daysArray[section][@"day"];
    NSString *str    = [NSString stringWithFormat:@"第%@天  %@",str2,str1];
    
    UILabel *lable   = [[UILabel alloc] initWithFrame:CGRectMake(10, 0,kWidth-10, 20)];
    lable.text       = str;
    lable.textColor  = [UIColor brownColor];

    [headView addSubview:lable];
    return headView;
}
//让分区头部视图随着屏幕滑动而滑动
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == self.tableView) {
        CGFloat height = 26;
        if (scrollView.contentOffset.y <= height && scrollView.contentOffset.y > 0) {
            scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
        }
        else if(scrollView.contentOffset.y >= height){
            scrollView.contentInset = UIEdgeInsetsMake(-height, 0, 0, 0);
        }
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //取消cell的重用机制
    static NSString *cellid = @"cellid";
    specialTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell = [[specialTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    specialTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    if (self.tableViewArray > 0) {
        NSMutableArray *group = self.tableViewArray[indexPath.section];
        cell.model = group[indexPath.row];
    }
    
    cell.owone = self;
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *group = self.sectionArray[section];
    return group.count;
}
- (UIView *)headView{
    if (_headView == nil) {
        self.headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight*0.5+64)];
//        self.headView.backgroundColor = [UIColor cyanColor];
        self.headView.backgroundColor = kCollectionColor;
        
    }
    return _headView;
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]
                          initWithFrame:CGRectMake(0, 0, kWidth, kHeight-64)style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
//        self.tableView.rowHeight = 375;
        self.tableView.backgroundColor = kCollectionColor;


        
    }
    return _tableView;
}
- (NSMutableArray *)daysArray{
    if (_daysArray == nil) {
        self.daysArray = [NSMutableArray new];
    }
    return _daysArray;
}
- (NSMutableArray *)tableViewArray{
    if (_tableViewArray == nil) {
        self.tableViewArray = [NSMutableArray new];
    }
    return _tableViewArray;
}
- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil) {
        self.sectionArray = [NSMutableArray new];
    }
    return _sectionArray;
}


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
- (UIButton *)likeBtn{
    if (_likeBtn == nil) {
        self.likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];

    }
    return _likeBtn;
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
