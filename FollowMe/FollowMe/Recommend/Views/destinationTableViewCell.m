//
//  destinationTableViewCell.m
//  FollowMe
//
//  Created by scjy on 16/3/25.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "destinationTableViewCell.h"

@implementation destinationTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
- (void)setModel:(destination *)model{
    self.cityName.text = model.cityName;
    self.country.text = model.countryName;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
