//
//  MyPackageModel.h
//  LiveHome
//
//  Created by chh on 2017/11/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPackageModel : NSObject
/** -1 试用版 0-大众版 1-专业版*/
@property (nonatomic, copy) NSString *type;
/** 流量截止时间*/
@property (nonatomic, copy) NSString *flusEndtime;
/** 流量剩余量*/
@property (nonatomic, copy) NSString *fluslast;
/** 流量当前使用量*/
@property (nonatomic, copy) NSString *flussize;
/** 流量总量*/
@property (nonatomic, copy) NSString *flustotal;
/** 存储空间截止时间*/
@property (nonatomic, copy) NSString *spaceEndtime;
/** 存储空间剩余量*/
@property (nonatomic, copy) NSString *spacelast;
/** 存储空间当前使用量*/
@property (nonatomic, copy) NSString *spacesize;
/** 存储空间总量*/
@property (nonatomic, copy) NSString *spacetotal;
@end
