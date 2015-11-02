//
//  CellFram.h
//  5U体育
//
//  Created by qianfeng on 15-4-23.
//  Copyright (c) 2015年 liuzhenhua. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DetailModel;
@interface CellFrame : NSObject
@property (nonatomic,assign,readonly)CGRect textLableFrame;
@property (nonatomic,assign,readonly)CGRect titltLableFrame;
@property (nonatomic,assign,readonly)CGRect dateLableFrame;
@property (nonatomic,assign,readonly)CGRect photoImageViewFrame;
@property (nonatomic,assign,readonly)CGFloat cellHeight;
@property (nonatomic,strong)DetailModel *model;
@end
