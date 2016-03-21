//
//  storyDetailsView.h
//  FollowMe
//
//  Created by scjy on 16/3/21.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface storyDetailsView : UIView
@property(nonatomic, strong) NSDictionary *dataDic;
#pragma mark -------------------- 根据文字最大显示宽高贺文字内容返回高度
- (CGFloat)getTextHeightWithText:(NSString *)text WithBigiestSize:(CGSize)bigSize fontText:(CGFloat)font;
@end
