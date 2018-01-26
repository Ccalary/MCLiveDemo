//
//  RealNameFooterView.m
//  LiveHome
//
//  Created by chh on 2017/10/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "RealNameFooterView.h"
@interface RealNameFooterView()
@property (nonatomic, strong) UIButton *photoBtn;
@end

@implementation RealNameFooterView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor bgColorMain];
    
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 10*UIRate, ScreenWidth, 200*UIRate)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bgView];
    
    UILabel *photoLabel = [[UILabel alloc] init];
    photoLabel.font = FONT_SYSTEM(15);
    photoLabel.textColor = [UIColor fontColorLightGray];
    photoLabel.text = @"手持身份证照片";
    [self addSubview:photoLabel];
    [photoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.top.equalTo(bgView).offset(15*UIRate);
    }];
    
    _photoBtn = [[UIButton alloc] init];
    [_photoBtn setBackgroundImage:[UIImage imageNamed:@"photo_add_140"] forState:UIControlStateNormal];
    [_photoBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    _photoBtn.tag = RealNameFooterViewBtnTypePhoto;
    [self addSubview:_photoBtn];
    [_photoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(140*UIRate);
        make.left.offset(40*UIRate);
        make.top.equalTo(photoLabel.mas_bottom).offset(10*UIRate);
    }];
    
    UIImageView *exampleImageView = [[UIImageView alloc] init];
    exampleImageView.image = [UIImage imageNamed:@"photo_example_95x90"];
    [self addSubview:exampleImageView];
    [exampleImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(95*UIRate);
        make.height.mas_equalTo(90*UIRate);
        make.right.offset(-40*UIRate);
        make.top.equalTo(bgView).offset(65*UIRate);
    }];
    
    UILabel *exampleLabel = [[UILabel alloc] init];
    exampleLabel.font = FONT_SYSTEM(12);
    exampleLabel.textColor = [UIColor fontColorLightGray];
    exampleLabel.text = @"示例";
    [self addSubview:exampleLabel];
    [exampleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(exampleImageView.mas_bottom).offset(10*UIRate);
        make.centerX.equalTo(exampleImageView);
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.font = FONT_SYSTEM(12);
    tipsLabel.textColor = [UIColor fontColorLightGray];
    tipsLabel.text = @"请参照“示例”图片，保证身份证号码清晰可见。 ";
    [self addSubview:tipsLabel];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.top.equalTo(bgView.mas_bottom).offset(10*UIRate);
    }];
    
    UILabel *tipsLabel2 = [[UILabel alloc] init];
    tipsLabel2.font = FONT_SYSTEM(12);
    tipsLabel2.textColor = [UIColor fontColorLightGray];
    tipsLabel2.text = @"遮挡，模糊或传不相关图片的都将审核不通过";
    [self addSubview:tipsLabel2];
    [tipsLabel2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.top.equalTo(tipsLabel.mas_bottom).offset(20*UIRate);
    }];
    
    UIButton *uploadBtn = [[UIButton alloc] init];
    [uploadBtn setBackgroundImage:[UIImage imageNamed:@"btn_blue_345x40"] forState:UIControlStateNormal];
    [uploadBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [uploadBtn setTitle:@"提交审核" forState:UIControlStateNormal];
    uploadBtn.titleLabel.font = FONT_SYSTEM_BOLD(15);
    uploadBtn.tag = RealNameFooterViewBtnTypeSubmit;
    [uploadBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:uploadBtn];
    [uploadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.top.equalTo(tipsLabel2.mas_bottom).offset(30*UIRate);
    }];
}

- (void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(realNameFooterViewButtonClick:)]){
        [self.delegate realNameFooterViewButtonClick:button.tag];
    }
}

- (void)setPhotoImage:(UIImage *)photoImage{
    [self.photoBtn setBackgroundImage:photoImage forState:UIControlStateNormal];
}
@end
