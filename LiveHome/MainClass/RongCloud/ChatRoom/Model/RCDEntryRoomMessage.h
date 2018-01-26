//
//  RCDEntryRoomMessage.h
//  Find
//
//  Created by nie on 2017/6/29.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import <RongIMLib/RongIMLib.h>

#define NOTICE_WKENTRYROOMMESSAGE_OBJECTNAME @"WK:WKEntryRoomMessage"
#define KEY_TXTMSG_CONTENT @"content"
#define KEY_TXTMSG_EXTRA @"extra"

@interface RCDEntryRoomMessage : RCMessageContent<RCMessageCoding,RCMessagePersistentCompatible,RCMessageContentView>

@property (nonatomic,strong) NSString *extra;
@property (nonatomic,strong) NSString *content;

@end
