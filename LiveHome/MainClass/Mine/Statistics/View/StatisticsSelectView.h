//
//  StatisticsSelectView.h
//  LiveHome
//
//  Created by chh on 2017/11/1.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol StatisticsSelectViewDelegate <NSObject>
- (void)didSelectRow:(int)row title:(NSString *)text;
@end

@interface StatisticsSelectView : UIView

@property (nonatomic, weak) id<StatisticsSelectViewDelegate> delegate;

- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)array;
@end
