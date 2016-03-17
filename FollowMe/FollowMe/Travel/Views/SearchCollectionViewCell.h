//
//  SearchCollectionViewCell.h
//  FollowMe
//
//  Created by SCJY on 16/3/17.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchModel.h"
@interface SearchCollectionViewCell : UICollectionViewCell
@property(nonatomic, strong) SearchModel *model;
@property(nonatomic, strong) UILabel *title;
@end
