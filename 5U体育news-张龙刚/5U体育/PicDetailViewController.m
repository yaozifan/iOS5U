//
//  PicDetailViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-25.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "PicDetailViewController.h"
#import "HttpRequestBlock.h"
#import "PicDetaiModel.h"
#import "UIImageView+WebCache.h"
#import "PicDetailView.h"
#import "CommentViewController.h"
#import "UIImageView+ProgressView.h"
@interface PicDetailViewController ()<UIActionSheetDelegate>
{
    PicDetailView *detailView;
    UIImageView *tempImageView;
    UIImageView *photoView;
}
@property (nonatomic,copy)NSString *cat_id;
@property (nonatomic,copy)NSString *webString;
@property (nonatomic,copy)NSString *photoString;
@end

@implementation PicDetailViewController

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
    [self createScrollView];
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

    self.view.backgroundColor = [UIColor blackColor];
    
    [self loadData];

    // Do any additional setup after loading the view.
}
- (void)loadData
{
    if (self.news_id) {
        HttpRequestBlock *request = [[HttpRequestBlock alloc]initWithUrlPath:[NSString stringWithFormat:PICDETAIL,self.news_id] Block:^(BOOL isSucceed, HttpRequestBlock *http) {
            if (isSucceed) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
                NSDictionary *dic = http.dataDic[@"data"];
                self.cat_id = [NSString stringWithString:dic[@"cat_detail_id"]];
                NSArray *array =dic[@"photos"];
                self.photoString = dic[@"news_photo"];
                self.webString = dic[@"news_url"];
                detailView = [[PicDetailView alloc]init];
                detailView.alpha = 0.8;
                detailView.detail = dic[@"news_title"];
                for (NSDictionary *dic1 in array) {
                    PicDetaiModel *model = [[PicDetaiModel alloc]initWithDic:dic1];
                    [self.dataArray addObject:model];
                }
                [self createDetailView];
                [av removeFromSuperview];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [activity stopAnimating];
            }
        }];
        request = nil;

    }
}
- (void)createDetailView
{
    _scrollView.backgroundColor = [UIColor blackColor];
    _scrollView.contentSize = CGSizeMake(WIDTH*self.dataArray.count, HEIGHT-20);
    for (int i = 0; i < self.dataArray.count; i++) {
        PicDetaiModel *model = self.dataArray[i];
        photoView = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, HEIGHT-20)];
        photoView.tag = i;

        [photoView sd_setImageWithURL:[NSURL URLWithString:model.url] placeholderImage:[UIImage imageNamed:@"imagebackground_320.png"] usingProgressView:UIProgressViewStyleDefault];
        photoView.contentMode = UIViewContentModeScaleAspectFit;
        photoView.userInteractionEnabled = YES;
  
        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress:)];
        [photoView addGestureRecognizer:longPress];
        
        
        
        
        [_scrollView addSubview:photoView];
    }
    
    detailView.frame = CGRectMake(0, HEIGHT-70, WIDTH, 70);
    __weak PicDetailViewController *weakSelf = self;

    detailView.talkBlock = ^{
        CommentViewController *vc = [[CommentViewController alloc]init];
        vc.title = @"评论";
       
        vc.newsId = weakSelf.news_id;
        vc.catId = weakSelf.cat_id;
        UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:vc];
        [weakSelf presentViewController:nc1 animated:YES completion:nil];

    };
    detailView.allPage = self.dataArray.count;
    CGPoint point = _scrollView.contentOffset;
    detailView.page = point.x/WIDTH+1;
    [detailView makeUI];
    [detailView loadPage];
    [self.view addSubview:detailView];

}

- (void)createScrollView
{
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 20, WIDTH, HEIGHT-20)];
    _scrollView.backgroundColor = [UIColor grayColor];
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    _scrollView.contentSize = CGSizeMake(WIDTH*self.dataArray.count, HEIGHT-20);
    _scrollView.contentOffset = CGPointMake(0, 0);
    [self.view addSubview:_scrollView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap addTarget:self action:@selector(tapClick:)];
    [_scrollView addGestureRecognizer:tap];
    photoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-20)];
    photoView.contentMode = UIViewContentModeScaleAspectFit;
    [_scrollView addSubview:photoView];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        CGPoint point = scrollView.contentOffset;
        NSInteger x = (NSInteger)point.x/WIDTH;
        x = x+1;
        detailView.page = x;
        [detailView loadPage];
    }

}
- (void)tapClick:(UITapGestureRecognizer *)tap
{
    if (tap.state == UIGestureRecognizerStateBegan) return;
    [self dismissViewControllerAnimated:YES completion:nil];

}
//保存到相册
- (void)longPress:(UILongPressGestureRecognizer*)longPress
{
    if (longPress.state != UIGestureRecognizerStateBegan) return;
    tempImageView = (UIImageView *)longPress.view;
    UIActionSheet *sheet = [[UIActionSheet alloc]initWithTitle:@"保存照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存照片", nil];
    [sheet showInView:self.view];
    
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (!buttonIndex) {
        if (tempImageView) {
            UIImageWriteToSavedPhotosAlbum(tempImageView.image, nil, nil, nil);
        }
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
