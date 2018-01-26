//
//  PayPopView.h
//  LiveHome
//
//  Created by chh on 2017/11/20.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, PayPopViewBtnType){
    PayPopViewBtnTypeClose  = 0,
    PayPopViewBtnTypeWeChat = 1,
    PayPopViewBtnTypeAlipay = 2,
    PayPopViewBtnTypePay    = 3, //立即支付
};

@protocol PayPopViewDelegate<NSObject>
- (void)payPopViewButtonAction:(PayPopViewBtnType)type;
@end

@interface PayPopView : UIView
@property (nonatomic, weak) id<PayPopViewDelegate> delegate;
@property (nonatomic, strong) UILabel *moneyLabel;
@end
