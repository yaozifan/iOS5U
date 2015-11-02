//
//  OtherViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "OtherViewController.h"
#import "LoginViewController.h"
#import "IdViewController.h"
#import "DBManager.h"
@interface OtherViewController ()<UIAlertViewDelegate>
{
    UILabel *loginLable;
    UILabel *idLable;
    DBManager *sqlitManager;
}
@end

@implementation OtherViewController

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
    self.view.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:0.8];
    [self createNav];
    [self createButtons];
    // Do any additional setup after loading the view.
}
- (void)createNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    NSLog(@"11%@",[NSUserDefaults standardUserDefaults]);
    
}
- (void)createButtons
{
    CGFloat piding = HEIGHT/24;
    CGFloat viewH = 57;
    UIView *loginView = [[UIView alloc]initWithFrame:CGRectMake(0, piding, WIDTH, viewH)];
    loginView.backgroundColor = [UIColor whiteColor];
    loginLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, viewH/2-8, 100, 17)];
    loginLable.textColor = [UIColor blackColor];
    sqlitManager = [DBManager shareManager];

    NSMutableArray *mutableArray = [sqlitManager loadData];
    if (mutableArray.count) {
        NSArray *userDataArray = [NSArray arrayWithArray:[mutableArray firstObject]];
        loginLable.text = userDataArray[3];
        loginLable.textColor = [UIColor orangeColor];

    }
    else{
        loginLable.text = @"会员登陆";
    }

    
    
    loginLable.font = [UIFont boldSystemFontOfSize:17];
    [loginView addSubview:loginLable];
    UIImageView *loginImageView = [ZCControl createImageViewFrame:CGRectMake(WIDTH-40, viewH/2-8, 17, 17) imageName:@"next_default.png"];
    [loginView addSubview:loginImageView];
    UIControl *loginControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, viewH)];
    [loginControl addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [loginView addSubview:loginControl];
    [self.view addSubview:loginView];
    
    
    
    CGFloat idViewY = CGRectGetMaxY(loginView.frame)+piding;
    UIView *idView = [[UIView alloc]initWithFrame:CGRectMake(0, idViewY, WIDTH, viewH)];
    idView.backgroundColor = [UIColor whiteColor];
    idLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, viewH/2-8, 100, 17)];
    idLable.text = @"会员注册";
    idLable.font = [UIFont boldSystemFontOfSize:17];
    [idView addSubview:idLable];
    UIImageView *idImageView = [ZCControl createImageViewFrame:CGRectMake(WIDTH-40, viewH/2-8, 17, 17) imageName:@"next_default.png"];
    [idView addSubview:idImageView];
    UIControl *idControl = [[UIControl alloc]initWithFrame:CGRectMake(0, 0, WIDTH, viewH)];
    [idControl addTarget:self action:@selector(idClick) forControlEvents:UIControlEventTouchUpInside];
    [idView addSubview:idControl];
    [self.view addSubview:idView];
    
}
- (void)loginClick
{
    if ([loginLable.text isEqualToString:@"会员登陆"]) {
        LoginViewController *vc = [[LoginViewController alloc]init];
        vc.title = @"登陆";
        vc.myBlock = ^(NSString *userName){
            loginLable.text = userName;
            loginLable.textColor = [UIColor orangeColor];
        };
        UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
        
        [self presentViewController:nc animated:YES completion:nil];

    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"你确定要退出当前登陆吗？" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        alert.delegate = self;
        [alert show];

    }

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex) {
            loginLable.text = @"会员登陆";
        loginLable.textColor = [UIColor blackColor];
            sqlitManager = [DBManager shareManager];
            [sqlitManager deleteData];
    }
}
- (void)idClick
{
        IdViewController *vc = [[IdViewController alloc]init];
    vc.title = @"注册";
    vc.myBlock = ^(NSString *userName){
        loginLable.text = userName;
    };
    UINavigationController *nc = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nc animated:YES completion:nil];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
