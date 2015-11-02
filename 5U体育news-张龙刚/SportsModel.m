//
//  SportsModel.m
//  体坛周报Product
//
//  Created by qianfeng on 15-1-18.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "SportsModel.h"

@implementation SportsModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{

}
- (instancetype)initWithDic:(NSDictionary *)dic
{
    if (self = [super init]) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}
@end
