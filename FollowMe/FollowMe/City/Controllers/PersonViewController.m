//
//  PersonViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.

//    //http://api.breadtrip.com/v3/user/2384156923/
//
//    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    //http://web.breadtrip.com/hunter/2384305001/v2/
//    NSURL *url = [NSURL URLWithString:@"http://web.breadtrip.com/hunter/2384305001/v2/"];
//    [webView loadRequest:[NSURLRequest requestWithURL:url]];
//

#import "PersonViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "personHeadView.h"
#import "AppraiseTableViewCell.h"
#import "storyMdel.h"
#import "storyTableViewCell.h"
#import "OtherSayingTableViewCell.h"
#import "ActivityTableViewCell.h"
#import "otherModel.h"
//注册cell使用到的静态变量；
static NSString *Inentifier = @"Identifier";
static NSString *storyID = @"ourStory";
static NSString *otherID = @"otherID";
static NSString *Activity = @"ActivityID";

@interface PersonViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) personHeadView *headView;
@property (strong, nonatomic)  UIView *showView;


@property(nonatomic, strong) NSMutableArray *AppraiseArray;
@property(nonatomic, strong) NSMutableArray *storyArray;
@property(nonatomic, strong) NSMutableArray *otherSayArray;

@end

@implementation PersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self updataConfig];

    
    
//    [self.showView addSubview:self.headView];
    
    self.tableView.tableHeaderView = self.headView;
    
    [self.view addSubview:self.tableView];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"AppraiseTableViewCell" bundle:nil] forCellReuseIdentifier:Inentifier];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherSayingTableViewCell" bundle:nil] forCellReuseIdentifier:otherID];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ActivityTableViewCell" bundle:nil] forCellReuseIdentifier:Activity];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"storyTableViewCell" bundle:nil] forCellReuseIdentifier:storyID];
    
    
   
    
}

/*
//和有趣的人做有趣的事：
 http://api.breadtrip.com/v3/user/2383951943/
 
 李建华
 http://api.breadtrip.com/v3/user/2384321953/
 
 星盘组：
 http://api.breadtrip.com/v3/user/2384163720/
 
 文慧；
 http://api.breadtrip.com/v3/user/2384097265/
 
 我爱亮晶晶
 http://api.breadtrip.com/v3/user/2384097265/
 
 http://api.breadtrip.com/destination/place/1/US/
 
 api.breadtrip.com/v3/user/2384097265/
 
 */

#pragma mark--------------------数据加载
-(void)updataConfig{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:@"http://api.breadtrip.com/v3/user/2384097265/" parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WLZLog(@"%@",responseObject);

        NSDictionary *root = responseObject;
        NSDictionary *data = root[@"data"];
        
        //头部视图以及第一个分区
        NSDictionary *user = data[@"user_info"];
        self.headView.dic = user;
//                AppraiseTableViewCell *appre = [[AppraiseTableViewCell alloc] init];
//                appre.dic = user;
//                ClasifyModel *model = [[ClasifyModel alloc]initWithDictionary:user];
//                [self.AppraiseArray addObject:model];

        
        //评论，第二个分区
        NSDictionary *client_comments = data[@"client_comments"];
        for (NSDictionary *clientDic in client_comments[@"data"]) {
            otherModel *model = [[otherModel alloc] init];
            [model setValuesForKeysWithDictionary:clientDic];
            [self.otherSayArray addObject:model];
        }
        
//        游记故事集，第三个分区
        NSDictionary *trips = data[@"trips"];
        for (NSDictionary *dict in trips[@"data"]) {
            
            storyMdel *modelStory = [[storyMdel alloc] init];
            [modelStory setValuesForKeysWithDictionary:dict];
            
            [self.storyArray addObject:modelStory];
            
        }
        
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WLZLog(@"%@",error);
    }];
   
}



#pragma mark --------------- tableView;
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }else if (section == 1){
//        return self.storyArray.count;
        return 3;
        
    }else if (section == 2){
        return 3;
    }else if (section == 3){
        return 3;
    }
    else{
        return 3;
    }
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"123";
    if (indexPath.section == 0) {
      

        AppraiseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Inentifier forIndexPath:indexPath];
        
//        cell.model = self.AppraiseArray[indexPath.row];

        return cell;
    }else if (indexPath.section == 1){
        OtherSayingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:otherID forIndexPath:indexPath];
//        cell.model = self.otherSayArray[indexPath.row];
        
        return cell;
        
    }else if (indexPath.section == 2){
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:Activity forIndexPath:indexPath];
        
        return cell;
        
    }
    else if (indexPath.section == 3){
        storyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:storyID forIndexPath:indexPath];
//        cell.model = self.storyArray[indexPath.row];
        
        return cell;
    }else{
 
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        if (indexPath.row == 0) {
            cell.textLabel.text = @"身份";
        }else if (indexPath.row == 1){
            cell.textLabel.text = @"职业";
        }else{
            cell.textLabel.text = @"电话号码";
        }
    }
        return cell;}
        
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return kHeight/4;
    }else if (indexPath.section == 1){
        return kHeight*0.28;
    }else if (indexPath.section == 2){
        return kHeight*0.4;
    }else if (indexPath.section == 3){
        return kHeight*0.3;
    }
    else{
       return 50;
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section ==1 || section == 3) {
        return 30;
    }else
        return 0;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 2 || section == 3 || section == 4) {
        return 30;
    }else
        return 0;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 5;
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return @"评论";
    }else if (section == 2){
        return @"猎人活动";
    }else if (section == 3){
        return @"游记&故事";
        
    }else if (section == 4){
        return @"猎人认证信息";
    }else
    return @"";
    
}

#pragma mark----------------懒加载

-(UITableView *)tableView{
    
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
//        self.tableView.backgroundColor = [UIColor cyanColor];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
-(personHeadView *)headView{
    if (_headView == nil) {
        self.headView = [[personHeadView alloc] initWithFrame:CGRectMake(0, 64, kWidth, kHeight*0.7)];
//        self.headView.backgroundColor = [UIColor cyanColor];

    }
    return _headView;
    
    
}
-(NSMutableArray *)storyArray{
    if (_storyArray == nil) {
        self.storyArray = [NSMutableArray new];
    }
    return _storyArray;
}

-(NSMutableArray *)AppraiseArray{
    if (_AppraiseArray == nil) {
        self.AppraiseArray = [NSMutableArray new];
    }
    return _AppraiseArray;
}


-(NSMutableArray *)otherSayArray{
    if (_otherSayArray == nil) {
        self.otherSayArray = [NSMutableArray new];
        
    }
    return _otherSayArray;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
