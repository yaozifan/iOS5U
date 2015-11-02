//
//  CellFram.m
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "CellFrame.h"
#import "DetailModel.h"
@implementation CellFrame

- (void)setModel:(DetailModel *)model
{
    _model = model;
    CGFloat piding = 10;
    CGSize size = [model.news_title boundingRectWithSize:CGSizeMake(WIDTH-piding*2 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:15]} context:nil].size;
    CGFloat titleW = size.width;
    CGFloat titleH = size.height;
    
    _titltLableFrame = CGRectMake(piding, piding, titleW, titleH);
    
    CGFloat dateY = CGRectGetMaxY(_titltLableFrame)+piding;
    _dateLableFrame = CGRectMake(piding, dateY, WIDTH, 10);
    
    CGFloat photoImageViewY = CGRectGetMaxY(_dateLableFrame)+piding;
    _photoImageViewFrame = CGRectMake(2*piding, photoImageViewY, WIDTH-40, 210);
    
    CGFloat textViewY = CGRectGetMaxY(_photoImageViewFrame)+piding;
    CGSize size1 = [model.news_content boundingRectWithSize:CGSizeMake(WIDTH-piding*2 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} context:nil].size;
    CGFloat textW = size1.width;
    CGFloat textH = size1.height;
    _textLableFrame = CGRectMake(piding, textViewY, textW, textH);
    _cellHeight = CGRectGetMaxY(_textLableFrame)+piding;
}

@end
