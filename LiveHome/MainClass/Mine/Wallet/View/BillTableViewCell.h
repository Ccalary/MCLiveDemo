//
//  BillTableViewCell.h
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletBillModel.h"

@interface BillTableViewCell : UITableViewCell
@property (nonatomic, strong) WalletBillModel *billModel;
@end
