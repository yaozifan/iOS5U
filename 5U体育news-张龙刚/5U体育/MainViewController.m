//
//  MainViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "MainViewController.h"
#import "SportViewController.h"
#import "PictureViewController.h"
#import "OtherViewController.h"
@interface MainViewController ()

@end

@implementation MainViewController

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
    [self createViewController];
    [self createTabBar];
    // Do any additional setup after loading the view.
}
- (void)createViewController
{
    SportViewController *vc1 = [[SportViewController alloc]init];
    UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:vc1];
    PictureViewController *vc2 = [[PictureViewController alloc]init];
    vc2.title = @"图库";
    UINavigationController *nc2 = [[UINavigationController alloc]initWithRootViewController:vc2];
    OtherViewController *vc3 = [[OtherViewController alloc]init];
    vc3.title = @"其他";
    UINavigationController *nc3 = [[UINavigationController alloc]initWithRootViewController:vc3];
    self.viewControllers = @[nc1,nc2,nc3];
}
- (void)createTabBar
{
    NSArray *selectImageArray = @[@"tabbar_news_hightlight.png",@"tabbar_picture_hightlight.png",@"tabbar_setup_hightlighted.png"];
    NSArray *unSelectImageArray = @[@"tabbar_news_default.png",@"tabbar_picture_default.png",@"tabbar_setup_default.png"];
    
    for (int i = 0; i<self.tabBar.items.count; i++) {
        UITabBarItem *item = self.tabBar.items[i];
        
        UIImage *selectImage = [UIImage imageNamed:selectImageArray[i]];
        selectImage = [selectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        UIImage *unSelectImage = [UIImage imageNamed:unSelectImageArray[i]];
        unSelectImage = [unSelectImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        item = [item initWithTitle:nil image:unSelectImage selectedImage:selectImage];
//        item.imageInsets = UIEdgeInsetsMake(0, 0, -6, 0);
    }
    
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"MicroBlog_ToolBar.png"]];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
