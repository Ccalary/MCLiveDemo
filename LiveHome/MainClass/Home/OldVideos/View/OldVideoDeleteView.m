//
//  OldVideoDeleteView.m
//  LiveHome
//
//  Created by chh on 2017/11/30.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "OldVideoDeleteView.h"

@implementation OldVideoDeleteView
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    UIButton *selectBtn = [[UIButton alloc] init];
    [selectBtn setImage:[UIImage imageNamed:@"icon_unselect_16"] forState:UIControlStateNormal];
    [selectBtn setImage:[UIImage imageNamed:@"icon_select_16"] forState:UIControlStateSelected];
    [selectBtn setTitleColor:[UIColor fontColorDarkGray] forState:UIControlStateNormal];
    [selectBtn setTitle:@"全选" forState:UIControlStateNormal];
    selectBtn.tag = OldVideoDeleteViewBtnTypeSelect;
    selectBtn.titleLabel.font = FONT_SYSTEM(15);
    [selectBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.selectBtn = selectBtn;
    [self addSubview:selectBtn];
    [selectBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(75*UIRate);
        make.height.mas_equalTo(30*UIRate);
        make.left.top.equalTo(self);
    }];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [deleteBtn setTitleColor:[UIColor fontColorDarkGray] forState:UIControlStateNormal];
    [deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [deleteBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    deleteBtn.titleLabel.font = FONT_SYSTEM(15);
    deleteBtn.tag = OldVideoDeleteViewBtnTypeDelete;
    [self addSubview:deleteBtn];
    [deleteBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(50*UIRate);
        make.right.equalTo(self);
        make.centerY.height.equalTo(selectBtn);
    }];
    
}

- (void)buttonAction:(UIButton *)button{
    if ([self.delegate respondsToSelector:@selector(oldVideoManagerBtnAction:)]){
        [self.delegate oldVideoManagerBtnAction:button];
    }
}
@end
