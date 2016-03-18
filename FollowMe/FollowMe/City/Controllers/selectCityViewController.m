//
//  selectCityViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "selectCityViewController.h"

@interface selectCityViewController ()<UIScrollViewDelegate>
//创建两个视图，国内，国外；
@property(nonatomic, strong) UIView *inlandView;
@property(nonatomic, strong) UIView *foreignView;

@property(nonatomic, strong) UIScrollView *nationSCView;
@property(nonatomic, strong) UISegmentedControl *choseSegment;


@end

@implementation selectCityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = kMainColor;
    
    
//    self.nationSCView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//    self.nationSCView.scrollEnabled = YES;
//    self.nationSCView.scrollsToTop = YES;
//    self.nationSCView.showsHorizontalScrollIndicator = NO;
//    self.nationSCView.showsVerticalScrollIndicator = NO;
//    self.nationSCView.alwaysBounceHorizontal = YES;
//    self.nationSCView.alwaysBounceVertical = YES;
//    self.nationSCView.delegate = self;
//    
//    UIScrollView *scroview = [[UIScrollView alloc] initWithFrame:CGRectMake(kWidth*2, self.view.frame.size.height,kWidth, self.view.frame.size.height)];
//    [scroview addSubview:self.inlandView];
//    [self.nationSCView addSubview:scroview];
//    [self.view addSubview:self.nationSCView];
    
    
    NSArray *array = [NSArray arrayWithObjects:@"国内",@"国外", nil];

    self.choseSegment = [[UISegmentedControl alloc] initWithItems:array];

     self.choseSegment.frame =CGRectMake(kWidth/4, 5, kWidth/2, 40);
    
    self.choseSegment.tintColor = [UIColor whiteColor];
    
//    [self.view addSubview:self.choseSegment];
    [self.choseSegment addTarget:self action:@selector(choseAction:) forControlEvents:UIControlEventValueChanged];
    
    [self.navigationController.navigationBar addSubview:self.choseSegment];
  
}


-(void)choseAction:(UISegmentedControl *)segment{
    NSInteger index = segment.selectedSegmentIndex;
    switch (index) {
        case 0:
            [self inlandAction];
            break;
        case 1:
            [self foreignAction];
            break;
            
        default:
            break;
    }
    
    
    
}

-(void)inlandAction{
    
    
    
}
-(void)foreignAction{
    
    
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    self.navigationController.navigationBar.hidden = YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark----------------------懒加载；
-(UIView *)inlandView{
    
    if (_inlandView == nil) {
        
        self.inlandView = [[UIView alloc] initWithFrame:self.view.frame];
        
        self.inlandView.backgroundColor = [UIColor cyanColor];
        
        
    }
    return _inlandView;
}


-(UIView *)foreignView{
    if (_foreignView == nil) {
        self.foreignView = [[UIView alloc] initWithFrame:self.view.frame];
        self.foreignView.backgroundColor = kMainColor;
    }
    return _foreignView;
    
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
