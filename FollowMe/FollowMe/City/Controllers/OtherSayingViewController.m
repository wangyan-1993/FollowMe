//
//  OtherSayingViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "OtherSayingViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "OtherSayingTableViewCell.h"

static NSString *identiffier = @"identifier";
@interface OtherSayingViewController ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *otherArray;

@end

@implementation OtherSayingViewController
//http://api.breadtrip.com/hunter/hunter/2383951943/comments/?start=0
//http://api.breadtrip.com/hunter/hunter/2383951943/comments/?start=10
//http://api.breadtrip.com/hunter/hunter/2383951943/comments/?start=20

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //注册cell
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OtherSayingTableViewCell" bundle:nil] forCellReuseIdentifier:identiffier];
    
    [self.view addSubview:self.tableView];
    
    [self updateFocusIf];
    
}

-(void)updateFocusIf{
    
    //http://api.breadtrip.com/v3/user/2383951943/trips/?start=0
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    NSLog(@"self.otherString = %@",self.otherString);
    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/hunter/hunter/%@/comments/?start=0",self.otherString];
    NSLog(@"self.otherString = %@",self.otherString);
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSDictionary *dict = responseObject;
        NSDictionary *data = dict[@"data"];
        for (NSDictionary *dic in data[@"items"]) {
            otherModel *model = [[otherModel alloc] init];
            [model setValuesForKeysWithDictionary:dic];
            [self.otherArray addObject:model];
            
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OtherSayingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identiffier forIndexPath:indexPath];
    if (self.otherArray.count > indexPath.row) {
        
        cell.model = self.otherArray[indexPath.row];

    }
    
    return cell;  
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.otherArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return kHeight/3.5;
}

-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
 
    return _tableView;
}

-(NSMutableArray *)otherArray{
    if (_otherArray == nil) {
        self.otherArray = [NSMutableArray new];
    }
    return _otherArray;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
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
