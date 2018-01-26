//
//  HHAlertController.m
//  LiveHome
//
//  Created by chh on 2017/11/21.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "HHAlertController.h"

@interface HHAlertController ()

@end

@implementation HHAlertController

+ (instancetype)alertWithTitle:(NSString *)title message:(NSString *)message sureButtonTitle:(NSString *)sureTitle cancelButtonTitle:(NSString *)cancelTitle sureHandel:(sureButtonBlock)sureBlock cancelHandel:(cancelButtonBlock)cancelBlock{
    HHAlertController *alert = [HHAlertController alertControllerWithTitle:title
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    
    [alert addAction:[UIAlertAction actionWithTitle:sureTitle
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction * _Nonnull action){
                                                if (sureBlock) sureBlock();
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:cancelTitle
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                if (cancelBlock) cancelBlock();
                                            }]];
    return alert;
}

@end
