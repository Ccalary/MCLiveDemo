//
//  StreamingEndView.h
//  Find
//
//  Created by chh on 2017/8/26.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LiveRoomModel.h"

typedef void(^closeBlock)(void);

@interface StreamingEndView : UIView

@property (nonatomic, copy) closeBlock closeBlock;
@property (nonatomic, strong) LiveRoomModel *model;
@property (nonatomic, strong) NSDate *startDate; //开始时间
@property (nonatomic, assign) int peopleCount;// 观看人数
- (instancetype)initWithFrame:(CGRect)frame andIsLandscape:(BOOL) isLandscape;
@end
