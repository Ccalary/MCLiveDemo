//
//  WithdrawTableViewCell2.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void(^moneyBlock)(NSString *);

@interface WithdrawTableViewCell2 : UITableViewCell

@property (nonatomic, copy) moneyBlock block;

@end
