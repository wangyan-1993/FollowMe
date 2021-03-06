//
//  SelectViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SelectViewController.h"
#import "cityFirstTableViewCell.h"
#import "cityModel.h"
#import "DetailViewController.h"
#import "PersonViewController.h"
#import <AFNetworking/AFHTTPSessionManager.h>
#import "ProgressHUD.h"
#import "selectHotViewController.h"
#import "InformationViewController.h"


static NSString *identifier = @"cell";

@interface SelectViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
@property(nonatomic, strong) UISearchBar *citySearchBar;
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *listArray;


@end

@implementation SelectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.citySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(kWidth/6, 5, kWidth - kWidth/6 - 5, 40)];
    self.citySearchBar.delegate = self;
    self.citySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.citySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.citySearchBar.placeholder = @"请搜索关键字,地点,分类";
    self.citySearchBar.layer.cornerRadius = 10.0;
    self.citySearchBar.clipsToBounds = YES;
    self.citySearchBar.placeholder = self.strCityName;
    [self.navigationController.navigationBar addSubview:self.citySearchBar];
//    [self.view addSubview:self.citySearchBar];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"cityFirstTableViewCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    
    [self showBackBtn];
    
    [self uptataConfig];
    
}
-(void)uptataConfig{

    NSString *urlStr = [NSString stringWithFormat:@"http://api.breadtrip.com/hunter/products/v2/search/?city_name=%@&lat=34.613476&lng=112.413994&q=%@",self.choseCityName,self.strCityName];
    NSString *url = [urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [manger GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [ProgressHUD show:@"正在为您请求数据"];
        
        NSDictionary *dictio = responseObject;
        NSDictionary *dataDic = dictio[@"data"];
        self.listArray = [NSMutableArray new];
        for (NSDictionary *dic in dataDic[@"product_list"]) {
            cityModel *model = [[cityModel alloc]initWithCity:dic];

            [self.listArray addObject:model];
        }
        [self.tableView reloadData];
        
        [ProgressHUD showSuccess:@"已成功"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
    
    
}

#pragma mark ---------------tableView Delagate DataScore

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
        cityFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
        
        cell.model = self.listArray[indexPath.row];
    [cell.ClassifyButton addTarget:self action:@selector(classAction:event:) forControlEvents:UIControlEventTouchUpInside];
    
        return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    cityModel *model = self.listArray[indexPath.row];
    
    DetailViewController *detail = [[DetailViewController alloc] init];
    
    detail.IDString = model.product_id;
    
    self.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detail animated:NO];
 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.listArray.count;

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 272;
}

-(void)classAction:(UIButton *)button event:(UIEvent*)event{
    
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint point = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    cityModel *Cmodel = self.listArray[indexPath.row];
    
    PersonViewController *person = [[PersonViewController alloc] init];
    person.personId = Cmodel.user[@"id"];
    [self.navigationController pushViewController:person animated:NO];
    
}


-(UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.citySearchBar.hidden = NO;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.citySearchBar.hidden = YES;
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
