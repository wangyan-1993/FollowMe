//
//  mapAddressViewController.m
//  FollowMe
//
//  Created by scjy on 16/3/30.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "mapAddressViewController.h"
#import <MAMapKit/MAMapKit.h>

@interface mapAddressViewController ()<MAMapViewDelegate>{
    MAMapView *_mapView;
}

@end

@implementation mapAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self map];
//    WLZLog(@"经度：%@  维度：%@",self.longitudeZH,self.latitudeZH);
    
    
}

- (void) map {
    [MAMapServices sharedServices].apiKey = kZhGaodeMapKey;
    
    _mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), CGRectGetHeight(self.view.bounds))];
    _mapView.showsScale= YES;  //设置成NO表示不显示比例尺；YES表示显示比例尺
    _mapView.centerCoordinate = CLLocationCoordinate2DMake([self.latitudeZH floatValue], [self.longitudeZH floatValue]);
    _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x, 22);  //设置比例尺位置
    _mapView.mapType = MAMapTypeStandard;
    //显示实时交通路况
//    _mapView.showTraffic = YES;
    
    [self point];//大头针标注
    [self.view addSubview:_mapView];
}
- (void) point {
    MAPointAnnotation *pointAnnotation = [[MAPointAnnotation alloc] init];
    pointAnnotation.coordinate = CLLocationCoordinate2DMake([self.latitudeZH floatValue], [self.longitudeZH floatValue]);
    pointAnnotation.title = self.name;
//    pointAnnotation.subtitle = @"";//副标题
    [_mapView addAnnotation:pointAnnotation];
}
/**
 *实现 <MAMapViewDelegate> 协议中的 mapView:viewForAnnotation:回调函数，设置标注样式。如下所示：
 */
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation{
    if ([annotation isKindOfClass:[MAPointAnnotation class]]) {
        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
        annotationView.canShowCallout = YES;//设置气泡可以弹出
        annotationView.animatesDrop = YES;  //设置动画显示
        annotationView.draggable = YES;     //设置标注可以拖动，默认为NO
        annotationView.pinColor = MAPinAnnotationColorPurple;

    }
    return nil;
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
