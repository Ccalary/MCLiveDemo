//
//  MineTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MineTableViewCell.h"
@interface MineTableViewCell()

@end

@implementation MineTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(20*UIRate);
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(15*UIRate);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_SYSTEM(15);
    _titleLabel.textColor = [UIColor fontColorBlack];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(8*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _dividerLine = [[UIView alloc] init];
    _dividerLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_dividerLine];
    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.equalTo(self.contentView);
        make.bottom.equalTo(self.contentView);
        make.height.mas_equalTo(1);
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = [UIImage imageNamed:@"arrow_10x18"];
    [self.contentView addSubview:arrowImageView];
    [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8*UIRate);
        make.height.mas_equalTo(10*UIRate);
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.font = FONT_SYSTEM(15);
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = [UIColor fontColorLightGray];
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(arrowImageView.mas_left).offset(-5*UIRate);
        make.width.mas_equalTo(100*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
