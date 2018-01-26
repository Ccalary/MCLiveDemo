//
//  CardsTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "CardsTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CardsTableViewCell()
@property (nonatomic, strong) UIImageView *bankImageView, *checkImageView;
@property (nonatomic, strong) UILabel *nameLabel, *numLabel;
@end

@implementation CardsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor whiteColor];
    
    _bankImageView = [[UIImageView alloc] init];
    _bankImageView.image = [UIImage imageNamed:@"card_default_32"];
    [self.contentView addSubview:_bankImageView];
    [_bankImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(34*UIRate);
        make.left.offset(15*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.font = FONT_SYSTEM(15);
    _nameLabel.textColor = [UIColor fontColorBlack];
    _nameLabel.text = @"银行";
    [self.contentView addSubview:_nameLabel];
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_bankImageView.mas_right).offset(15*UIRate);
        make.centerY.equalTo(self.contentView).offset(-10*UIRate);
    }];
    
    _numLabel = [[UILabel alloc] init];
    _numLabel.font = FONT_SYSTEM(12);
    _numLabel.textColor = [UIColor fontColorLightGray];
    [self.contentView addSubview:_numLabel];
    [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.centerY.equalTo(self.contentView).offset(8*UIRate);
    }];
    
    _checkImageView = [[UIImageView alloc] init];
    _checkImageView.image = [UIImage imageNamed:@"mine_select_28"];
    _checkImageView.hidden = YES;
    [self.contentView addSubview:_checkImageView];
    [_checkImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(28*UIRate);
        make.height.mas_equalTo(28*UIRate);
        make.right.offset(-15*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _dividerLine = [[UIView alloc] init];
    _dividerLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_dividerLine];
    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(60*UIRate);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)setModel:(WalletMoneyModel *)model withSelectModel:(WalletMoneyModel *)selectModel{
    [_bankImageView sd_setImageWithURL:[NSURL URLWithString:model.image] placeholderImage:[UIImage imageNamed:@"card_default_32"]];
    _nameLabel.text = model.title ?: @"";
    _numLabel.text = model.content ?: @"";
    
    if ([model.cardID isEqualToString:selectModel.cardID]){
        _checkImageView.hidden = NO;
    }else{
        _checkImageView.hidden = YES;
    }
}
@end
