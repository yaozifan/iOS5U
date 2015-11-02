//
//  LoginViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "LoginViewController.h"
//登陆界面
#import "AFHTTPRequestOperationManager.h"
#import "MyMD5.h"
#import "DBManager.h"
#import "ZCControl.h"
@interface LoginViewController ()<UITextFieldDelegate>
{
    UITextField *userTextField;
    UITextField *passTextField;
    NSString *string;
    //网络请求
    AFHTTPRequestOperationManager *manager;
    DBManager *sqlitManager;

}
@end

@implementation LoginViewController

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
    [self createTextField];
    // Do any additional setup after loading the view.
}
- (void)createNav
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"navigationbar_background.png"] forBarMetrics:UIBarMetricsDefault];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    UIImage *image = [UIImage imageNamed:@"cancel_1.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"cancel_2.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
}
- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createTextField
{
    CGFloat piding = HEIGHT/30;
    CGFloat viewH = 57;
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, piding, WIDTH, viewH)];
    userView.backgroundColor = [UIColor whiteColor];
    UILabel *userLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, viewH/2-8, 100, 17)];
    userLable.text = @"用户名：";
    userLable.font = [UIFont boldSystemFontOfSize:15];
    [userView addSubview:userLable];
  
    userTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, WIDTH, viewH)];
    userTextField.delegate = self;
    userTextField.autocapitalizationType=NO;
    //清除按钮
    userTextField.clearButtonMode=YES;
    userTextField.placeholder = @"5-20个字符";
    [userView addSubview:userTextField];
    [self.view addSubview:userView];
    
    CGFloat passViewY = CGRectGetMaxY(userView.frame)+piding;
    UIView *passView = [[UIView alloc]initWithFrame:CGRectMake(0, passViewY, WIDTH, viewH)];
    passView.backgroundColor = [UIColor whiteColor];
    UILabel *passLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, viewH/2-8, 100, 17)];
    passLable.text = @"密   码：";
    passLable.font = [UIFont boldSystemFontOfSize:15];
    [passView addSubview:passLable];
    
    passTextField = [[UITextField alloc]initWithFrame:CGRectMake(80, 0, WIDTH, viewH)];

    passTextField.delegate = self;
    passTextField.placeholder = @"8-20个字符";
    passTextField.secureTextEntry = YES;
    //首字母大写
    passTextField.autocapitalizationType=NO;
    //清除按钮
    passTextField.clearButtonMode=YES;
    [passView addSubview:passTextField];
    [self.view addSubview:passView];
    
    CGFloat buttonY = CGRectGetMaxY(passView.frame)+piding;
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(piding, buttonY, WIDTH-2*piding, 44);
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
    [button setTitle:@"登    陆" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userTextField) {
        [passTextField becomeFirstResponder];
    }else{
        [passTextField resignFirstResponder];
    }
    return YES;
}
- (void)buttonClick:(UIButton *)button
{
    if (userTextField.text.length>0&&passTextField.text.length>0) {
        NSDictionary *dic = @{@"username":userTextField.text,@"ip":@"192.168.2.2",@"password":[MyMD5 md5:passTextField.text]};
        manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
            [manager POST:@"http://u.api.5usport.com/PHP_works/api/index.php?m=News&a=memberLogin&version=1.0.4" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"success"] boolValue]) {
                    [self createAlert:responseObject[@"msg"]];
                    NSString *userNameString = [NSString stringWithString:userTextField.text];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
                        [dic setObject:userTextField.text forKey:@"username"];
                        sqlitManager = [[DBManager alloc]init];
                        [sqlitManager add_Dic:dic];
                    userTextField.text = nil;
                    passTextField.text = nil;
                    [self.view endEditing:YES];
                    [self dismissViewControllerAnimated:YES completion:nil];
                    if (self.myBlock) {
                        self.myBlock(userNameString);
                    }

                   
                }
                else{
                    [self createAlert:responseObject[@"msg"]];
                   
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败");
                [self createAlert:@"请打开网络"];

            }];
        NSLog(@"~~~%@",[NSThread currentThread]);
        
        

    }else{
        [self createAlert:@"请输入用户名和密码"];
    }
}
- (void)createAlert:(NSString *)msgString
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:msgString delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
