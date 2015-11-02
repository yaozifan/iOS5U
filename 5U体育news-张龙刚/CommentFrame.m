//
//  CommentFrame.m
//  5U体育
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "CommentFrame.h"
#import "CommentModel.h"
@implementation CommentFrame
- (void)setCommentModel:(CommentModel *)commentModel
{
    _commentModel = commentModel;
    CGFloat piding = 5;
    _idFrame = CGRectMake(piding, piding, 100, 13);
    _dateFrame = CGRectMake(WIDTH-150, piding, 150, 13);
    CGSize size = [commentModel.news_content boundingRectWithSize:CGSizeMake(WIDTH-piding*2 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
    CGFloat textW = size.width;
    CGFloat textH = size.height;
    
    _textFrame = CGRectMake(piding, 20, textW, textH);
    _cellHeight = CGRectGetMaxY(_textFrame)+piding;
}
@end
