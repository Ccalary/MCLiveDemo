//
//  WalletAddCardVC.h
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^successBlock)(void);
@interface WalletAddCardVC : UIViewController
@property (nonatomic, copy) successBlock block;
@end
