//
//  PackageDetailModel.h
//  LiveHome
//
//  Created by chh on 2017/11/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PackageDetailModel : NSObject
/** 流量 */
@property (nonatomic, copy) NSString *flux;
/** 云空间 */
@property (nonatomic, copy) NSString *space;
/** 版本名 */
@property (nonatomic, copy) NSString *name;
/** 价格 */
@property (nonatomic, copy) NSString *price;
/** 种类 0-大众版 1-专业版 */
@property (nonatomic, copy) NSString *type;
/** 优惠详情 */
@property (nonatomic, strong) NSArray *youhui;
@end
