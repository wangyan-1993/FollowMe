//
//  SearchTravelViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "SearchTravelViewController.h"

@interface SearchTravelViewController ()<UISearchBarDelegate>
@property(nonatomic, strong) UISearchBar *mySearchBar;
@end

@implementation SearchTravelViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(40, 10, kWidth-40, 40)];
    self.mySearchBar.delegate = self;
    self.mySearchBar.text = self.cityName;
    [self.navigationController.navigationBar addSubview:self.mySearchBar];
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeDefault;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    [self showBackBtn];
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
