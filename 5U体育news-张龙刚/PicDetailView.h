//
//  PicDetailView.h
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailView : UIView
{
    UILabel *detailLable;
    UILabel *pageLable;
    UIButton *talkButton;
//    UIButton *shareButton;
}
//@property (nonatomic,copy)void(^shareBlock)();
@property (nonatomic,copy)void(^talkBlock)();

@property (nonatomic,copy)NSString *detail;
@property (nonatomic,assign)NSInteger allPage;
@property (nonatomic,assign)NSInteger page;
- (void)makeUI;
- (void)loadPage;
@end
