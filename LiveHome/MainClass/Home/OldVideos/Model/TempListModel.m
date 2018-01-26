//
//  TempListModel.m
//  LiveHome
//
//  Created by chh on 2017/12/12.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "TempListModel.h"

@implementation TempListModel
//更改字段名字
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"pid":@"id"};
}
@end
