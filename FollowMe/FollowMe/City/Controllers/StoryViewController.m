//
//  StoryViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "StoryViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "storyTableViewCell.h"

static NSString *identiffier = @"identifier";
@interface StoryViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;

@property(nonatomic, strong) NSMutableArray *StoryArray;

@end

@implementation StoryViewController
//http://api.breadtrip.com/hunter/hunter/2383951943/comments/?start=0
//http://api.breadtrip.com/hunter/hunter/2383951943/comments/?start=10
//http://api.breadtrip.com/hunter/hunter/2383951943/comments/?start=20

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"storyTableViewCell" bundle:nil] forCellReuseIdentifier:identiffier];
    
    [self.view addSubview:self.tableView];
    [self updateFocusIf];
    
}

-(void)updateFocusIf{
    
    //http://api.breadtrip.com/v3/user/2383951943/trips/?start=0
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:[NSString stringWithFormat:@"http://api.breadtrip.com/v3/user/%@/trips/?start=0",self.storyString] parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        WLZLog(@"%@",responseObject);
        NSDictionary *Root = responseObject;
        NSDictionary *data = Root[@"data"];
        NSDictionary *trips = data[@"trips"];
        for (NSDictionary *dict in trips) {
            
            storyMdel *modelStory = [[storyMdel alloc] init];
            [modelStory setValuesForKeysWithDictionary:dict];
            
            [self.StoryArray addObject:modelStory];
            
        }
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    storyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiffier forIndexPath:indexPath];
    
    if (self.StoryArray.count > indexPath.row) {
        cell.model = self.StoryArray[indexPath.row];
    }
    
    
    return cell;
    
    
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.StoryArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return kHeight/3.35;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

-(NSMutableArray *)StoryArray{
    
    if (_StoryArray == nil) {
        self.StoryArray = [NSMutableArray new];
        
    }
    return _StoryArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
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
