//
//  PopSecurityCodeView.h
//  LiveHome
//
//  Created by chh on 2017/11/2.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, PopSecurityCodeViewBtnType){
   PopSecurityCodeViewBtnCode   = 0, //验证码
   PopSecurityCodeViewBtnCancel = 1, //取消
   PopSecurityCodeViewBtnSubmit = 2, //提交
};

@protocol PopSecurityCodeViewDelegate<NSObject>
- (void)securityCodeBtnAction:(PopSecurityCodeViewBtnType)type;
@end

@interface PopSecurityCodeView : UIView
@property (nonatomic, weak) id<PopSecurityCodeViewDelegate> delegate;
@property (nonatomic, strong) UIImageView *codeImageView;
@property (nonatomic, strong) UITextField *textField;
@end
