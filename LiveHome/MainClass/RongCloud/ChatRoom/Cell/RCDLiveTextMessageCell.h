//
//  RCDLiveChatRoomVC.m
//  RongChatRoomDemo
//
//  Created by nie on 2017/5/12.
//  Copyright © 2017年 rongcloud. All rights reserved.
//
#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveAttributedLabel.h"

#define Text_Message_Font_Size 16

/*!
 文本消息Cell
 */
@interface RCDLiveTextMessageCell : RCDLiveMessageBaseCell

/*!
 显示消息内容的Label
 */
@property(strong, nonatomic) RCDLiveTipLabel *textLabel;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCDLiveMessageModel *)model;

+ (CGSize)getTipMessageCellSize:(NSString *)content andMaxWidth:(CGFloat)maxWidth;
@end
