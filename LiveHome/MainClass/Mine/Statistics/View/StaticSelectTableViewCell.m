//
//  StaticSelectTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/11/1.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StaticSelectTableViewCell.h"

@implementation StaticSelectTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundColor = [UIColor clearColor];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.font = FONT_SYSTEM(15);
    _titleLabel.textColor = [UIColor whiteColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    _dividerLine = [[UIView alloc] init];
    _dividerLine.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:_dividerLine];
    [_dividerLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.offset(5);
        make.right.offset(-5);
        make.height.equalTo(@0.5);
        make.bottom.equalTo(self.contentView);
    }];
}

@end
