//
//  PicCell.m
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "PicCell.h"
#import "SportsModel.h"
#import "UIImageView+WebCache.h"
@implementation PicCell

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
    CGFloat picH = 200;
    CGFloat piding = 20;
    UIImageView *bg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, 210)];
    UIImage *image = [UIImage imageNamed:@"leftside_shadow_bg.png"];
    image = [image stretchableImageWithLeftCapWidth:9 topCapHeight:9];
    bg.image = image;
    [self.contentView addSubview:bg];
    photoImageView = [ZCControl createImageViewFrame:CGRectMake(piding, 0, WIDTH-2*piding, picH) imageName:nil];
 
    [self.contentView addSubview:photoImageView];
    titleLable = [ZCControl createLabelWithFrame:CGRectMake(piding, picH-20, WIDTH-40, 20) font:10 text:nil];
    titleLable.alpha = 0.5;
    titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor grayColor];
    titleLable.font = [UIFont boldSystemFontOfSize:13];
    [self.contentView addSubview:titleLable];
}


- (void)config:(SportsModel *)model
{
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.news_photo]placeholderImage:[UIImage imageNamed:@"imagebackground_280.png"]];
    titleLable.text = model.news_title;

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
