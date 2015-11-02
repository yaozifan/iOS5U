//
//  PicCell.h
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SportsModel;
@interface PicCell : UITableViewCell
{
    UIImageView *photoImageView;
    UILabel *titleLable;
}
- (void)config:(SportsModel *)model;
@end
