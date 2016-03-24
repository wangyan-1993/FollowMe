//
//  CollectionReusableView.m
//  FollowMe
//
//  Created by SCJY on 16/3/24.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "CollectionReusableView.h"

@implementation CollectionReusableView
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btn.frame = self.frame;

        [self addSubview:self.btn];
    }
    return self;
}
//- (UIButton *)btn{
//    if (_btn == nil) {
//        self.btn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.btn.frame = self.frame;
//    }
//    return _btn;
//}



@end
