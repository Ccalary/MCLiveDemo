//
//  MessageTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/11/15.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MessageTableViewCell.h"
@interface MessageTableViewCell()
@property (nonatomic, strong) UILabel *timeLabel, *contentLabel;
@end
@implementation MessageTableViewCell

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
        make.width.height.mas_equalTo(50*UIRate);
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(15*UIRate);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.text = @"10";
    _numLabel.font = FONT_SYSTEM(10);
    _numLabel.layer.cornerRadius = 7.5*UIRate;
    _numLabel.clipsToBounds = YES;
    _numLabel.backgroundColor = [UIColor redColor];
    _numLabel.textAlignment = NSTextAlignmentCenter;
    _numLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.width.mas_equalTo(15*UIRate);
        make.top.equalTo(_iconImageView).offset(1*UIRate);
        make.right.equalTo(_iconImageView).offset(-3*UIRate);
    }];
    
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_SYSTEM(15);
    _titleLabel.textColor = [UIColor fontColorBlack];
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_iconImageView.mas_right).offset(10*UIRate);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-3*UIRate);
    }];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = FONT_SYSTEM(12);
    _timeLabel.text = @"2017/11/08 08:20";
    _timeLabel.textColor = [UIColor fontColorLightGray];
    [self.contentView addSubview:_timeLabel];
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.offset(-15*UIRate);
        make.bottom.equalTo(_titleLabel);
    }];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = FONT_SYSTEM(15);
    _contentLabel.textColor = [UIColor fontColorLightGray];
    _contentLabel.text = @"欢迎来到智播家，你在2017年11月11日19时00分开始直播的";
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.right.offset(-15*UIRate);
        make.top.equalTo(self.contentView.mas_centerY).offset(3*UIRate);
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
}
@end
