//
//  InformationViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.



#import "InformationViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "BecomeHunterViewController.h"
#import "SettingsViewController.h"
#import "UserInfoViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobObject.h>
#import <BmobSDK/BmobQuery.h>

@interface InformationViewController ()<UITableViewDelegate, UITableViewDataSource>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *imageArray;
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong) NSMutableArray *sectionArray;
@property(nonatomic, copy) NSString *personal;
@end

@implementation InformationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    BmobUser *user = [BmobUser getCurrentUser];
    self.imageArray = [user objectForKey:@"array"];
    self.titleArray = [user objectForKey:@"titlwArray"];
    
    
    [self.view addSubview:self.tableView];
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                self.username = [obj objectForKey:@"name"];
                self.personal = [obj objectForKey:@"signature"];
                 [self addheaderView];
                [self.tableView reloadData];
            }
        }
    }];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
    BmobUser *user = [BmobUser getCurrentUser];
    self.imageArray = [user objectForKey:@"array"];
    self.titleArray = [user objectForKey:@"titlwArray"];
    WLZLog(@"%@", self.imageArray);
    WLZLog(@"%@", self.titleArray);
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                self.username = [obj objectForKey:@"name"];
                self.personal = [obj objectForKey:@"signature"];
                [self addheaderView];
                [self.tableView reloadData];
            }
        }
    }];
    [self.tableView reloadData];

}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
        return 1;
   }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"123";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    long num = (long)(self.titleArray.count-1-indexPath.section);
    cell.textLabel.text = self.titleArray[num];

    cell.textLabel.numberOfLines = 0;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    long num = (long)(self.titleArray.count-1-indexPath.section);
    NSString *str =self.titleArray[num];
    CGRect textRect = [str boundingRectWithSize:CGSizeMake(kWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17]}  context:nil];
    return textRect.size.height+5;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    WLZLog(@"%ld", self.titleArray.count);
    return self.titleArray.count;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth/3)];
    UIImageView *view1 = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, kWidth/3-10, kWidth/3-10)];
    UIImageView *view2 = [[UIImageView alloc]initWithFrame:CGRectMake(5+kWidth/3, 5, kWidth/3-10, kWidth/3-10)];
    UIImageView *view3 = [[UIImageView alloc]initWithFrame:CGRectMake(5+kWidth/3*2, 5, kWidth/3-10, kWidth/3-10)];
    WLZLog(@"%@", self.imageArray);
    WLZLog(@"%@", self.titleArray);
    long num = (long)(self.titleArray.count-1-section);
    NSArray *array = self.imageArray[num];
    if (array.count >= 1) {
        [view1 sd_setImageWithURL:[NSURL URLWithString:self.imageArray[num][0]]];
    }else{
        [view1 sd_setImageWithURL:[NSURL URLWithString:@"http://photos.breadtrip.com/trackpoints_thumbnail_1725439_1459147708309.jpg"]];
    }
    if (array.count >= 2) {
         [view2 sd_setImageWithURL:[NSURL URLWithString:self.imageArray[num][1]]];
    }
    if (array.count >= 3) {
        [view3 sd_setImageWithURL:[NSURL URLWithString:self.imageArray[num][2]]];
    }
    

    [view addSubview:view1];
    [view addSubview:view2];

    [view addSubview:view3];

    return view;
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat sectionHeaderHeight = kWidth/3;
    if (scrollView.contentOffset.y <= sectionHeaderHeight && scrollView.contentOffset.y> 0) {
        scrollView.contentInset = UIEdgeInsetsMake(-scrollView.contentOffset.y, 0, 0, 0);
    }else
        if(scrollView.contentOffset.y >= sectionHeaderHeight){
            
            scrollView.contentInset = UIEdgeInsetsMake(-sectionHeaderHeight, 0, 0, 0);
        }
}

- (void)addheaderView{
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*0.7+20)];
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*0.7)];
    imageview.image = [UIImage imageNamed:@"200"];
    [header addSubview:imageview];
    UIImageView *black = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kWidth*0.7)];
    black.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0
 alpha:0.3];
    [header addSubview:black];
    
    UIButton *settingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    settingBtn.frame = CGRectMake(kWidth-50, 15, 30, 30);
    [settingBtn setImage:[UIImage imageNamed:@"Settings"] forState:UIControlStateNormal];
    [settingBtn addTarget:self action:@selector(settingsAction) forControlEvents:UIControlEventTouchUpInside];
    [header addSubview:settingBtn];
    UIImageView *imageviewHeader = [[UIImageView alloc]initWithFrame:CGRectMake(kWidth/3, kWidth/6, kWidth/3, kWidth/3)];
    imageviewHeader.layer.cornerRadius = kWidth/3/2;
    imageviewHeader.clipsToBounds = YES;
  //  WLZLog(@"%@", self.headerImage);
        [imageviewHeader sd_setImageWithURL:[NSURL URLWithString:self.headerImage] placeholderImage:[UIImage imageNamed:@"123456"]];
        
    
    UIButton *headerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    headerBtn.frame = imageviewHeader.frame;
    [headerBtn addTarget:self action:@selector(headerInformation) forControlEvents:UIControlEventTouchUpInside];
    
    // UIImageView默认不允许用户交互，headerBtn不能直接加载到其上面，如果需要把btn加载到它上面，需要打开UIImageView的交互
    //打开交互     imageView.userInteractionEnabled = YES;
    
    [header addSubview:headerBtn];
    [header addSubview:imageviewHeader];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth/2+10, kWidth, 20)];
    label.textAlignment = NSTextAlignmentCenter;
   
    label.text = self.username;
    label.textColor = [UIColor whiteColor];
    [header addSubview:label];
    

    UILabel *personalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth/2 + 30 , kWidth, 30)];
    personalLabel.text = self.personal;
    personalLabel.textAlignment = NSTextAlignmentCenter;
    personalLabel.textColor = [UIColor whiteColor];
    [header addSubview:personalLabel];
    
    
    UILabel *diaryLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, kWidth*0.7, kWidth, 20)];
    diaryLabel.text = @"生活点滴";
    diaryLabel.textAlignment = NSTextAlignmentCenter;
    diaryLabel.textColor = kMainColor;
    [header addSubview:diaryLabel];
    self.tableView.tableHeaderView = header;
    
}




- (void)settingsAction{
    SettingsViewController *settingVC = [[SettingsViewController alloc]init];
    settingVC.imageStr = self.headerImage;
    settingVC.username = self.username;
    [self.navigationController pushViewController:settingVC animated:YES];
}

- (void)headerInformation{
    UserInfoViewController *userinfo = [[UserInfoViewController alloc]init];
    userinfo.urlImage = self.headerImage;
    [self.navigationController pushViewController:userinfo animated:YES];
}
- (void)message{
    
}

- (void)order{
    
}
- (void)moneyAction{
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeight-60)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.sectionHeaderHeight = kWidth/3;
        //self.tableView.rowHeight = kWidth;
    }
    return _tableView;
}
- (NSMutableArray *)sectionArray{
    if (_sectionArray == nil) {
        self.sectionArray = [NSMutableArray new];
    }
    return _sectionArray;
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
