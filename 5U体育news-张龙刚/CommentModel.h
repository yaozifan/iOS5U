//
//  CommentModel.h
//  5U体育
//
//  Created by qianfeng on 15-4-27.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommentModel : NSObject
@property (nonatomic,copy)NSString *creat_at;
@property (nonatomic,copy)NSString *news_content;
@property (nonatomic,copy)NSString *username;
- (instancetype)initWithDic:(NSDictionary *)dic;
@end
