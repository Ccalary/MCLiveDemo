//
//  CountdownLabel.h
//  TestDemo
//
//  Created by chh on 2017/7/25.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountdownLabel : UILabel
@property (nonatomic, assign) int count;
- (instancetype)initWithFrame:(CGRect)frame;
- (void)startCount;
@end
