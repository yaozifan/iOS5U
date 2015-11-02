//
//  PicView.m
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "PicView.h"
#import "SportsModel.h"
#import "PicCell.h"
#import "PicDetailViewController.h"

@implementation PicView


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
    self.view.backgroundColor = [UIColor redColor];
    manager = [AFHTTPRequestOperationManager manager];
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
    [header beginRefreshing];
    
    
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
    __weak PicView *vc = self;
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
                    SportsModel *model = [[SportsModel alloc]initWithDic:dic];
                    [self.dataArray addObject:model];
                }
                NSLog(@"%@",self.dataArray);

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"sport";
    PicCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[PicCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    SportsModel *model = self.dataArray[indexPath.row];
    [cell config:model];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SportsModel *model = self.dataArray[indexPath.row];
    PicDetailViewController *vc = [[PicDetailViewController alloc]init];
    vc.news_id = model.news_id;
    [self presentViewController:vc animated:YES completion:nil];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 210;
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
