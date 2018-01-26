//
//  TempSelectTableViewCell.m
//  LiveHome
//
//  Created by chh on 2017/12/12.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "TempSelectTableViewCell.h"
@interface TempSelectTableViewCell()

@end

@implementation TempSelectTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]){
        [self initView];
    }
    return self;
}

- (void)initView{
    UILabel *tempLabel = [[UILabel alloc] init];
    tempLabel.font = FONT_SYSTEM(15*UIRate);
    tempLabel.textAlignment = NSTextAlignmentCenter;
    tempLabel.textColor = [UIColor fontColorDarkGray];
    [self.contentView addSubview:tempLabel];
    self.titleLabel = tempLabel;
    [tempLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor bgColorLine];
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.bottom.centerX.equalTo(self.contentView);
        make.height.equalTo(@1);
    }];
}
@end
