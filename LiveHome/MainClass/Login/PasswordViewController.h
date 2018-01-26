//
//  PasswordViewController.h
//  LiveHome
//
//  Created by chh on 2017/11/2.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, PasswordVCType){
    PasswordVCTypeRegister,  //注册
    PasswordVCTypeForgotPsd, //忘记密码
};

@interface PasswordViewController : UIViewController
- (instancetype)initWithType:(PasswordVCType)type;
@end
