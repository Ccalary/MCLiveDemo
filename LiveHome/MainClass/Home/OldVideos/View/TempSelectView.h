//
//  TempSelectView.h
//  LiveHome
//
//  Created by chh on 2017/12/12.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TempListModel.h"
typedef  void(^tempSelectBlock)(TempListModel *model);

@interface TempSelectView : UIView
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) tempSelectBlock block;
@end
