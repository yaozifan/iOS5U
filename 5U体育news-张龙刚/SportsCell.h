//
//  SportsCell.h
//  体坛周报Product
//
//  Created by qianfeng on 15-1-18.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SportsModel;
@interface SportsCell : UITableViewCell
{
    UILabel *textLable;
    UILabel *dateLable;
    UIImageView *imageView;
    UIImageView *littleView;
}
- (void)config:(SportsModel *)model;
@end
