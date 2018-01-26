//
//  RCDGiveGiftMessage.h
//  Find
//
//  Created by nie on 2017/7/1.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define NOTICE_GIVEGIFTMESSAGE_OBJECTNAME @"WK:WKGiveGiftMessage"

#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_EXTRA @"extra"

@interface RCDGiveGiftMessage : RCMessageContent<RCMessageCoding,RCMessagePersistentCompatible,RCMessageContentView>

@property (nonatomic,strong) NSString *extra;
@property (nonatomic,strong) NSString *content;

@end
