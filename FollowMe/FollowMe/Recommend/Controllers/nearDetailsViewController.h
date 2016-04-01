//
//  nearDetailsViewController.h
//  FollowMe
//
//  Created by scjy on 16/3/30.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface nearDetailsViewController : UIViewController<UIScrollViewDelegate>
@property (nonatomic, retain) NSString *detailId;
@property (nonatomic, retain) UIImageView *headImage;
@property (nonatomic, retain) UIScrollView *scrollView;
@property (nonatomic, retain) UIButton *imageBtn;
@property (nonatomic, retain) NSString *typeId;
- (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font;
@end
