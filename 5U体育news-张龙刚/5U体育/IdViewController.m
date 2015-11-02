//
//  IdViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-29.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "IdViewController.h"
//注册页面
#import "AFHTTPRequestOperationManager.h"
#import "DutyViewController.h"
#import "MyMD5.h"
#import "DBManager.h"
#define TEXTFIELDX 100
@interface IdViewController ()<UITextFieldDelegate>
{
    UITextField *userTextField;
    UITextField *passTextField;
    UITextField *passTextField1;
    UITextField *emailTextField;
    //免责声明的说明
    UILabel *dutyLable;
    //免责声明的button
    UIButton *dutyButton;
    DBManager *sqlitManager;
    //网络请求
    AFHTTPRequestOperationManager *manager;
}
@end

@implementation IdViewController

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
    CGFloat piding = 10;
    CGFloat pidingY = 1;
    CGFloat VIEWW = HEIGHT/12;
    UIView *userView = [[UIView alloc]initWithFrame:CGRectMake(0, piding, WIDTH, VIEWW)];
    userView.backgroundColor = [UIColor whiteColor];
    UILabel *userLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, VIEWW/2-8, TEXTFIELDX, 17)];
    userLable.text = @"用  户  名:";
    userLable.font = [UIFont boldSystemFontOfSize:15];
    [userView addSubview:userLable];
    
    userTextField = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELDX, 0, WIDTH-TEXTFIELDX, VIEWW)];
    userTextField.placeholder = @"5-20个字符";
    userTextField.autocapitalizationType=NO;
    userTextField.delegate = self;
    [userView addSubview:userTextField];
    [self.view addSubview:userView];
    
    
    
    CGFloat passViewY = CGRectGetMaxY(userView.frame)+pidingY;
    UIView *passView = [[UIView alloc]initWithFrame:CGRectMake(0, passViewY, WIDTH, VIEWW)];
    passView.backgroundColor = [UIColor whiteColor];
    UILabel *passLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, VIEWW/2-8, TEXTFIELDX, 17)];
    passLable.text = @"密       码:";
    passLable.font = [UIFont boldSystemFontOfSize:15];
    [passView addSubview:passLable];
    passTextField = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELDX, 0, WIDTH-TEXTFIELDX, VIEWW)];
    passTextField.placeholder = @"8-20个字符";
    passTextField.secureTextEntry = YES;
    passTextField.autocapitalizationType=NO;
    passTextField.delegate = self;
    [passView addSubview:passTextField];
    [self.view addSubview:passView];
    
    CGFloat passView1Y = CGRectGetMaxY(passView.frame)+pidingY;
    UIView *passView1 = [[UIView alloc]initWithFrame:CGRectMake(0, passView1Y, WIDTH, VIEWW)];
    passView1.backgroundColor = [UIColor whiteColor];
    UILabel *passLable1 = [[UILabel alloc]initWithFrame:CGRectMake(piding, VIEWW/2-8, TEXTFIELDX, 17)];
    passLable1.text = @"确认密码:";
    passLable1.font = [UIFont boldSystemFontOfSize:15];
    [passView1 addSubview:passLable1];
    passTextField1 = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELDX, 0, WIDTH-TEXTFIELDX, VIEWW)];
    passTextField1.placeholder = @"8-20个字符";
    passTextField1.secureTextEntry = YES;
    passTextField1.autocapitalizationType=NO;
    passTextField1.delegate = self;
    [passView1 addSubview:passTextField1];
    [self.view addSubview:passView1];

    CGFloat emailViewY = CGRectGetMaxY(passView1.frame)+pidingY;
    UIView *emailView = [[UIView alloc]initWithFrame:CGRectMake(0, emailViewY, WIDTH, VIEWW)];
    emailView.backgroundColor = [UIColor whiteColor];
    UILabel *emailLable = [[UILabel alloc]initWithFrame:CGRectMake(piding, VIEWW/2-8, 100, 17)];
    emailLable.text = @"邮       箱:";
    emailLable.font = [UIFont boldSystemFontOfSize:15];
    [emailView addSubview:emailLable];
    emailTextField = [[UITextField alloc]initWithFrame:CGRectMake(TEXTFIELDX, 0, WIDTH-TEXTFIELDX, VIEWW)];
    emailTextField.placeholder = @"e-mail格式";
    emailTextField.autocapitalizationType=NO;
    emailTextField.delegate = self;
    [emailView addSubview:emailTextField];
    [self.view addSubview:emailView];
    
    
    
    //免责声明
    CGFloat dutyLableY = CGRectGetMaxY(emailView.frame)+piding;
    dutyLable = [ZCControl createLabelWithFrame:CGRectMake(piding+50, dutyLableY, 50, 10) font:7 text:@"注册即表示同意"];
    dutyLable.textColor = [UIColor grayColor];
    [self.view addSubview:dutyLable];
    //免责button
    dutyButton = [ZCControl createButtonWithFrame:CGRectMake(piding*2+100, dutyLableY, 100, 10) title:@"<5U体育免责声明>" imageName:nil bgImageName:nil target:self method:@selector(dutyClick)];
  
    dutyButton.titleLabel.font = [UIFont systemFontOfSize:7];
    [dutyButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:dutyButton];

    
    
    CGFloat buttonY = CGRectGetMaxY(dutyButton.frame)+piding;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(piding, buttonY, WIDTH-2*piding, 44);
    button.backgroundColor = [UIColor redColor];
    [button setTitleColor:[UIColor orangeColor] forState:UIControlStateHighlighted];
      [button setTitle:@"注     册" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)dutyClick
{
    DutyViewController *vc = [[DutyViewController alloc]init];
    vc.title = @"5U体育用户注册协议";
    [self.navigationController pushViewController:vc animated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField == userTextField) {
        [passTextField becomeFirstResponder];
    }else if (textField == passTextField){
        [passTextField1 becomeFirstResponder];
    }else if (textField == passTextField1){
        [emailTextField becomeFirstResponder];
    }else{
        [emailTextField resignFirstResponder];
    }
    return YES;
}
- (void)buttonClick:(UIButton *)button
{
     if (userTextField.text.length<5)
    {
        [self createAlert:@"用户名至少为5个字符"];
    }
    else if (passTextField.text.length<8)
    {
        [self createAlert:@"密码至少为8个字符"];
    }

    else if (![passTextField.text isEqualToString:passTextField1.text]) {
        [self createAlert:@"两个输入的密码不一致"];
    }
    else if (!([emailTextField.text hasSuffix:@".com"]&&([emailTextField.text rangeOfString:@"@"].location!=NSNotFound)))
    {
        [self createAlert:@"邮箱的格式不正确"];
    }
        else {
            NSDictionary *dic = @{@"password":[MyMD5 md5:passTextField.text],@"username":userTextField.text,@"email":[emailTextField.text stringByReplacingOccurrencesOfString:@"@" withString:@"%40"],@"regip":@"192.168.2.2"};
            manager = [AFHTTPRequestOperationManager manager];
        
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
                [manager POST:@"http://u.api.5usport.com/PHP_works/api/index.php?m=News&a=memberRegister&version=1.0.4?" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    if ([responseObject[@"success"] intValue]) {
                        NSString *userNameString = [NSString stringWithString:userTextField.text];
                        [self createAlert:responseObject[@"msg"]];

                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:responseObject[@"data"]];
                        [dic setObject:userTextField.text forKey:@"username"];
                        sqlitManager = [[DBManager alloc]init];
                        [sqlitManager add_Dic:dic];
                        userTextField.text = nil;
                        passTextField.text = nil;
                        passTextField1.text = nil;
                        emailTextField.text = nil;
                        [self dismissViewControllerAnimated:YES completion:nil];
                        if (self.myBlock) {
                            self.myBlock(userNameString);
                        }
                    }
                    else{
                       
                        [self createAlert:responseObject[@"msg"]];

                        
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    [self createAlert:@"请打开网络"];

                }];
                
        
        }
  
   
}
- (void)createAlert:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
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
