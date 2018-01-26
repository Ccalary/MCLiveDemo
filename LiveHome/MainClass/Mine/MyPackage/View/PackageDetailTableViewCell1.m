//
//  PackageDetailTableViewCell1.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PackageDetailTableViewCell1.h"
@interface PackageDetailTableViewCell1()
@property (nonatomic, strong) UIButton *normalBtn, *majorBtn;
@property (nonatomic, strong) UILabel *normalTextLabel, *normalMoneyLabel, *majorTextLabel, *majorMoneyLabel;
@end
@implementation PackageDetailTableViewCell1

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self initView];
    }
    return self;
}
- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    UILabel *nameLabel = [self creatLabelWithText:@"选套餐" andColor:[UIColor fontColorBlack]];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.top.offset(15*UIRate);
    }];
    
    UIButton *normalBtn = [[UIButton alloc] init];
    [normalBtn setBackgroundImage:[UIImage imageNamed:@"p_select_gray_88x55"] forState:UIControlStateNormal];
    [normalBtn setBackgroundImage:[UIImage imageNamed:@"p_select_blue_88x55"] forState:UIControlStateSelected];
    normalBtn.tag = 1000;
    [normalBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:normalBtn];
    self.normalBtn = normalBtn;
    [normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(88*UIRate);
        make.height.mas_equalTo(55*UIRate);
        make.right.equalTo(self.contentView.mas_centerX).offset(-5*UIRate);
        make.top.offset(40*UIRate);
    }];
    
    _normalTextLabel = [self creatLabelWithText:@"大众版" andColor:[UIColor fontColorLightGray]];
    [_normalTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(normalBtn);
        make.top.equalTo(normalBtn).offset(7*UIRate);
    }];
    
    _normalMoneyLabel = [self creatLabelWithText:@"2988/年" andColor:[UIColor fontColorLightGray]];
    [_normalMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(normalBtn);
        make.top.equalTo(_normalTextLabel.mas_bottom);
    }];
    
    UIButton *majorBtn = [[UIButton alloc] init];
    majorBtn.tag = 2000;
    [majorBtn setBackgroundImage:[UIImage imageNamed:@"p_select_gray_88x55"] forState:UIControlStateNormal];
    [majorBtn setBackgroundImage:[UIImage imageNamed:@"p_select_blue_88x55"] forState:UIControlStateSelected];
    [majorBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:majorBtn];
    self.majorBtn = majorBtn;
    majorBtn.selected = YES;
    [majorBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(normalBtn);
        make.left.equalTo(self.contentView.mas_centerX).offset(5*UIRate);
        make.centerY.equalTo(normalBtn);
    }];
    
    _majorTextLabel = [self creatLabelWithText:@"专业版" andColor:[UIColor themeColor]];
    [_majorTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(majorBtn);
        make.top.equalTo(majorBtn).offset(7*UIRate);
    }];
    
    _majorMoneyLabel = [self creatLabelWithText:@"5988/年" andColor:[UIColor themeColor]];
    [_majorMoneyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(majorBtn);
        make.top.equalTo(_majorTextLabel.mas_bottom);
    }];
}

- (UILabel *)creatLabelWithText:(NSString *)text andColor:(UIColor *)color{
    UILabel *label = [[UILabel alloc] init];
    label.text = text;
    label.font = FONT_SYSTEM(15*UIRate);
    label.textColor = color;
    [self.contentView addSubview:label];
    return label;
}

- (void)buttonAction:(UIButton *)button{
    switch (button.tag) {
        case 1000://大众版
            _normalBtn.selected = YES;
            _normalTextLabel.textColor = [UIColor themeColor];
            _normalMoneyLabel.textColor = [UIColor themeColor];
            _majorBtn.selected = NO;
            _majorTextLabel.textColor = [UIColor fontColorLightGray];
            _majorMoneyLabel.textColor = [UIColor fontColorLightGray];
            break;
        case 2000://专业版
            _normalBtn.selected = NO;
            _normalTextLabel.textColor = [UIColor fontColorLightGray];
            _normalMoneyLabel.textColor = [UIColor fontColorLightGray];
            _majorBtn.selected = YES;
            _majorTextLabel.textColor = [UIColor themeColor];
            _majorMoneyLabel.textColor = [UIColor themeColor];
            break;
        default:
            break;
    }
    if (self.block){
        self.block(button.tag);
    }
}

- (void)setDataArray:(NSArray *)dataArray{
    for (PackageDetailModel *model in dataArray){
        if ([model.type intValue] == 0){//大众版
             _normalMoneyLabel.text = [NSString stringWithFormat:@"%@/年",model.price];
        }else {
            _majorMoneyLabel.text = [NSString stringWithFormat:@"%@/年",model.price];
        }
    }
}
@end
