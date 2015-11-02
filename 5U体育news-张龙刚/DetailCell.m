//
//  DetailCell.m
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "DetailCell.h"
#import "DetailModel.h"
#import "CellFrame.h"
#import "UIImageView+WebCache.h"
@implementation DetailCell

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
    titltLable = [[UILabel alloc]init];
    titltLable.font = [UIFont boldSystemFontOfSize:15];
    titltLable.numberOfLines = 0;
    [self.contentView addSubview:titltLable];
    dateLable = [[UILabel alloc]init];
    dateLable.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:dateLable];
    textLable = [[UILabel alloc]init];
    textLable.numberOfLines = 0;
    [self.contentView addSubview:textLable];
    textLable.font = [UIFont systemFontOfSize:15];
    photoImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"imagebackground_280.png"]];
    photoImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self.contentView addSubview:photoImageView];

}
- (void)setCellFrame:(CellFrame *)cellFrame
{
    _cellFrame = cellFrame;
    DetailModel *model = cellFrame.model;
    titltLable.frame = self.cellFrame.titltLableFrame;
    titltLable.text = model.news_title;
    dateLable.text = model.news_date;
    dateLable.frame = self.cellFrame.dateLableFrame;
    photoImageView.frame = self.cellFrame.photoImageViewFrame;
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.news_photo]placeholderImage:[UIImage imageNamed:@"imagebackground_280.png"]];
    textLable.frame = self.cellFrame.textLableFrame;
    textLable.text = model.news_content;

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
