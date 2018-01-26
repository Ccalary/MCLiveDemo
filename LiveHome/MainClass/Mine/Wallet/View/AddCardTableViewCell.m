//
//  AddCardTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/10/28.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "AddCardTableViewCell.h"
@interface AddCardTableViewCell()

@end

@implementation AddCardTableViewCell

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
    
    _textField = [[UITextField alloc] init];
    _textField.font = FONT_SYSTEM(15);
    _textField.textColor = [UIColor fontColorBlack];
    [_textField addTarget:self action:@selector(textFieldAction:) forControlEvents:UIControlEventEditingChanged];
    [self.contentView addSubview:_textField];
    [_textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel.mas_right);
        make.right.offset(-50*UIRate);
        make.centerY.equalTo(self.contentView);
    }];
    
    _clearBtn = [[UIButton alloc] init];
    _clearBtn.hidden = YES;
    [_clearBtn setImage:[UIImage imageNamed:@"btn_clear_15"] forState:UIControlStateNormal];
    [_clearBtn addTarget:self action:@selector(clearBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_clearBtn];
    [_clearBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.mas_equalTo(37*UIRate);
        make.right.offset(-5);
        make.centerY.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_nameLabel);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.bottom.equalTo(self.contentView);
    }];
}

- (void)textFieldAction:(UITextField *)textField{
    self.clearBtn.hidden = (textField.text.length > 0) ? NO : YES;
}

- (void)clearBtnAction:(UIButton *)button{
    self.textField.text = @"";
    button.hidden = YES;
}
@end
