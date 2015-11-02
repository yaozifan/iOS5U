//
//  CommentCell.h
//  5U体育
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentFrame.h"
@interface CommentCell : UITableViewCell
{
    UILabel *idLable;
    UILabel *dateLabel;
    UILabel *textLable;
}
@property (nonatomic,strong)CommentFrame *commentFrame;
@end
