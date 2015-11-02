//
//  PicDetailViewController.h
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PicDetailViewController : UIViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    //加载的控件
    UIView *av;
    UIActivityIndicatorView * activity;
}
@property (nonatomic,copy)NSString *news_id;
@property (nonatomic,strong)NSMutableArray *dataArray;
@end
