//
//  MsgDetailTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/11/16.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "MsgDetailTableViewCell.h"
#import "ToolsHelper.h"

@interface MsgDetailTableViewCell()
@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *timeLabel, *contentLabel;
@property (nonatomic, strong) UIView *msgView;
@end

@implementation MsgDetailTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor bgColorMain];
    
    UIView *timeHoldView = [[UIView alloc] init];
    timeHoldView.backgroundColor = [UIColor colorWithHex:0xe3e7ed];
    timeHoldView.layer.cornerRadius = 2.0;
    [self.contentView addSubview:timeHoldView];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.font = FONT_SYSTEM(10);
    _timeLabel.text = @"11月08日 08:20";
    _timeLabel.textColor = [UIColor whiteColor];
    [self.contentView addSubview:_timeLabel];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.offset(20*UIRate);
        make.centerX.equalTo(self.contentView);
    }];
    
    [timeHoldView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_timeLabel).offset(-10*UIRate);
        make.right.equalTo(_timeLabel).offset(10*UIRate);
        make.top.equalTo(_timeLabel).offset(-4*UIRate);
        make.bottom.equalTo(_timeLabel).offset(4*UIRate);
    }];
    
    _iconImageView = [[UIImageView alloc] init];
    _iconImageView.image = [UIImage imageNamed:@"m_notice_50"];
    [self.contentView addSubview:_iconImageView];
    [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(50*UIRate);
        make.top.offset(45*UIRate);
        make.left.mas_equalTo(15*UIRate);
    }];
    
    _msgView = [[UIView alloc] init];
    _msgView.backgroundColor = [UIColor whiteColor];
    _msgView.layer.cornerRadius = 4.0;
    [self.contentView addSubview:_msgView];
    [_msgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImageView);
        make.left.offset(72*UIRate);
        make.right.offset(-10*UIRate);
        make.height.mas_equalTo(60*UIRate);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_SYSTEM(18);
    _titleLabel.textColor = [UIColor fontColorBlack];
    _titleLabel.text = @"公告消息";
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_msgView).offset(10*UIRate);
        make.top.equalTo(_msgView).offset(8*UIRate);
    }];
    
    NSString *content = @"欢迎来到智播家，你在2017年11月11日19时00分开始直播的欢迎来到智播家，你在2017年11月11日19时00分开始直播的欢迎来到智播家，你在2017年11月11日19时00分开始直播的";
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = FONT_SYSTEM(15);
    _contentLabel.textColor = [UIColor fontColorLightGray];
    _contentLabel.numberOfLines = 0;
    _contentLabel.text = content;
    [self.contentView addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_titleLabel);
        make.width.mas_equalTo(265*UIRate);
        make.top.equalTo(_titleLabel.mas_bottom).offset(6*UIRate);
    }];
    
   
    CGFloat height = [ToolsHelper getStringHeightWithWidth:265*UIRate font:FONT_SYSTEM(15) string:content];
    
    [_msgView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(40*UIRate + height);
    }];
}
@end
