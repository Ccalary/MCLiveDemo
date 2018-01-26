//
//  WalletCardsVC.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletMoneyModel.h"

typedef void(^seletCardBlock)(WalletMoneyModel *model);

@interface WalletCardsVC : UIViewController
@property (nonatomic, strong) WalletMoneyModel *model;
@property (nonatomic, copy) seletCardBlock block;
@end
