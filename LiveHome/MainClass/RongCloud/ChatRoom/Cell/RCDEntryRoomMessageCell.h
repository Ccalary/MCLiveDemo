//
//  RCDEntryRoomMessageCell.h
//  Find
//
//  Created by nie on 2017/6/29.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "RCDLiveMessageBaseCell.h"

@interface RCDEntryRoomMessageCell : RCDLiveMessageBaseCell

/*!
 XXX加入聊天室的Label
 */
@property(strong, nonatomic) RCDLiveTipLabel *tipMessageLabel;

/*!
 设置当前消息Cell的数据模型
 
 @param model 消息Cell的数据模型
 */
- (void)setDataModel:(RCDLiveMessageModel *)model;

+ (CGSize)getTipMessageCellSize:(NSString *)content andMaxWidth:(CGFloat)maxWidth;
@end
