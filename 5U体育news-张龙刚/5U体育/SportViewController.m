//
//  SportViewController.m
//  5U体育
//
//  Created by qianfeng on 15-1-20.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "SportViewController.h"
#import "SCNavTabBarController.h"
#import "ScrollTableView.h"
#import "DetailViewController.h"

@interface SportViewController ()
{
}
@end

@implementation SportViewController

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

    UIImageView *logoView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 60, 30)];
    logoView.image = [UIImage imageNamed:@"usport_logo.png"];
    self.navigationItem.titleView = logoView;
}

- (void)createViewController
{
    NSArray *arr = @[TOUTIAO,ZUQIU,LANQIU,ZONGHE];
    NSArray *array = @[@"头条",@"足球",@"篮球",@"综合"];
    ScrollTableView *vc1 = [[ScrollTableView alloc]init];
    vc1.urlStr = arr[0];
    vc1.title = array[0];
    ScrollTableView *vc2 = [[ScrollTableView alloc]init];
    vc2.urlStr = arr[1];
    vc2.title = array[1];
    ScrollTableView *vc3 = [[ScrollTableView alloc]init];
    vc3.urlStr = arr[2];
    vc3.title = array[2];
    ScrollTableView *vc4 = [[ScrollTableView alloc]init];
    vc4.urlStr = arr[3];
    vc4.title = array[3];
    SCNavTabBarController *nav = [[SCNavTabBarController alloc]init];
    nav.subViewControllers = @[vc1,vc2,vc3,vc4];
    nav.showArrowButton = NO;
    [nav addParentController:self];

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
