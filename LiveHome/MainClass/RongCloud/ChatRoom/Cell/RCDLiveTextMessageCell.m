//
//  RCDLiveChatRoomVC.m
//  RongChatRoomDemo
//
//  Created by nie on 2017/5/12.
//  Copyright © 2017年 rongcloud. All rights reserved.
//

#import "RCDLiveTextMessageCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "ToolsHelper.h"

@interface RCDLiveTextMessageCell ()
{
    NSString *_userid;
    NSString *_username;
    CGFloat WIDTH;
}
@end

@implementation RCDLiveTextMessageCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.textLabel = [RCDLiveTipLabel greyTipLabel];
//        self.textLabel.userInteractionEnabled = YES;
        [self.baseContentView addSubview:self.textLabel];
        self.textLabel.font = [UIFont systemFontOfSize:16.f];;
        
        self.contentView.frame = self.bounds;
        self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model
{
    [super setDataModel:model];
  
    RCMessageContent *content = model.content;
    
    if ([content isMemberOfClass:[RCTextMessage class]])
    {
        RCTextMessage *notification = (RCTextMessage *)content;
        NSDictionary *params = [ToolsHelper dictionaryFromJson:notification.extra];
        _userid = params[@"userid"];
        _username = params[@"username"];
        
        NSString *localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        
        if(!_username.length) _username= @"游客";
        
        _username = [NSString stringWithFormat:@"%@：",_username];
    
        NSString *str = [NSString stringWithFormat:@"%@%@",_username,localizedMessage];
        
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:str];
        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor fontColorOrange] range:[str rangeOfString:_username]];
        
        NSShadow *shadow = [[NSShadow alloc]init];
        shadow.shadowBlurRadius = 5;
        shadow.shadowColor = [UIColor grayColor];
        shadow.shadowOffset = CGSizeMake(1, 1);

        [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:[str rangeOfString:localizedMessage]];
        [attributedString addAttribute:NSShadowAttributeName value:shadow range:[str rangeOfString:localizedMessage]];
            
        self.textLabel.attributedText = attributedString.copy;
    }
    
    [self.textLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self);
        make.top.equalTo(self).with.offset(1);
        make.bottom.equalTo(self).with.offset(-1);
    }];
}

- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithURL:(NSURL *)url
{
    NSString *urlString=[url absoluteString];
    if (![urlString hasPrefix:@"http"]) {
        urlString = [@"http://" stringByAppendingString:urlString];
    }
    if ([self.delegate respondsToSelector:@selector(didTapUrlInMessageCell:model:)]) {
        [self.delegate didTapUrlInMessageCell:urlString model:self.model];
        return;
    }
}

- (void)attributedLabel:(RCDLiveAttributedLabel *)label didSelectLinkWithPhoneNumber:(NSString *)phoneNumber
{
    NSString *number = [@"tel://" stringByAppendingString:phoneNumber];
    if ([self.delegate respondsToSelector:@selector(didTapPhoneNumberInMessageCell:model:)]) {
        [self.delegate didTapPhoneNumberInMessageCell:number model:self.model];
        return;
    }
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
    textSize = CGSizeMake(ceilf(textSize.width), ceilf(textSize.height)+8);
    return textSize;
}
@end
