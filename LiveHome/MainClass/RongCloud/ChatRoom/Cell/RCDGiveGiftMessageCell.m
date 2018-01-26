//
//  RCDGiveGiftMessageCell.m
//  Find
//
//  Created by nie on 2017/7/1.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "RCDGiveGiftMessageCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDGiveGiftMessage.h"
#import "ToolsHelper.h"

@interface RCDGiveGiftMessageCell()
{
    int _count;
    NSString *_giftimage;
    NSString *_username;
    
    UIImageView *_imageView;
    UILabel *_numLabel;
}

@end
@implementation RCDGiveGiftMessageCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [RCDLiveTipLabel greyTipLabel];
        self.textLabel.textAlignment = NSTextAlignmentLeft;
        //        self.tipMessageLabel.delegate = self;
        self.textLabel.userInteractionEnabled = YES;
        [self.baseContentView addSubview:self.textLabel];
        self.textLabel.font = [UIFont systemFontOfSize:16.f];
        self.textLabel.textColor = [UIColor blackColor];
        self.textLabel.marginInsets = UIEdgeInsetsMake(0.5f, 0.5f, 0.5f, 0.5f);
        
        _imageView = [[UIImageView alloc]init];
        [self addSubview:_imageView];
        
        _numLabel = [[UILabel alloc]init];
        [self addSubview: _numLabel];
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model
{
    [super setDataModel:model];
    
    RCMessageContent *content = model.content;
    NSString *textStr;
    NSString *numStr;
    
    int giftid = 0;
    
    if ([content isMemberOfClass:[RCDGiveGiftMessage class]])
    {
        RCDGiveGiftMessage *notification = (RCDGiveGiftMessage *)content;
        NSDictionary *params = [ToolsHelper dictionaryFromJson:notification.extra];
        _count = [params[@"count"]intValue];
        _giftimage = params[@"giftimage"];
        _username = params[@"username"];
        giftid = [params[@"giftid"]intValue];
        
        NSString *guding = @"送出了";
        textStr =[NSString stringWithFormat:@"%@ %@",_username,guding];
        
        numStr = [NSString stringWithFormat:@"x%i",_count];

        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:textStr];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor fontColorOrange] range:[textStr rangeOfString:_username]];
        
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowBlurRadius = 5;
        shadow.shadowColor = [UIColor grayColor];
        shadow.shadowOffset = CGSizeMake(1, 1);
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[textStr rangeOfString:guding]];
        [attributedString addAttribute:NSShadowAttributeName value:shadow range:[textStr rangeOfString:guding]];
    
        self.textLabel.attributedText = attributedString.copy;
    }
    [self.textLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self);
        make.height.mas_equalTo(28);
    }];
    
    [_imageView removeFromSuperview];
    [_numLabel removeFromSuperview];
    _imageView = [[UIImageView alloc]init];
    [self addSubview:_imageView];
    
    _numLabel = [[UILabel alloc]init];
    [self addSubview: _numLabel];

    _imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"s_gift_%d",giftid]];

    _numLabel.text = numStr;
    _numLabel.textColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"s_gift_text"]];
    _numLabel.font = [UIFont boldSystemFontOfSize:20];
    
    [_imageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.textLabel.mas_right).with.equalTo(@2);
        make.centerY.equalTo(self.textLabel);
        make.height.equalTo(@20);
        make.width.equalTo(@([self haveImageWidthWithHeight:20 giftid:giftid]));
    }];
    
    [_numLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_imageView.mas_right).with.equalTo(@3);
        make.height.equalTo(self.textLabel);
    }];
}

- (int)haveImageWidthWithHeight:(int)height giftid:(int)giftid
{
    if (giftid == 1) {
        return (int) (height * 0.7);
    }
    else if (giftid == 2) {
        return (int) (height * 1.4);
    }
    else if (giftid == 3) {
        return (int) (height * 1.3);
    }
    else if (giftid == 4) {
        return (int) (height * 0.9);
    }
    else if (giftid == 5) {
        return (int) (height * 1.4333333);
    }
    else if (giftid == 6) {
        return (int) (height * 1.7);
    }
    else if (giftid == 7) {
        return (int) (height * 1.9);
    }
    else if (giftid == 8) {
        return (int) (height * 1.1);
    }
    else if (giftid == -1) {
        return (int) (height * 1);
    }
    return 0;
}

-(void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content
{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

+ (CGSize)getTipMessageCellSize:(NSString *)content andMaxWidth:(CGFloat)maxWidth{
    CGSize textSize = CGSizeZero;
    
    textSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(content, [UIFont systemFontOfSize:16.0f], CGSizeMake(maxWidth, MAXFLOAT));
    textSize = CGSizeMake(ceilf(textSize.width) +10, 28);
    return textSize;
}
@end
