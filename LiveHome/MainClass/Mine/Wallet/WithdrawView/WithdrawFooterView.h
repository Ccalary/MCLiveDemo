//
//  WithdrawFooterView.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^withdrawBlock)(void);

@interface WithdrawFooterView : UIView
@property (nonatomic, strong) NSString *totalMoney; //可提现金额
@property (nonatomic, copy) withdrawBlock block;
@end
