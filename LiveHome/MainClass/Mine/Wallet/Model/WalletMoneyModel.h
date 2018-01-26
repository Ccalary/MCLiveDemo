//
//  WalletMoneyModel.h
//  LiveHome
//
//  Created by chh on 2017/11/9.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WalletMoneyModel : NSObject
@property (nonatomic,copy) NSString *cardID;//id
@property (nonatomic,copy) NSString *content;//号码内容
@property (nonatomic,copy) NSString *image;//银行iocn
@property (nonatomic,copy) NSString *title;//银行名称
@property (nonatomic,copy) NSString *money;//钱数
@end
