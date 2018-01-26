//
//  StatciCollectionViewCell.m
//  LiveHome
//
//  Created by chh on 2017/11/1.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "StatciCollectionViewCell.h"

@implementation StatciCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]){
        [self initView];
    }
    return self;
}

- (void)initView{
    self.backgroundColor = [UIColor whiteColor];
    
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width - 10, self.frame.size.height - 10)];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.font = FONT_SYSTEM(12);
    _textLabel.text = @"text";
    _textLabel.textColor = [UIColor fontColorDarkGray];
    [self.contentView addSubview:_textLabel];
}

@end
