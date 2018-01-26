//
//  StatisticsModel.h
//  LiveHome
//
//  Created by chh on 2017/12/7.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StatisticsModel : NSObject
/** 日期 2017-11-11 */
@property (nonatomic, copy) NSString *date;
/** 观看人数 */
@property (nonatomic, copy) NSString *count;
/** 时长 */
@property (nonatomic, copy) NSString *length;
/** 打赏金额 */
@property (nonatomic, copy) NSString *m;
@end
