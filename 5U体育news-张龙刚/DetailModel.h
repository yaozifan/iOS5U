//
//  DetailModel.h
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DetailModel : NSObject
@property (nonatomic,copy)NSString *news_title;
@property (nonatomic,copy)NSString *news_photo;
@property (nonatomic,copy)NSString *news_date;
@property (nonatomic,copy)NSString *news_id;
@property (nonatomic,copy)NSString *cat_detail_id;
@property (nonatomic,copy)NSString *news_content;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
