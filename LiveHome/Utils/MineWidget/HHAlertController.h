//
//  HHAlertController.h
//  LiveHome
//
//  Created by chh on 2017/11/21.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^sureButtonBlock)(void);
typedef void(^cancelButtonBlock)(void);

@interface HHAlertController : UIAlertController
+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message sureButtonTitle:(NSString *)sureTitle cancelButtonTitle:(NSString *)cancelTitle sureHandel:(sureButtonBlock)sureBlock cancelHandel:(cancelButtonBlock)cancelBlock;
@end
