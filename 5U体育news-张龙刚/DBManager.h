//
//  DBManager.h
//  LimitFreeProduct
//
//  Created by qianfeng on 15-4-14.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"
@interface DBManager : NSObject
{
    FMDatabase *fm;
}
//该类设计为单例
+ (instancetype)shareManager;
//插入数据
- (void)add_Dic:(NSDictionary *)dic;
//读取数据
- (NSMutableArray *)loadData;
- (void)deleteData;
@end
