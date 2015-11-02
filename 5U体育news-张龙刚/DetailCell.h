//
//  DetailCell.h
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CellFrame;

@interface DetailCell : UITableViewCell
{
    UILabel *textLable;
    UILabel *titltLable;
    UILabel *dateLable;
    UIImageView *photoImageView;

}
@property (nonatomic,strong)CellFrame *cellFrame;
@end
