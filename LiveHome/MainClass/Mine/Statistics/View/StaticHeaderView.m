//
//  StaticHeaderView.m
//  LiveHome
//
//  Created by chh on 2017/11/1.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StaticHeaderView.h"
#import <PNChart/PNChart.h>
@interface StaticHeaderView()
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) PNLineChartData *chartData;
@property (nonatomic, strong) NSArray *XDataArray;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation StaticHeaderView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        
        _XDataArray = @[@"周一",@"周二",@"周三",@"周四",@"周五",@"周六",@"周日"];
        _dataArray = @[@0,@0,@0,@0,@0,@0,@0];
        
        [self initView];
    }
    return self;
}

- (void)initView{
    
    _lineChart = [[PNLineChart alloc]initWithFrame:CGRectMake(15, 15*UIRate, self.frame.size.width - 30, 215*UIRate)];
    //设置背景颜色
    _lineChart.backgroundColor = [UIColor whiteColor];
    //设置坐标轴是否可见
    _lineChart.showCoordinateAxis = YES;
    //设置是否显示网格线
    _lineChart.showYGridLines = YES;
    //设置网格线颜色
    _lineChart.yGridLinesColor = [UIColor grayColor];
    //设置X轴标签
    _lineChart.xLabels = self.XDataArray;
    //设置坐标轴颜色
    _lineChart.axisColor = [UIColor bgColorLineDarkGray];
    //设置坐标轴宽度
    _lineChart.axisWidth = 1.0;
    //Add
    [self addSubview:_lineChart];
    
    //曲线数据1
    _chartData = [[PNLineChartData alloc]init];
    //曲线颜色
    _chartData.color = [UIColor themeColor];
//    data1.showPointLabel = YES;
//    data1.pointLabelFont = FONT_SYSTEM(12);
//    data1.pointLabelColor = [UIColor fontColorLightGray];
    //曲线格式
    _chartData.inflexionPointStyle = PNLineChartPointStyleCircle;
    //设置数据（Y轴坐标根据数据的大小自动适应）
    _chartData.itemCount = self.dataArray.count;
    __weak typeof (self) weakSelf = self;
    _chartData.getData = ^(NSUInteger index){
        CGFloat yValue = [weakSelf.dataArray[index] floatValue];
        return [ PNLineChartDataItem dataItemWithY:yValue];
    };
    _lineChart.chartData = @[_chartData];
    //开始绘图
    [_lineChart strokeChart];
}

- (void)reloadView{
     _lineChart.xLabels = self.XDataArray;
    _chartData.itemCount = self.dataArray.count;
    __weak typeof (self) weakSelf = self;
    _chartData.getData = ^(NSUInteger index){
        CGFloat yValue = [weakSelf.dataArray[index] floatValue];
        return [ PNLineChartDataItem dataItemWithY:yValue];
    };
    _lineChart.chartData = @[_chartData];
    //开始绘图
    [_lineChart strokeChart];
}

- (void)resetDataArray:(NSArray *)dataArray andXLabelData:(NSArray *)labels{
    self.dataArray = dataArray;
    self.XDataArray = labels;
    [self reloadView];
}

@end
