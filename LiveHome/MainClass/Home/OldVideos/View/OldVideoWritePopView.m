//
//  OldVideoWritePopView.m
//  LiveHome
//
//  Created by chh on 2017/11/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "OldVideoWritePopView.h"
#import <UITextView_Placeholder/UITextView+Placeholder.h>
#import "UIImageView+WebCache.h"
#define TOTAL_NUM  15
@interface OldVideoWritePopView()<UITextViewDelegate>
@property (nonatomic, strong) UIImageView *photoImageView, *camerImageView;
@end

@implementation OldVideoWritePopView
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
        make.width.mas_equalTo(180*UIRate);
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
    
    UILabel *tipsLabel = [self creatLabelWithText:@"修改直播封面"];
    tipsLabel.textColor = [UIColor fontColorLightGray];
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_photoImageView).offset(-15*UIRate);
        make.centerX.equalTo(self);
    }];
    
    UIButton *addBtn = [[UIButton alloc] init];
    [addBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    addBtn.tag = OldVideoWritePopViewBtnTypeAdd;
    [self addSubview:addBtn];
    [addBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(_photoImageView);
    }];
    
    UILabel *titleLabel = [self creatLabelWithText:@"直播标题"];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_photoImageView);
        make.top.equalTo(_photoImageView.mas_bottom).offset(5*UIRate);
    }];
    
    _textView = [[UITextView alloc] init];
    _textView.placeholder = @"请填写标题(15字以内)";
    _textView.backgroundColor = [UIColor bgColorMain];
    _textView.font = FONT_SYSTEM(12*UIRate);
    _textView.delegate = self;
    _textView.contentInset = UIEdgeInsetsMake(1, 2, 1, 2);
    _textView.layer.borderColor = [UIColor bgColorLine].CGColor;
    _textView.layer.borderWidth = 1;
    _textView.textColor = [UIColor fontColorDarkGray];
    [self addSubview:_textView];
    
    [_textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(_photoImageView);
        make.height.mas_equalTo(45*UIRate);
        make.top.equalTo(titleLabel.mas_bottom).offset(1*UIRate);
    }];
    
    UILabel *tempLabel = [self creatLabelWithText:@"选择模版"];
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(titleLabel);
        make.top.equalTo(_textView.mas_bottom).offset(5*UIRate);
    }];
    
    UILabel *tempHoldLabel = [self creatLabelWithText:@""];
    tempHoldLabel.backgroundColor = [UIColor bgColorMain];
    tempHoldLabel.layer.borderWidth = 1;
    tempHoldLabel.layer.borderColor = [UIColor bgColorLine].CGColor;
    [tempHoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.centerX.equalTo(_photoImageView);
        make.height.mas_equalTo(22*UIRate);
        make.top.equalTo(tempLabel.mas_bottom).offset(1*UIRate);
    }];
    
    _tempLabel = [self creatLabelWithText:@"选择模版"];
    [_tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(tempHoldLabel).offset(2);
        make.right.equalTo(tempHoldLabel).offset(-2);
        make.center.equalTo(tempHoldLabel);
    }];
    
    UIButton *tempBtn = [[UIButton alloc] init];
    tempBtn.tag = OldVideoWritePopViewBtnTypeTemp;
    [tempBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:tempBtn];
    [tempBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(tempHoldLabel);
    }];
    
    UIButton *submitBtn = [[UIButton alloc] init];
    [submitBtn setTitle:@"提交" forState:UIControlStateNormal];
    submitBtn.titleLabel.font = FONT_SYSTEM(15);
    submitBtn.layer.cornerRadius = 4.0;
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    submitBtn.tag = OldVideoWritePopViewBtnTypeSubmit;
    [submitBtn setBackgroundColor:[UIColor themeColor]];
    [self addSubview:submitBtn];
    [submitBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(15*UIRate);
        make.right.offset(-15*UIRate);
        make.height.mas_equalTo(40*UIRate);
        make.bottom.offset(-5*UIRate);
    }];
}

//限制字数
- (void)textViewDidChange:(UITextView *)textView{
    
    NSString *toBeString = textView.text;
    //获取高亮部分
    UITextRange *selectedRange = [textView markedTextRange];
    UITextPosition *position = [textView positionFromPosition:selectedRange.start offset:0];
    
    // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
    if (!position)
    {
        if (toBeString.length > TOTAL_NUM)
        {
            NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:TOTAL_NUM];
            if (rangeIndex.length == 1)//表情占用两个字符这里能更好的判断
            {
                textView.text = [toBeString substringToIndex:TOTAL_NUM];
            }
            else
            {
                NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, TOTAL_NUM)];
                textView.text = [toBeString substringWithRange:rangeRange];
            }
        }
    }
}

- (UILabel *)creatLabelWithText:(NSString *)text{
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.text = text;
    tipsLabel.font = FONT_SYSTEM(12*UIRate);
    tipsLabel.textColor = [UIColor fontColorDarkGray];
    [self addSubview:tipsLabel];
    return tipsLabel;
}

- (void)buttonAction:(UIButton *)button{
    [self endEditing:YES];
    if ([self.delegate respondsToSelector:@selector(oldVideoWriteViewBtnClick:)]){
        [self.delegate oldVideoWriteViewBtnClick:button.tag];
    }
}

- (void)setBannerImage:(UIImage *)bannerImage{
    _photoImageView.image = bannerImage;
}

- (void)setModel:(VideoListModel *)model{
    _model = model;
    [_photoImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",model.image]] placeholderImage:[UIImage imageNamed:@"video_default_180x95"]];
    _textView.text= model.name ?: @"";
}
@end
