//
//  StatisticsSelectView.m
//  LiveHome
//
//  Created by chh on 2017/11/1.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StatisticsSelectView.h"
#import "StaticSelectTableViewCell.h"

@interface StatisticsSelectView()<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *dataArray;
@end

@implementation StatisticsSelectView
- (instancetype)initWithFrame:(CGRect)frame andDataArray:(NSArray *)array{
    if (self = [super initWithFrame:frame]){
        self.dataArray = array;
        [self initView];
    }
    return self;
}

- (void)initView{
    _tableView = [[UITableView alloc] initWithFrame:self.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_tableView];
}

#pragma mark - UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString * const cellIdentifier = @"CellIdentifier";
    StaticSelectTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[StaticSelectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    UIView *bgView = [[UIView alloc] initWithFrame:cell.frame];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    cell.selectedBackgroundView = bgView;
    cell.titleLabel.text = self.dataArray[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 40*UIRate;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if ([self.delegate respondsToSelector:@selector(didSelectRow:title:)]){
        [self.delegate didSelectRow:(int)indexPath.row title:self.dataArray[indexPath.row]];
    }
}
@end
