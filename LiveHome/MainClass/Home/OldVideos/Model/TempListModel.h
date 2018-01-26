//
//  TempListModel.h
//  LiveHome
//
//  Created by chh on 2017/12/12.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 id = 3e870c4454844c21999032eb17ae7467;
 isdefault = 0;
 title = "模版测试";
 */
@interface TempListModel : NSObject
/**
  模版id
 */
@property (nonatomic, copy) NSString *pid;
/**
 是否默认模版
 */
@property (nonatomic, assign) BOOL isdefault;
/**
 模版标题
 */
@property (nonatomic, copy) NSString *title;
@end
