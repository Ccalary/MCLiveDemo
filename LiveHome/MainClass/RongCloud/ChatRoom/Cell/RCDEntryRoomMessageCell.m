//
//  RCDEntryRoomMessageCell.m
//  Find
//
//  Created by nie on 2017/6/29.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "RCDEntryRoomMessageCell.h"
#import "RCDLiveTipLabel.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveKitCommonDefine.h"
#import "RCDEntryRoomMessage.h"
#import "ToolsHelper.h"

@interface RCDEntryRoomMessageCell ()<RCDLiveAttributedLabelDelegate>
@end

@implementation RCDEntryRoomMessageCell


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.tipMessageLabel = [RCDLiveTipLabel greyTipLabel];
        self.tipMessageLabel.userInteractionEnabled = YES;
        [self.baseContentView addSubview:self.tipMessageLabel];
        
        self.tipMessageLabel.font = [UIFont systemFontOfSize:16.f];;
        self.tipMessageLabel.textColor = [UIColor themeColor];
    }
    return self;
}

- (void)setDataModel:(RCDLiveMessageModel *)model
{
    [super setDataModel:model];
    
    RCMessageContent *content = model.content;
    if ([content isMemberOfClass:[RCDEntryRoomMessage class]])
    {
        RCDEntryRoomMessage *notification = (RCDEntryRoomMessage *)content;
        NSDictionary * params = [ToolsHelper dictionaryFromJson:notification.extra];
        NSString *username = params[@"username"];
        self.tipMessageLabel.text = [NSString stringWithFormat:@"%@进入了直播间",username];
    }
    
    [self.tipMessageLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.top.equalTo(self).with.offset(1);
        make.bottom.equalTo(self).with.offset(-1);
    }];
}

-(void)attributedLabel:(RCDLiveAttributedLabel *)label didTapLabel:(NSString *)content
{
    if ([self.delegate respondsToSelector:@selector(didTapMessageCell:)]) {
        [self.delegate didTapMessageCell:self.model];
    }
}

+ (CGSize)getTipMessageCellSize:(NSString *)content andMaxWidth:(CGFloat)maxWidth{
    CGSize textSize = CGSizeZero;
    textSize = RCDLive_RC_MULTILINE_TEXTSIZE_GEIOS7(content, [UIFont systemFontOfSize:16.0f], CGSizeMake(300*UIRate, MAXFLOAT));
    textSize = CGSizeMake(ceilf(textSize.width)+10, 28);
    return textSize;
}
@end
