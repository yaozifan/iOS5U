//
//  SportsModel.h
//  体坛周报Product
//
//  Created by qianfeng on 15-1-18.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SportsModel : NSObject
@property (nonatomic,copy)NSString *news_title;
@property (nonatomic,copy)NSString *news_photo;
@property (nonatomic,copy)NSString *news_date;
@property (nonatomic,copy)NSString *news_id;
- (instancetype)initWithDic:(NSDictionary *)dic;

@end
