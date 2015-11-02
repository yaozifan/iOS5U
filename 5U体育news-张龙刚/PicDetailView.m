//
//  PicDetailView.m
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "PicDetailView.h"
@implementation PicDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor grayColor];
    }
    return self;
}
- (void)makeUI
{
    CGFloat piding = 30;
    
    detailLable = [[UILabel alloc]init];
    detailLable.textColor = [UIColor whiteColor];
    detailLable.numberOfLines = 0;
    detailLable.font = [UIFont boldSystemFontOfSize:13];
    CGSize size1 = [self.detail boundingRectWithSize:CGSizeMake(WIDTH-piding*2 , MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:13]} context:nil].size;
    detailLable.frame = CGRectMake(piding, 0, size1.width, size1.height);
    detailLable.text = self.detail;
    [self addSubview:detailLable];
    CGFloat pageLableY = CGRectGetMaxY(detailLable.frame);
    talkButton = [ZCControl createButtonWithFrame:CGRectMake(piding+20, pageLableY, 34, 44) title:nil imageName:@"comment_1.png" bgImageName:nil target:self method:@selector(talkButton:)];
     [self addSubview:talkButton];
    [talkButton setBackgroundImage:[UIImage imageNamed:@"comment_1.png"] forState:UIControlStateHighlighted];
//    CGFloat shareX = CGRectGetMaxX(talkButton.frame)+piding/2;
//    shareButton = [ZCControl createButtonWithFrame:CGRectMake(shareX, pageLableY, 34, 44) title:nil imageName:@"share_default.png" bgImageName:nil target:self method:@selector(shareButton:)];
//
//    [self addSubview:shareButton];

}
- (void)talkButton:(UIButton *)button
{
    if (self.talkBlock) {
        self.talkBlock();
    }

}
//- (void)shareButton:(UIButton *)button
//{
//    
//    if (self.shareBlock) {
//        self.shareBlock();
//    }
//    
//}
- (void)loadPage
{
    if (pageLable.text) {
        [pageLable removeFromSuperview];
    }

    CGFloat pageLableY = CGRectGetMaxY(detailLable.frame)+15;
    pageLable = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH-80, pageLableY, 40, 15)];
    pageLable.font = [UIFont boldSystemFontOfSize:13];
        pageLable.text = [NSString stringWithFormat:@"%ld/%ld",(long)self.page,(long)self.allPage];
    pageLable.textColor = [UIColor whiteColor];
    [self addSubview:pageLable];

}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
