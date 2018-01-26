//
//  MineHeaderView.m
//  LiveHome
//
//  Created by chh on 2017/10/27.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MineHeaderView.h"
#import "UIImageView+WebCache.h"

@interface MineHeaderView()
@property (nonatomic, strong) UIImageView *bgImageView, *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel, *numberLabel;
@end

@implementation MineHeaderView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    _bgImageView = [[UIImageView alloc] initWithFrame:self.frame];
    _bgImageView.image = [UIImage imageNamed:@"mine_bg_375x155"];
    [self addSubview:_bgImageView];
    
    UIButton *writeButton = [[UIButton alloc] init];
    [writeButton setImage:[UIImage imageNamed:@"mine_write_23"] forState:UIControlStateNormal];
    [writeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:writeButton];
    [writeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(35*UIRate);
        make.top.offset(StatusBarHeight);
        make.right.offset(0);
    }];
    
    UIView *headerBgView = [[UIView alloc] init];
    headerBgView.backgroundColor = [UIColor whiteColor];
    headerBgView.layer.cornerRadius = 30*UIRate;
    [self addSubview:headerBgView];
    [headerBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(60*UIRate);
        make.top.offset(60*UIRate);
        make.left.offset(15*UIRate);
    }];
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.image = [UIImage imageNamed:@"header_default_60"];
    _headerImageView.layer.cornerRadius = 28*UIRate;
    _headerImageView.clipsToBounds = YES;
    [self addSubview:_headerImageView];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(56*UIRate);
        make.center.equalTo(headerBgView);
    }];
    
    UIButton *headerButton = [[UIButton alloc] init];
    [headerButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:headerButton];
    [headerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(headerBgView);
    }];
    
    _nameLabel = [self creatLabelText:@"名字"];
    _numberLabel = [self creatLabelText:@"ID:8688"];
    _numberLabel.font = FONT_SYSTEM(12);
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerBgView.mas_right).offset(6*UIRate);
        make.centerY.equalTo(headerBgView).offset(-10*UIRate);
    }];
   
    [_numberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.centerY.equalTo(headerBgView).offset(9*UIRate);
    }];
}

- (UILabel *)creatLabelText:(NSString *)text{
    UILabel *label = [[UILabel alloc] init];
    label.textColor = [UIColor whiteColor];
    label.font = FONT_SYSTEM(15);
    label.text = text;
    [self addSubview:label];
    return label;
}

- (void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(mineHeaderViewBtnAction)]){
        [self.delegate mineHeaderViewBtnAction];
    }
}

//填充数据
- (void)setModel:(UserInfoModel *)model{
    _model = model;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:model.userimage] placeholderImage:[UIImage imageNamed:@"header_default_60"]];
    _nameLabel.text = model.username ?: @"用户1";
    _numberLabel.text = [NSString stringWithFormat:@"ID:%@", model.findid ?: @""];
}
@end
