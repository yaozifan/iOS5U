//
//  CommentCell.m
//  5U体育
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "CommentCell.h"
#import "CommentModel.h"
@implementation CommentCell

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
    idLable = [[UILabel alloc]init];
    idLable.font = [UIFont boldSystemFontOfSize:13];
    idLable.textColor = [UIColor orangeColor];
    [self.contentView addSubview:idLable];
    dateLabel = [[UILabel alloc]init];
    dateLabel.font = [UIFont systemFontOfSize:13];
    [self.contentView addSubview:dateLabel];
    textLable = [[UILabel alloc]init];
    textLable.numberOfLines = 0;
    textLable.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:textLable];
}
- (void)setCommentFrame:(CommentFrame *)commentFrame
{
    _commentFrame = commentFrame;
    CommentModel *model = commentFrame.commentModel;
    idLable.text = model.username;
    idLable.frame = commentFrame.idFrame;
    dateLabel.text = model.creat_at;
    dateLabel.frame = commentFrame.dateFrame;
    textLable.text = model.news_content;
    textLable.frame = commentFrame.textFrame;
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
