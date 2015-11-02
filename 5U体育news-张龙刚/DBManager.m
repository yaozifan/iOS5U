//
//  DBManager.m
//  LimitFreeProduct
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "DBManager.h"
static DBManager *manager = nil;
@implementation DBManager

+ (instancetype)shareManager
{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[DBManager alloc]init];
        //保证在程序创建后只调用一次
    });
    return manager;
}
- (instancetype)init{
    if (self = [super init]) {
        fm = [[FMDatabase alloc]initWithPath:[NSString stringWithFormat:@"%@/Documents/app.db",NSHomeDirectory()]];
        NSLog( @"%@",NSHomeDirectory());
        //打开数据路
        if ([fm open]) {
            //创建表格
            BOOL isSucceed = [fm executeUpdate:@"create table collect(password_encrypt,user_id ,group_id,username primary key)"];
            if (isSucceed) {
                NSLog(@"新创建");
            }else{
                NSLog(@"已经存在");
            }
        }
    }
    return self;
}
- (void)add_Dic:(NSDictionary *)dic
{
    BOOL isSucceed = [fm executeUpdate:@"insert into collect values(?,?,?,?)",dic[@"password_encrypt"],dic[@"user_id"],dic[@"group_id"],dic[@"username"]];
    if (isSucceed) {
        NSLog(@"插入成功");
    }else {
        NSLog(@"插入失败");
    }

}
- (NSMutableArray *)loadData
{
    FMResultSet *result = [fm executeQuery:@"select * from collect"];
    NSMutableArray *dataArray = [NSMutableArray array];
    while ([result next]) {
        NSString *password_encrypt = [result stringForColumn:@"password_encrypt"];
        NSString *user_id = [result stringForColumn:@"user_id"];
        NSString *group_id = [result stringForColumn:@"group_id"];
        NSString *username = [result stringForColumn:@"username"];
        NSArray *temp = @[password_encrypt,user_id,group_id,username];
        [dataArray addObject:temp];
    }

    return dataArray;
}
- (void)deleteData
{
    BOOL isSucceed = [fm executeUpdate:@"drop table collect"];
    if (isSucceed) {
        NSLog(@"删除成功");
    }
    else{
        NSLog(@"删除失败");
    }
}
@end
