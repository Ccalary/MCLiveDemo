//
//  GiftCollectionViewCell.h
//  LiveHome
//
//  Created by chh on 2017/11/15.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GiftModel.h"

@interface GiftCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UIView *verLine, *topLine;
@property (nonatomic, strong) GiftModel *model;
@end
