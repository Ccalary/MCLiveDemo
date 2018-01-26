//
//  RCDGiveGiftMessage.m
//  Find
//
//  Created by nie on 2017/7/1.
//  Copyright © 2017年 FindTechnology. All rights reserved.
//

#import "RCDGiveGiftMessage.h"
#import "ToolsHelper.h"

@implementation RCDGiveGiftMessage



/**
 编码将当前对象转成JSON数据
 @return 编码后的JSON数据
 */
- (NSData *)encode
{
    NSMutableDictionary * paramsDict = [NSMutableDictionary dictionary];
    [paramsDict setValue:self.extra forKey:@"extra"];
    [paramsDict setValue:self.content forKey:@"content"];
    
    NSString * jsonString = [ToolsHelper dictionaryToJson:paramsDict];
    return [jsonString dataUsingEncoding:NSUTF8StringEncoding];
}

/**
 根据给定的JSON数据设置当前实例
 @param data 传入的JSON数据
 */
- (void)decodeWithData:(NSData *)data
{
    NSString * jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary * params = [ToolsHelper dictionaryFromJson:jsonString];
    
    self.content = [params valueForKey:@"content"];
    self.extra = [params valueForKey:@"extra"];
}

/**
 应返回消息名称，此字段需个平台保持一致，每个消息类型是唯一的
 @return 消息体名称
 */
+ (NSString *)getObjectName
{
    return NOTICE_GIVEGIFTMESSAGE_OBJECTNAME;
}
/**
 返回遵循此protocol的类对象持久化的标识
 
 @return 返回持久化设定标识
 @discussion   默认实现返回 @const (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED)
 */
+(RCMessagePersistent)persistentFlag
{
    return (MessagePersistent_ISPERSISTED | MessagePersistent_ISCOUNTED);
}

// 返回在会话列表和本地通知中显示的消息内容摘要
- (NSString *)conversationDigest
{
    return self.content;
}



@end
