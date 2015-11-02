//
//  PictureViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "PictureViewController.h"
#import "PicView.h"
#import "SCNavTabBarController.h"
@interface PictureViewController ()<UIScrollViewDelegate>

@end

@implementation PictureViewController

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
    [self createNav];
    [self createViewController];
    // Do any additional setup after loading the view.
}
- (void)createNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];

}
- (void)createViewController
{
    NSArray *arr = @[TUKUREMEN,TUKUZUQIU,TUKULANQIU,TUKUXINGGAN,TUKUZONGHE,TUKUMINGXING];
    NSArray *array = @[@"热门",@"足球",@"篮球",@"性感",@"综合",@"明星"];
    
    
    PicView *vc1 = [[PicView alloc]init];
    vc1.urlStr = arr[0];
    vc1.title = array[0];
    
    PicView *vc2 = [[PicView alloc]init];
    vc2.urlStr = arr[1];
    vc2.title = array[1];
    
    PicView *vc3 = [[PicView alloc]init];
    vc3.urlStr = arr[2];
    vc3.title = array[2];
    
    PicView *vc4 = [[PicView alloc]init];
    vc4.urlStr = arr[3];
    vc4.title = array[3];
    
    PicView *vc5 = [[PicView alloc]init];
    vc5.urlStr = arr[4];
    vc5.title = array[4];
    
    PicView *vc6 = [[PicView alloc]init];
    vc6.urlStr = arr[5];
    vc6.title = array[5];

   
       
    SCNavTabBarController *nav = [[SCNavTabBarController alloc]init];
    nav.subViewControllers = @[vc1,vc2,vc3,vc4,vc5,vc6];
    nav.showArrowButton = NO;
    [nav addParentController:self];
    

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
