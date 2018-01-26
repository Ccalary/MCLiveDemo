//
//  ContributeTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "ContributeTableViewCell.h"
@interface ContributeTableViewCell()
@property (nonatomic, strong) UILabel *rankLabel, *nameLabel, *contriLabel;
@property (nonatomic, strong) UIImageView *rankImageView, *headerImageView;
@end

@implementation ContributeTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    //名次
    _rankLabel = [[UILabel alloc] init];
    _rankLabel.font = FONT_SYSTEM_BOLD(15);
    _rankLabel.textColor = [UIColor fontColorBlack];
    _rankLabel.text = @"10";
    _rankLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_rankLabel];
    [_rankLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(60*UIRate);
        make.height.equalTo(self.contentView);
        make.left.equalTo(self.contentView);
        make.top.equalTo(self.contentView);
    }];
    
    //123名图标
    _rankImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_rankImageView];
    [_rankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(34*UIRate);
        make.center.equalTo(self.rankLabel);
    }];
    
    //头像
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.image = [UIImage imageNamed:@"header_default_60"];
    _headerImageView.layer.cornerRadius = 18*UIRate;
    [self addSubview:_headerImageView];
    [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(36*UIRate);
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(_rankLabel.mas_right);
    }];
    
    //名字
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = FONT_SYSTEM(15);
    _nameLabel.textColor = [UIColor fontColorBlack];
    _nameLabel.text = @"名字";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(-11*UIRate);
        make.left.equalTo(_headerImageView.mas_right).offset(10*UIRate);
    }];
    
    //贡献
    _contriLabel = [[UILabel alloc] init];
    _contriLabel.font = FONT_SYSTEM(12);
    _contriLabel.textColor = [UIColor fontColorLightGray];
    _contriLabel.text = @"贡献：8888";
    [self.contentView addSubview:_contriLabel];
    [_contriLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.centerY.equalTo(self.contentView).offset(9*UIRate);
    }];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:dividerLine];
    [dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headerImageView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}
@end
