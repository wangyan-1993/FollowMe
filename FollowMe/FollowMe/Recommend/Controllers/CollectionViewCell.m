//
//  CollectionViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/16.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "CollectionViewCell.h"
@interface CollectionViewCell()

@end
@implementation CollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
       
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    self.nameImageView.layer.masksToBounds = YES;
    //设置为图片宽度的一半
    self.nameImageView.layer.cornerRadius =  27/2.0f;
}

@end
