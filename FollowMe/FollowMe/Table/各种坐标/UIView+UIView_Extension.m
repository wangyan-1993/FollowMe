//
//  UIView+UIView_Extension.m
//  HeeHeeWeak
//
//  Created by scjy on 16/1/7.
//  Copyright © 2016年 张衡. All rights reserved.
//

#import "UIView+UIView_Extension.h"

@implementation UIView (UIView_Extension)

- (CGFloat)left
{
    return self.frame.origin.x;
}

- (CGFloat)top
{
    return self.frame.origin.y;
}

- (CGFloat)right
{
    return self.frame.origin.x + self.frame.size.width;
}

- (CGFloat)bottom
{
    return self.frame.origin.y + self.frame.size.height;
}

- (CGFloat)width
{
    return self.frame.size.width;
}

- (CGFloat)height
{
    return self.frame.size.height;
}

- (void)removeAllSubviews
{
    while (self.subviews.count)
    {
        UIView *child = self.subviews.lastObject;
        [child removeFromSuperview];
    }
}

@end
