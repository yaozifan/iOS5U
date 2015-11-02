//
//  ScrollTableView.m
//  5U体育
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "ScrollTableView.h"
#import "SportsCell.h"
#import "UIImageView+WebCache.h"
#import "SportsModel.h"
#import "DetailViewController.h"
@implementation ScrollTableView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    [self createTableView];
    av = [[UIView alloc]initWithFrame:CGRectMake(WIDTH/2-50, HEIGHT/2-130, 100, 100)];
    av.backgroundColor = [UIColor grayColor];
    av.layer.cornerRadius = 5;
    av.layer.masksToBounds = YES;
    [self.view addSubview:av];
    activity = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    activity.hidden = NO;
    activity.color = [UIColor whiteColor];
    activity.transform = CGAffineTransformMakeScale(1.5, 1.5);
    CGPoint point = CGPointMake(WIDTH/2, HEIGHT/2-100);
    activity.center = point;
    [activity startAnimating];
    [self.view addSubview:activity];
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 60, 60, 20)];
    label.text = @"正在加载";
    label.font = [UIFont boldSystemFontOfSize:15];
    label.textColor = [UIColor whiteColor];
    [av addSubview:label];
    [self createRefresh];

    // Do any additional setup after loading the view.
}


- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-49-64-30) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

}
- (void)createRefresh
{
    
    header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    __weak ScrollTableView *vc = self;
    NSInteger *page1 = &page;
    header.beginRefreshingBlock = ^(MJRefreshBaseView *view){
        (*page1) = 1;
        [vc loadData];
    };
    footer = [MJRefreshFooterView footer];
    footer.scrollView = _tableView;
    footer.beginRefreshingBlock = ^(MJRefreshBaseView *view){
        (*page1)++;
        [vc loadData];
    };
    [header beginRefreshing];

}
- (void)loadData
{
    if(self.urlStr){
       HttpRequestBlock *request = [[HttpRequestBlock alloc]initWithUrlPath:[NSString stringWithFormat:self.urlStr,page] Block:^(BOOL isSucceed, HttpRequestBlock *http) {
        if (isSucceed) {
            NSArray *arr = http.dataDic[@"data"];
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
            }
            for (NSMutableDictionary *dic in arr) {
                NSMutableString *str = [NSMutableString stringWithString:dic[@"news_photo"]];
                NSString *string = @"www.usportnews.com/PHP_works/apihttp://";
                NSRange range = [str rangeOfString:string];
                if (range.location != NSNotFound) {
                    [str deleteCharactersInRange:range];
                }
                [dic setValue:str forKey:@"news_photo"];
                SportsModel *model = [[SportsModel alloc]initWithDic:dic];
                [self.dataArray addObject:model];
            }
            
            [_tableView reloadData];
            [av removeFromSuperview];
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            [activity stopAnimating];
            if (page == 1) {
                [header endRefreshing];

            }
            else{
                [footer endRefreshing];
            }

        }
    }];
      request = nil;
    }
  
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count - 1;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"sport";
    SportsCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SportsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SportsModel *model = self.dataArray[indexPath.row+1];
    [cell config:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SportsModel *model = self.dataArray[indexPath.row+1];
    DetailViewController *vc = [[DetailViewController alloc]init];
    vc.news_id = model.news_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
    
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    CGFloat picH = 160;
    UIView *bg = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, picH)];
    UIControl *bgControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, picH)];
   
    [bgControl addTarget:self action:@selector(buttonClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView *photoImageView = [ZCControl createImageViewFrame:CGRectMake(0, 0, WIDTH, picH) imageName:@"imagebackground_320.png"];
    [bg addSubview:photoImageView];
    UILabel *titleLable = [ZCControl createLabelWithFrame:CGRectMake(0, picH-30, WIDTH, 30) font:10 text:nil];
    titleLable.alpha = 0.8;
    titleLable.numberOfLines = 0;
    titleLable.textColor = [UIColor whiteColor];
    titleLable.backgroundColor = [UIColor blackColor];
    titleLable.font = [UIFont boldSystemFontOfSize:13];
    [bg addSubview:titleLable];
    SportsModel *model = [self.dataArray firstObject];
    [photoImageView sd_setImageWithURL:[NSURL URLWithString:model.news_photo]placeholderImage:[UIImage imageNamed:@"imagebackground_320.png"]];
    titleLable.text = model.news_title;
    titleLable.lineBreakMode = NSLineBreakByTruncatingTail;
    [bg addSubview:bgControl];
    return bg;
}
- (void)buttonClick
{
    SportsModel *model = [self.dataArray firstObject];
    DetailViewController *vc = [[DetailViewController alloc]init];
    vc.news_id = model.news_id;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 160;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)dealloc
{
    [header free];
    [footer free];
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
