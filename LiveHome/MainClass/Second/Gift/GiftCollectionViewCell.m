//
//  GiftCollectionViewCell.m
//  LiveHome
//
//  Created by chh on 2017/11/15.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "GiftCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@interface GiftCollectionViewCell()
@property (nonatomic, strong) UIButton *selectBtn, *moneyBtn;
@property (nonatomic, strong) UIImageView *giftImageView, *moneyIcon;
@property (nonatomic, strong) UILabel *giftNameLabel, *moneyLabel;
@property (nonatomic, strong) UIView *horLine;
@end

@implementation GiftCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        self.contentView.backgroundColor = [UIColor whiteColor];
        [self initView];
    }
    return self;
}

- (void)initView{
    _selectBtn = [[UIButton alloc] init];
    [_selectBtn setImage:[UIImage imageNamed:@"round_gray_17"] forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"round_right_17"] forState:UIControlStateSelected];
    [self.contentView addSubview:_selectBtn];
    _selectBtn.userInteractionEnabled = NO;
    [_selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(17*UIRate);
        make.top.offset(5*UIRate);
        make.right.offset(-5*UIRate);
    }];
    
    _giftImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_giftImageView];
    [_giftImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50*UIRate);
        make.top.offset(18*UIRate);
        make.centerX.equalTo(self.contentView);
    }];
    
    _giftNameLabel = [[UILabel alloc] init];
    _giftNameLabel.font = FONT_SYSTEM(15);
    _giftNameLabel.textColor = [UIColor fontColorDarkGray];
    [self.contentView addSubview:_giftNameLabel];
    [_giftNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.bottom.offset(-25*UIRate);
    }];
    
    _moneyBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, 15*UIRate)];
    [_moneyBtn setImage:[UIImage imageNamed:@"coin_10"] forState:UIControlStateNormal];
    _moneyBtn.titleLabel.font = FONT_SYSTEM(10*UIRate);
    [_moneyBtn setTitleColor:[UIColor fontColorMoneyGolden] forState:UIControlStateNormal];
    [self.contentView addSubview:_moneyBtn];
    [_moneyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(self.contentView);
        make.height.mas_equalTo(15*UIRate);
        make.bottom.offset(-10*UIRate);
    }];
    
//    _moneyLabel = [[UILabel alloc] init];
//    _moneyLabel.font = FONT_SYSTEM(10*UIRate);
//    _moneyLabel.textColor = [UIColor fontColorMoneyGolden];
//    _moneyLabel.text = @"0.1";
//    [self.contentView addSubview:_moneyLabel];
//    [_moneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerX.equalTo(self.contentView).offset(6*UIRate);
//        make.bottom.offset(-10*UIRate);
//    }];
//
//    _moneyIcon = [[UIImageView alloc] init];
//    _moneyIcon.image = [UIImage imageNamed:@"coin_10"];
//    [self.contentView addSubview:_moneyIcon];
//    [_moneyIcon mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.height.mas_equalTo(10*UIRate);
//        make.right.equalTo(_moneyLabel.mas_left).offset(-1);
//        make.centerY.equalTo(_moneyLabel);
//    }];
    
    _topLine = [[UIView alloc] init];
    _topLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_topLine];
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.top.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    _horLine = [[UIView alloc] init];
    _horLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_horLine];
    [_horLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    _verLine = [[UIView alloc] init];
    _verLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_verLine];
    [_verLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.right.centerY.equalTo(self.contentView);
        make.width.mas_equalTo(1);
    }];
}

- (void)setModel:(GiftModel *)model{
    _selectBtn.selected = model.isInclud;
    [_giftImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"g_zan_50"]];
     _giftNameLabel.text = model.name ?: @"";
    [_moneyBtn setTitle:model.price forState:UIControlStateNormal];
}
@end
