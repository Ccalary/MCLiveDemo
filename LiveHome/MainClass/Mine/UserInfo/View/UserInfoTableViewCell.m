//
//  UserInfoTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@implementation UserInfoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = FONT_SYSTEM(15);
    _nameLabel.textColor = [UIColor fontColorBlack];
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.width.mas_equalTo(80*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _rightLabel = [[UILabel alloc] init];
    _rightLabel.font = FONT_SYSTEM(15);
    _rightLabel.textAlignment = NSTextAlignmentRight;
    _rightLabel.textColor = [UIColor fontColorLightGray];
    [self.contentView addSubview:_rightLabel];
    [_rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - 100*UIRate);
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.image = [UIImage imageNamed:@"header_default_60"];
    _headerImageView.layer.cornerRadius = 20*UIRate;
    _headerImageView.clipsToBounds = YES;
    [self.contentView addSubview:_headerImageView];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*UIRate);
        make.width.height.mas_equalTo(40*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _textField = [[UITextField alloc] init];
    _textField.font = FONT_SYSTEM(15);
    _textField.textColor = [UIColor fontColorLightGray];
    _textField.textAlignment = NSTextAlignmentRight;
    _textField.placeholder = @"请填写昵称";
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenWidth - 150*UIRate);
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _dividerLine = [[UIView alloc] init];
    _dividerLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_dividerLine];
    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
    
    _arrowImageView = [[UIImageView alloc] init];
    _arrowImageView.hidden = YES;
    _arrowImageView.image = [UIImage imageNamed:@"arrow_10x18"];
    [self.contentView addSubview:_arrowImageView];
    [_arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(8*UIRate);
        make.height.mas_equalTo(10*UIRate);
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _rightDetailLabel = [[UILabel alloc] init];
    _rightDetailLabel.font = FONT_SYSTEM(15);
    _rightDetailLabel.textAlignment = NSTextAlignmentRight;
    _rightDetailLabel.textColor = [UIColor fontColorLightGray];
    [self.contentView addSubview:_rightDetailLabel];
    [_rightDetailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_arrowImageView.mas_left).offset(-5*UIRate);
        make.width.mas_equalTo(100*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
}
@end
