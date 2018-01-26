//
//  StreamingEndView.m
//  Find
//
//  Created by chh on 2017/8/26.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "StreamingEndView.h"
#import "UIImageView+WebCache.h"
#import "ShareTools.h"
#import "ShareModel.h"
#import "ToolsHelper.h"

@interface StreamingEndView()
@property (nonatomic, assign) CGFloat rate; //适配比例
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *nameLabel, *finishLabel;
@property (nonatomic, strong) UILabel *seeTextLabel, *seeNumLabel, *popuTextLabel, *popuNumLabel;
@property (nonatomic, assign) BOOL isLandscape;
@property (nonatomic, strong) ShareModel *shareModel;
@end

@implementation StreamingEndView

- (instancetype)initWithFrame:(CGRect)frame andIsLandscape:(BOOL) isLandscape{
    if (self = [super initWithFrame:frame]){
        self.isLandscape = isLandscape;
        CGSize size = [UIScreen mainScreen].bounds.size;
        if (size.width > size.height){
            _rate = size.height/375.0;
        }else {
            _rate = size.width/375.0;
        }
        [self initLeftView];
        [self initRightView];
    }
    return self;
}

- (ShareModel *)shareModel{
    if (!_shareModel){
        _shareModel = [[ShareModel alloc] init];
        _shareModel.title = self.model.share_title;
        _shareModel.content = self.model.share_dec;
        _shareModel.imageUrl = self.model.share_img;
        _shareModel.shareUrl = self.model.share_url;
    }
    return _shareModel;
}

- (void)initLeftView{
    
     self.backgroundColor = [UIColor colorWithHex:0x344a5d];
    
    _headerImageView = [[UIImageView alloc] init];
    _headerImageView.backgroundColor = [UIColor whiteColor];
    _headerImageView.layer.cornerRadius = 47.5*_rate;
    _headerImageView.layer.borderWidth = 4;
    _headerImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _headerImageView.layer.masksToBounds = YES;
    _headerImageView.image = [UIImage imageNamed:@"header_default_60"];
    [self addSubview:_headerImageView];
    
    _nameLabel = [self createLabelWithTitle:@"主播" andFontSize:[UIFont boldSystemFontOfSize:18*_rate] andTextColor:[UIColor whiteColor]];
    _finishLabel = [self createLabelWithTitle:@"直播已结束" andFontSize:[UIFont boldSystemFontOfSize:25*_rate] andTextColor:[UIColor themeColor]];
    
    if (self.isLandscape){//横屏布局
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(110*_rate);
            make.top.offset(100*_rate);
            make.width.height.mas_equalTo(95*_rate);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerImageView);
            make.top.equalTo(_headerImageView.mas_bottom).offset(10*_rate);
            make.width.mas_equalTo(250*_rate);
            make.height.mas_equalTo(20*_rate);
        }];
        
        [_finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerImageView);
            make.top.equalTo(_nameLabel.mas_bottom).offset(20*_rate);
        }];
    }else {//竖屏布局
       
        [_headerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self);
            make.top.offset(100*_rate);
            make.width.height.mas_equalTo(95*_rate);
        }];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerImageView);
            make.top.equalTo(_headerImageView.mas_bottom).offset(10*_rate);
            make.width.mas_equalTo(250*_rate);
            make.height.mas_equalTo(20*_rate);
        }];
        
        [_finishLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_headerImageView);
            make.top.equalTo(_nameLabel.mas_bottom).offset(20*_rate);
        }];
    }
}

- (void)initRightView{
    
    _seeTextLabel = [self createLabelWithTitle:@"直播时长" andFontSize:[UIFont systemFontOfSize:15*_rate] andTextColor:[UIColor whiteColor]];
    _seeNumLabel = [self createLabelWithTitle:@"0" andFontSize:[UIFont boldSystemFontOfSize:20*_rate] andTextColor:[UIColor themeColor]];
    _popuTextLabel = [self createLabelWithTitle:@"人气值" andFontSize:[UIFont systemFontOfSize:15*_rate] andTextColor:[UIColor whiteColor]];
    _popuNumLabel = [self createLabelWithTitle:@"0" andFontSize:[UIFont boldSystemFontOfSize:20*_rate] andTextColor:[UIColor themeColor]];
    
    UIView *dividerLine = [[UIView alloc] init];
    dividerLine.backgroundColor = [UIColor colorWithHex:0x475d7d];
    [self addSubview:dividerLine];
    
    UILabel *shareLabel = [self createLabelWithTitle:@"分享到" andFontSize:[UIFont systemFontOfSize:15*_rate] andTextColor:[UIColor colorWithHex:0xb7c2c4]];
    shareLabel.backgroundColor = [UIColor colorWithHex:0x344a5d];
   
    //关闭按钮
    UIButton *closeButton = [[UIButton alloc] init];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    closeButton.titleLabel.font = [UIFont systemFontOfSize:15*_rate];
    closeButton.backgroundColor = [UIColor themeColor];
    closeButton.layer.cornerRadius = 20*_rate;
    [closeButton addTarget:self action:@selector(closeButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:closeButton];
    
    UIButton *qqBtn = [self creatButtonWithImageStr:@"s_qq_32" andTag:1000];
    UIButton *wexinBtn = [self creatButtonWithImageStr:@"s_weixin_32" andTag:1001];
    UIButton *friendsBtn = [self creatButtonWithImageStr:@"s_friends_32" andTag:1002];
    
    if (!self.isLandscape){//竖屏
        [_popuTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self).offset(60*_rate);
            make.top.equalTo(self.finishLabel.mas_bottom).offset(40*_rate);
        }];
        
        [_seeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_popuTextLabel);
            make.centerX.equalTo(self).offset(-60*_rate);
        }];
        
        [dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.offset(40*_rate);
            make.right.offset(-40*_rate);
            make.height.mas_equalTo(1);
            make.bottom.equalTo(wexinBtn.mas_top).offset(-30*_rate);
        }];
        
    }else {
        [_popuTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-120*_rate);
            make.top.offset(80*_rate);
        }];
        
        [_seeTextLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(_popuTextLabel);
            make.right.equalTo(_popuTextLabel.mas_left).offset(-75*_rate);
        }];
        
        [dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self).offset(-55*_rate);
            make.width.mas_equalTo(295*_rate);
            make.height.mas_equalTo(1);
            make.top.equalTo(_seeTextLabel.mas_bottom).offset(75*_rate);
        }];
    }
    
    [_popuNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_popuTextLabel);
        make.top.equalTo(_popuTextLabel.mas_bottom).offset(10*_rate);
    }];
    
    [_seeNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_seeTextLabel);
        make.top.equalTo(_seeTextLabel.mas_bottom).offset(10*_rate);
    }];
    
    [shareLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(dividerLine);
        make.width.mas_equalTo(65*_rate);
        make.height.mas_equalTo(20);
    }];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-60*_rate);
        make.centerX.equalTo(dividerLine);
        make.width.mas_equalTo(185*_rate);
        make.height.mas_equalTo(40*_rate);
    }];
    
    [wexinBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(32*_rate);
        make.centerX.equalTo(dividerLine);
        make.bottom.equalTo(closeButton.mas_top).offset(-20*_rate);
    }];
    
    [qqBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(wexinBtn);
        make.centerY.equalTo(wexinBtn);
        make.right.equalTo(wexinBtn.mas_left).offset(-20*_rate);
    }];
    
    [friendsBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(wexinBtn);
        make.centerY.equalTo(wexinBtn);
        make.left.equalTo(wexinBtn.mas_right).offset(20*_rate);
    }];
}

- (UIButton *)creatButtonWithImageStr:(NSString *)imageStr andTag:(int)tag{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    button.tag = tag;
    [button addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (UILabel *)createLabelWithTitle:(NSString *)title andFontSize:(UIFont *)font andTextColor:(UIColor *)color{
    
    UILabel *label = [[UILabel alloc] init];
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = color;
    label.font = font;
    [self addSubview:label];
    return label;
}

- (void)closeButtonAction{
    if (self.closeBlock){
        self.closeBlock();
    }
}

- (void)shareButtonAction:(UIButton *)button{
    switch (button.tag) {
        case 1000://qq
             [ShareTools shareToQQWithParams:self.shareModel];
            break;
        case 1001://微信
           [ShareTools shareToWeixinWithParams:self.shareModel];
            break;
        case 1002://朋友圈
            [ShareTools shareToFriendsWithParams:self.shareModel];
            break;
        default:
            break;
    }
}

- (void)setStartDate:(NSDate *)startDate{
    double startTime = [startDate timeIntervalSince1970];
    double endTime = [[NSDate date] timeIntervalSince1970];
    double disTime = endTime - startTime;
    _seeNumLabel.text = [NSString stringWithFormat:@"%@",[ToolsHelper getMMSSFromSS:disTime]];//直播时长
}

- (void)setPeopleCount:(int)peopleCount{//人气值其实就是观看人数
     _popuNumLabel.text = [NSString stringWithFormat:@"%d",peopleCount];//人气值
}

- (void)setModel:(LiveRoomModel *)model{
    _model = model;
    [_headerImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.userimage]] placeholderImage:[UIImage imageNamed:@"header_default_60"]];
    _nameLabel.text = model.username ?: @"";
   
}
@end
