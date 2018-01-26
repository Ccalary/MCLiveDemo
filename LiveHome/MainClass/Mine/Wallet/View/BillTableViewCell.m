//
//  BillTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "BillTableViewCell.h"
@interface BillTableViewCell()
@property (nonatomic, strong) UILabel *leftTopLabel, *leftBottomLabel, *rightLabel;
@end

@implementation BillTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _leftTopLabel = [[UILabel alloc] init];
    _leftTopLabel.font = FONT_SYSTEM(15);
    _leftTopLabel.textColor = [UIColor fontColorBlack];
    _leftTopLabel.text = @"未知";
    [self.contentView addSubview:_leftTopLabel];
    [_leftTopLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.centerY.equalTo(self).offset(-10*UIRate);
    }];
    
    _leftBottomLabel = [[UILabel alloc] init];
    _leftBottomLabel.font = FONT_SYSTEM(12);
    _leftBottomLabel.textColor = [UIColor fontColorLightGray];
    _leftBottomLabel.text = @"2017-01-01 00:00:00";
    [self.contentView addSubview:_leftBottomLabel];
    [_leftBottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_leftTopLabel);
        make.centerY.equalTo(self).offset(8*UIRate);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.font = FONT_SYSTEM(15);
    _rightLabel.textColor = [UIColor fontColorBlack];
    _rightLabel.text = @"+0.00";
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(self);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self);
        make.height.mas_equalTo(1);
        make.centerX.equalTo(self);
        make.bottom.equalTo(self);
    }];
}

- (void)setBillModel:(WalletBillModel *)billModel{
    _billModel = billModel;
    self.leftTopLabel.text = billModel.title;
    self.rightLabel.text = billModel.money;
    self.leftBottomLabel.text = billModel.time;
}

@end
