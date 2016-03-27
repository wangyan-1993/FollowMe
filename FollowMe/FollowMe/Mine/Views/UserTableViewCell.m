//
//  UserTableViewCell.m
//  FollowMe
//
//  Created by SCJY on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self config];
    }
    return  self;
}
- (void)config{
    [self addSubview:self.label];
    [self addSubview:self.label1];

}

- (UILabel *)label{
    if (_label == nil) {
        self.label = [[UILabel alloc]initWithFrame:CGRectMake(kWidth-150, 0, 120, 44)];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.textColor = [UIColor darkGrayColor];
//        self.label.backgroundColor = [UIColor redColor];

    }
    return _label;
}
- (UILabel *)label1{
    if (_label1 == nil) {
        self.label1 = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 150, 44)];
        self.label1.textAlignment = NSTextAlignmentLeft;
//        self.label1.backgroundColor = [UIColor redColor];
        
    }
    return _label1;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
