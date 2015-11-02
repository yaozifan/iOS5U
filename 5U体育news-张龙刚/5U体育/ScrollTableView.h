//
//  ScrollTableView.h
//  5U体育
//
//  Created by qianfeng on 15-1-22.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"
#import "HttpRequestBlock.h"
@interface ScrollTableView : UIViewController<UITableViewDataSource,UITableViewDelegate>
{
     NSInteger page;
    UITableView *_tableView;
    MJRefreshHeaderView *header;  
    MJRefreshFooterView *footer;
    //加载的控件
    UIView *av;
    UIActivityIndicatorView * activity;
}
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,copy)void(^pushViewController)(NSString *);
@property (nonatomic,copy)NSString *urlStr;
@end
