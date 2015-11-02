//
//  DetailModel.m
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import "DetailModel.h"

@implementation DetailModel
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
