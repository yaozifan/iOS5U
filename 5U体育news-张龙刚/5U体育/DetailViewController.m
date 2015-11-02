//
//  DetailViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-22.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "DetailViewController.h"
#import "HttpRequestBlock.h"
#import "DetailModel.h"
#import "DetailCell.h"
#import "CellFrame.h"
#import "CommentViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DBManager.h"
#import "LoginViewController.h"
@interface DetailViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    //发表评论
    UITextField *textField;
    //网络请求
    AFHTTPRequestOperationManager *manager;
    DBManager *sqlitManager;

}
@property (nonatomic,strong)CellFrame *cellFrame;
@end

@implementation DetailViewController

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
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createNav];
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

    [self loadData];
    // Do any additional setup after loading the view.
}
- (void)createNav
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 44, 44);
    UIImage *image = [UIImage imageNamed:@"navigationbar_back_default.png"];
    image = [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"navigationbar_back_heightlight.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item = [[UIBarButtonItem alloc]initWithCustomView:button];
    self.navigationItem.leftBarButtonItem = item;
    
    
    
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.frame = CGRectMake(0, 0, 44, 44);
    UIImage *image1 = [UIImage imageNamed:@"right_comment_default.png"];
    image1 = [image1 imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [rightbutton setImage:image1 forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"right_comment_higltlighted.png"] forState:UIControlStateHighlighted];
    [rightbutton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = item1;
    //评论
//    view = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT-49, WIDTH, 49)];
//    [self.view addSubview:view];
    UIImageView *talkView = [ZCControl createImageViewFrame:CGRectMake(0, 0, 15, 18) imageName:nil];
    UIImage *penImage = [UIImage imageNamed:@"pen.png"];
    penImage = [penImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    talkView.image = penImage;
    UIButton *sendButton = [ZCControl createButtonWithFrame:CGRectMake(0, 0, 40, 22) title:@"发送" imageName:nil bgImageName:@"add_comment_2.png" target:self method:@selector(buttonClick)];
    [sendButton setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    textField = [[UITextField alloc]initWithFrame:CGRectMake(5, HEIGHT-49-64, WIDTH-10, 49)];
    textField.leftView = talkView;
    textField.rightView = sendButton;
    textField.placeholder = @"评论";
    textField.rightViewMode = UITextFieldViewModeAlways;
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.delegate = self;
    [self.view addSubview:textField];
    //通知中心，观察键盘的弹出和消失
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    sqlitManager = [DBManager shareManager];
    NSMutableArray *array = [sqlitManager loadData];
    if (!array.count) {
        [self createAlert:@"请登陆"];
        return NO;
    }
    return YES;
}
- (void)keyboardShow:(NSNotification *)notification
{
    //计数键盘高度
    float x = [[notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey]CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44-x);
        textField.frame = CGRectMake(0, self.view.frame.size.height-x-44, self.view.frame.size.width-10, 49) ;
    
     }];
}
- (void)keyboardHide:(NSNotification *)notification{
    [UIView animateWithDuration:0.3 animations:^{
        _tableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height-44);
        textField.frame = CGRectMake(0, self.view.frame.size.height-44, self.view.frame.size.width-10, 44);
    }];
    
}

- (void)buttonClick
{
    if (textField.text.length>0) {
        CellFrame *frame = [self.dataArray firstObject];
        DetailModel *model = frame.model;
        if (textField.text.length>0) {
            NSString *str = textField.text;
            NSMutableArray *mutableArray = [sqlitManager loadData];
            NSArray *userDataArray = [NSArray arrayWithArray:[mutableArray firstObject]];
            NSString *password_encrypt = [userDataArray firstObject];
            NSString *user_id = userDataArray[1];
            NSString *username = userDataArray[3];
             NSDictionary *dic = @{@"user_id":user_id,@"cat_detail_id":model.cat_detail_id,@"password_encrypt":password_encrypt,@"news_id":model.news_id,@"news_content":str,@"ip":@"192.168.2.2",@"username":username};
            manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
                [manager POST:@"http://u.api.5usport.com/PHP_works/api/index.php?m=News&a=addNewsComment&version=1.0.4" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                    NSLog(@"%@评论",responseObject);
                    if ([responseObject[@"success"] intValue]) {
                        textField.text = nil;
                        [textField resignFirstResponder];
                        [self createAlert:responseObject[@"msg"]];
                        
                     

                    }
                    else{
                        [self createAlert:responseObject[@"msg"]];
                    }
                    
                } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                    NSLog(@"失败");
                    [self createAlert:@"请打开网络"];
                }];

        }

    }else{
        [self createAlert:@"请输入"];
    }
}
- (void)createAlert:(NSString *)string
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:string delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alert show];
}
- (void)tap
{
    [self.view endEditing:YES];
}
- (void)backButtonClick:(UIButton *)button
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)rightButtonClick:(UIButton *)button
{
    CommentViewController *vc = [[CommentViewController alloc]init];
    vc.title = @"评论";
    CellFrame *frame = [self.dataArray firstObject];
    DetailModel *model = frame.model;
    vc.newsId = model.news_id;
    vc.catId = model.cat_detail_id;
    UINavigationController *nc1 = [[UINavigationController alloc]initWithRootViewController:vc];
    [self presentViewController:nc1 animated:YES completion:nil];
}
- (void)createTableView
{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.allowsSelection = NO;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_tableView addGestureRecognizer:tap1];
    [self.view addSubview:_tableView];
    
 }
- (void)loadData
{
    if (self.news_id) {
        HttpRequestBlock *request = [[HttpRequestBlock alloc]initWithUrlPath:[NSString stringWithFormat:DETAIL,self.news_id] Block:^(BOOL isSucceed, HttpRequestBlock *http) {
            if (isSucceed) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
                NSDictionary *dic = http.dataDic[@"data"];
                DetailModel *model = [[DetailModel alloc]initWithDic:dic];
                CellFrame *cellFrame = [[CellFrame alloc]init];
                cellFrame.model = model;
                [self.dataArray addObject:cellFrame];
                [_tableView reloadData];
                [av removeFromSuperview];
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                [activity stopAnimating];
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
    DetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[DetailCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
        
    }
    CellFrame *cellFrame = self.dataArray[indexPath.row];
    cell.cellFrame = cellFrame;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrame *cellFrame = self.dataArray[indexPath.row];
    return cellFrame.cellHeight;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
