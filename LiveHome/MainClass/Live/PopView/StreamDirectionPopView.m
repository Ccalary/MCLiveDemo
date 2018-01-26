//
//  StreamDirectionPopView.m
//  LiveHome
//
//  Created by chh on 2017/11/10.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StreamDirectionPopView.h"

@interface StreamDirectionPopView()
@property (nonatomic ,strong) UIImageView *photoImageView, *camerImageView;
@property (nonatomic, strong) UIButton *horizontalBtn, *verticalBtn, *heighBtn, *normalBtn;
@end

@implementation StreamDirectionPopView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    _photoImageView = [[UIImageView alloc] init];
    _photoImageView.image = [UIImage imageNamed:@"s_bg_180x95"];
    _photoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _photoImageView.clipsToBounds = YES;
    [self addSubview:_photoImageView];
    [_photoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(181*UIRate);
        make.height.mas_equalTo(96*UIRate);
        make.top.offset(23*UIRate);
        make.centerX.equalTo(self);
    }];
    
    _camerImageView = [[UIImageView alloc] init];
    _camerImageView.image = [UIImage imageNamed:@"s_photo_40x34"];
    [self addSubview:_camerImageView];
    [_camerImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(40*UIRate);
        make.height.mas_equalTo(34*UIRate);
        make.centerX.equalTo(_photoImageView);
        make.top.equalTo(_photoImageView).offset(15*UIRate);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = @"添加直播封面";
    tipsLabel.font = FONT_SYSTEM(12*UIRate);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_photoImageView).offset(-15*UIRate);
        make.centerX.equalTo(self);
    }];
    
    UIButton *addBtn = [self creatTopButtonWithImageStr:@"" andType:StreamDirPopViewBtnTypePhoto];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_photoImageView);
    }];
    
    _normalBtn = [self creatTopButtonWithImageStr:@"icon_unselect_16" andType:StreamDirPopViewBtnTypeResolution480P];
    [_normalBtn setTitle:@"流畅" forState:UIControlStateNormal];
    _normalBtn.titleLabel.font = FONT_SYSTEM(15);
    _normalBtn.selected = YES;
    [_normalBtn setTitleColor:[UIColor fontColorLightGray] forState:UIControlStateNormal];
    [_normalBtn setImage:[UIImage imageNamed:@"icon_select_16"] forState:UIControlStateSelected];
    [_normalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75*UIRate);
        make.height.mas_equalTo(30*UIRate);
        make.right.equalTo(self.mas_centerX);
        make.top.equalTo(addBtn.mas_bottom);
    }];
    
    _heighBtn = [self creatTopButtonWithImageStr:@"icon_unselect_16" andType:StreamDirPopViewBtnTypeResolution720P];
    [_heighBtn setTitle:@"高清" forState:UIControlStateNormal];
    _heighBtn.titleLabel.font = FONT_SYSTEM(15);
    [_heighBtn setTitleColor:[UIColor fontColorLightGray] forState:UIControlStateNormal];
    [_heighBtn setImage:[UIImage imageNamed:@"icon_select_16"] forState:UIControlStateSelected];
    [_heighBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_normalBtn);
        make.left.equalTo(self.mas_centerX);
        make.centerY.equalTo(_normalBtn);
    }];
    
    _horizontalBtn = [self creatTopButtonWithImageStr:@"s_hor_40" andType:StreamDirPopViewBtnTypeHorizontal];
    
    _verticalBtn = [self creatTopButtonWithImageStr:@"s_ver_40" andType:StreamDirPopViewBtnTypeVertical];
    
    [_horizontalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(45*UIRate);
        make.right.equalTo(self.mas_centerX).offset(-10);
        make.top.equalTo(_normalBtn.mas_bottom).offset(15*UIRate);
    }];
    
    [_verticalBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo(_horizontalBtn);
        make.left.equalTo(self.mas_centerX).offset(10);
        make.centerY.equalTo(_horizontalBtn);
    }];
    
    UILabel *horLabel = [[UILabel alloc] init];
    horLabel.text = @"横屏";
    horLabel.font = FONT_SYSTEM(15*UIRate);
    horLabel.textColor = [UIColor themeColor];
    [self addSubview:horLabel];
    [horLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_horizontalBtn.mas_bottom).offset(5*UIRate);
        make.centerX.equalTo(_horizontalBtn);
    }];
    
    UILabel *verLabel = [[UILabel alloc] init];
    verLabel.text = @"竖屏";
    verLabel.font = FONT_SYSTEM(15*UIRate);
    verLabel.textColor = [UIColor themeColor];
    [self addSubview:verLabel];
    [verLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(horLabel);
        make.centerX.equalTo(_verticalBtn);
    }];
}

- (UIButton *)creatTopButtonWithImageStr:(NSString *)imageStr andType:(StreamDirPopViewBtnType) buttonType{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:imageStr] forState:UIControlStateNormal];
    button.tag = buttonType;
    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:button];
    return button;
}

- (void)buttonAction:(UIButton *)button{
    switch (button.tag) {
        case StreamDirPopViewBtnTypeResolution480P://流畅
            self.normalBtn.selected = YES;
            self.heighBtn.selected = NO;
            break;
        case StreamDirPopViewBtnTypeResolution720P://高清
            self.normalBtn.selected = NO;
            self.heighBtn.selected = YES;
            break;
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(streamPopViewBtnActionWithType:)]){
        [self.delegate streamPopViewBtnActionWithType:button.tag];
    }
}

- (void)setBannerImage:(UIImage *)bannerImage{
    _photoImageView.image = bannerImage;
    [self bringSubviewToFront:_photoImageView];
}
@end
