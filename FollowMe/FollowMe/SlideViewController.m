//
//  SlideViewController.m
//  ViewLuoYang
//
//  Created by scjy on 16/3/28.
//  Copyright © 2016年 秦俊珍. All rights reserved.
//
//宏定义宽度，高度
#define KScreenWidth  [UIScreen mainScreen].bounds.size.width
#define KScreenHeight [UIScreen mainScreen].bounds.size.height

#import "SlideViewController.h"
//引入头文件
#import "AppDelegate.h"

@interface SlideViewController ()<UIScrollViewDelegate>

@property(nonatomic, retain) UIScrollView *scrollView;
@property(nonatomic, retain) UIPageControl *pageControl;


@end

@implementation SlideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //scrollView的位置
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    //设置大小
    self.scrollView.contentSize = CGSizeMake(KScreenWidth*4, KScreenHeight);
    //要分页
    self.scrollView.pagingEnabled = YES;
    //添加代理
    self.scrollView.delegate = self;
    
    for (int i = 0; i < 4; i ++) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, KScreenHeight)];
        scrollView.delegate = self;
        [self.scrollView addSubview:scrollView];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
        NSString *imageStr = [NSString stringWithFormat:@"%02d.jpg",i+1];
        imageView.tag = 110;
        imageView.image = [UIImage imageNamed:imageStr];
        [scrollView addSubview:imageView];
        
        //判断当时最后一张图片的时候，添加一个按钮，进入应用
        if (i == 3) {
            UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            joinBtn.frame = CGRectMake(KScreenWidth*3+KScreenWidth/4, KScreenHeight-KScreenHeight*0.26, KScreenWidth/2, 44);
//            [joinBtn setTitle:@"立即体验" forState:UIControlStateNormal];
//            [joinBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [joinBtn addTarget:self action:@selector(experienceAction) forControlEvents:UIControlEventTouchUpInside];
            joinBtn.backgroundColor = [UIColor clearColor];
            joinBtn.layer.cornerRadius = 10;
            [self.scrollView addSubview:joinBtn];
        }
        //当图片不是最后一张的时候，添加按钮“跳过”，让用户选择
//        if (i <= 4) {
//            for (int j = 1; j <= 4; j++) {
//                UIButton *threeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                threeBtn.frame = CGRectMake(KScreenWidth*j+KScreenWidth/4*3, 12, KScreenWidth/4, 44);
//                [threeBtn setTitle:@"跳过" forState:UIControlStateNormal];
//                [threeBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//                [threeBtn addTarget:self action:@selector(experienceAction) forControlEvents:UIControlEventTouchUpInside];
//                threeBtn.layer.cornerRadius = 10;
//                [threeBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 75, 10, 10)];
//                [threeBtn setImage:[UIImage imageNamed:@"back_arrow1"] forState:UIControlStateNormal];
//                [scrollView addSubview:threeBtn];
//            }
//        }
        
        
    }
    
//    //创建pageControl
//    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, KScreenHeight-100, KScreenWidth, 30)];
//    //设置pageControlde个数
//    self.pageControl.numberOfPages = 5;
//    //为选中页面的颜色
//    self.pageControl.pageIndicatorTintColor = [UIColor cyanColor];
//    //当前小圆点的颜色
//    self.pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
//    //给小圆点添加点击方法
//    [self.pageControl addTarget:self action:@selector(pageSelectAction:) forControlEvents:UIControlEventValueChanged];
   
    [self.view addSubview:self.scrollView];
//    [self.view addSubview:self.pageControl];
    
}
#pragma mark-------------scrollView和pageControl的结合使用
//图片随点移动
//- (void)pageSelectAction:(UIPageControl *)pageControl{
//    //获取pageConreol点击的页面在第几页
//    NSInteger pageNum = pageControl.currentPage;
//    //获取页面的宽度
//    CGFloat pageWidth = self.scrollView.frame.size.width;
//    //让scrollView翻滚到第几页
//    self.scrollView.contentOffset = CGPointMake(pageNum * pageWidth, 0);
//    
//}

//点随图片移动
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //第一步获取scrollView页面宽度
    CGFloat pageWidth = self.scrollView.frame.size.width;
    //第二步获取scrollView停止时候的偏移量
    CGPoint offset = self.scrollView.contentOffset;
    //第三步：
    NSInteger pageNum = offset.x / pageWidth;
    //第四步修改pageControl的当前页
    self.pageControl.currentPage = pageNum;
    
}
//点击按钮进入工程方法
- (void)experienceAction{
    /*
     UIApplication的核心作用是提供了iOS程序运行期间的控制和协作工作。
     在UIApplication中处理的系统事件时，只需转到_delegate这个类去处理， 这个类对象就是应用程序委托对象。我们可以从应用程序的单例类对象中得到应用程序委托的对象
     */
   AppDelegate *app=(AppDelegate *)[UIApplication sharedApplication].delegate;
    //把app.mangoNav作为根视图
    app.window.rootViewController=app.tabBarVC;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
