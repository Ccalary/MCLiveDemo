//
//  PackageHeaderView.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PackageHeaderView.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
@interface PackageHeaderView()<SDCycleScrollViewDelegate>
@property (nonatomic, strong) SDCycleScrollView *cycleView;
@end

@implementation PackageHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}
- (void)initView{
    _cycleView = [SDCycleScrollView cycleScrollViewWithFrame:self.frame delegate:self placeholderImage:[UIImage imageNamed:@""]];
    [self addSubview:_cycleView];
}

- (void)setImageArray:(NSArray *)imageArray{
    _cycleView.imageURLStringsGroup = imageArray;
}
//点击跳转
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    DLog(@"点击了图片:%ld",(long)index);
    if (self.block){
        self.block();
    }
}

@end
