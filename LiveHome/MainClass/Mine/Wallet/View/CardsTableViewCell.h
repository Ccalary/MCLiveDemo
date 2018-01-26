//
//  CardsTableViewCell.h
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WalletMoneyModel.h"

@interface CardsTableViewCell : UITableViewCell
@property (nonatomic, strong) UIView *dividerLine;

- (void)setModel:(WalletMoneyModel *)model withSelectModel:(WalletMoneyModel *)selectModel;
@end
