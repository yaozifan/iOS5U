//
//  CommentViewController.m
//  5U体育
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "CommentViewController.h"
#import "CommentModel.h"
#import "CommentFrame.h"
#import "HttpRequestBlock.h"
#import "CommentCell.h"
#import "AFHTTPRequestOperationManager.h"
#import "DBManager.h"
@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate>
{
    UITableView *_tableView;
    UITextField *textField;
    //网络请求
    AFHTTPRequestOperationManager *manager;
    DBManager *sqlitManager;


}
@property (nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation CommentViewController

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
    [self createRefresh];

//    [self loadData];
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
    //关于评论的
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
        NSString *str = textField.text;
        NSMutableArray *mutableArray = [sqlitManager loadData];
        NSArray *userDataArray = [NSArray arrayWithArray:[mutableArray firstObject]];
        NSString *password_encrypt = [userDataArray firstObject];
        NSString *user_id = userDataArray[1];
        NSString *username = userDataArray[3];
         NSDictionary *dic = @{@"user_id":user_id,@"cat_detail_id":self.catId,@"password_encrypt":password_encrypt,@"news_id":self.newsId,@"news_content":str,@"ip":@"192.168.2.2",@"username":username};

        manager = [AFHTTPRequestOperationManager manager];
   
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html",@"application/json",nil];
            [manager POST:@"http://u.api.5usport.com/PHP_works/api/index.php?m=News&a=addNewsComment&version=1.0.4" parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if ([responseObject[@"success"]intValue]) {
                    [self createAlert:responseObject[@"msg"]];

                    textField.text = nil;
                    [textField resignFirstResponder];
                    page = 1;
                    [self loadData];
                    [header beginRefreshing];
                    
   
                }
                else{
                    [self createAlert:responseObject[@"msg"]];

                }

                
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"失败");
                [self createAlert:@"请打开网络"];

            }];



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
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)createTableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT-64-49) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
    [_tableView addGestureRecognizer:tap1];
    [self.view addSubview:_tableView];
    
}
- (void)createRefresh
{
    
    header = [MJRefreshHeaderView header];
    header.scrollView = _tableView;
    __weak CommentViewController *vc = self;
    int *page1 = &page;
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
   
    HttpRequestBlock *request = [[HttpRequestBlock alloc]initWithUrlPath:[NSString stringWithFormat:COMMENT1,page,self.catId,self.newsId] Block:^(BOOL isSucceed, HttpRequestBlock *http) {
        if (isSucceed) {
            NSArray *array = http.dataDic[@"data"];
            if (page == 1) {
                self.dataArray = [NSMutableArray arrayWithCapacity:0];
            }
            for (NSDictionary *dic in array) {
                CommentModel *model = [[CommentModel alloc]initWithDic:dic];
                CommentFrame *cellFrame = [[CommentFrame alloc]init];
                cellFrame.commentModel = model;
                [self.dataArray addObject:cellFrame];
            }
            [_tableView reloadData];
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
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ID"];
    if (!cell) {
        cell = [[CommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ID"];
    }
    CommentFrame *cellFrame = self.dataArray[indexPath.row];
    cell.commentFrame = cellFrame;
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentFrame *frame = self.dataArray[indexPath.row];
    return frame.cellHeight;
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)dealloc
{
    [header free];
    [footer free];
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
