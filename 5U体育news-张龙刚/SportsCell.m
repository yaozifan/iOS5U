//
//  SportsCell.m
//  体坛周报Product
//
//  Created by qianfeng on 15-1-18.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "SportsCell.h"
#import "SportsModel.h"
#import "UIImageView+WebCache.h"
@implementation SportsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
- (void)makeUI
{
    CGFloat spacing = 5;
    textLable = [ZCControl createLabelWithFrame:CGRectMake(spacing, spacing, WIDTH-110, 40) font:15 text:nil];
    textLable.font = [UIFont boldSystemFontOfSize:15];
    textLable.numberOfLines = 0;
    [self.contentView addSubview:textLable];
    CGFloat dateY = CGRectGetMaxY(textLable.frame)+spacing;
    dateLable = [ZCControl createLabelWithFrame:CGRectMake(spacing, dateY, WIDTH, 15) font:10 text:nil];
    [self.contentView addSubview:dateLable];
    CGFloat viewH = 80;
    imageView = [ZCControl createImageViewFrame:CGRectMake(CGRectGetMaxX(textLable.frame)+spacing, spacing, viewH,viewH-20 ) imageName:nil];
    [self.contentView addSubview:imageView];
    littleView = [ZCControl createImageViewFrame:CGRectMake(WIDTH-15, 34, 10, 12) imageName:@"newsarticle_indicator.png"];
    [self.contentView addSubview:littleView];
}
- (void)config:(SportsModel *)model
{
    if (model) {
        textLable.text = model.news_title;
        dateLable.text = model.news_date;
        [imageView sd_setImageWithURL:[NSURL URLWithString:model.news_photo]placeholderImage:[UIImage imageNamed:@"imagebackground_80@2x.png"]];
    }
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
