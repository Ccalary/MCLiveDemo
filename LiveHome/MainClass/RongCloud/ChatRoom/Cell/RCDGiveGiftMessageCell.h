//
//  RCDGiveGiftMessageCell.h
//  Find
//
//  Created by nie on 2017/7/1.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveAttributedLabel.h"

@interface RCDGiveGiftMessageCell : RCDLiveMessageBaseCell

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
