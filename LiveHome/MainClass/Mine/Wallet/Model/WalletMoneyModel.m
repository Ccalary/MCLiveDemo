
//
//  WalletMoneyModel.m
//  LiveHome
//
//  Created by chh on 2017/11/9.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "WalletMoneyModel.h"

@implementation WalletMoneyModel
//更改字段名字
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"cardID":@"id"};
}
@end
