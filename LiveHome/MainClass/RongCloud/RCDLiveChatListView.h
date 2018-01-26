//
//  RCDLiveChatListView.h
//  LiveHome
//
//  Created by chh on 2017/11/7.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RCDLiveMessageBaseCell.h"
#import "RCDLiveMessageModel.h"

@interface RCDLiveChatListView : UIView

#pragma mark - 会话页面属性

/*!
 聊天内容的消息Cell数据模型的数据源
 
 @discussion 数据源中存放的元素为消息Cell的数据模型，即RCDLiveMessageModel对象。
 */
@property(nonatomic, strong) NSMutableArray<RCDLiveMessageModel *> *conversationDataRepository;

/*!
 会话页面的CollectionView
 */
@property(nonatomic, strong) UICollectionView *conversationMessageCollectionView;

/*!
 设置进入聊天室需要获取的历史消息数量（仅在当前会话为聊天室时生效）
 
 @discussion 此属性需要在viewDidLoad之前进行设置。
 -1表示不获取任何历史消息，0表示不特殊设置而使用SDK默认的设置（默认为获取10条），0<messageCount<=50为具体获取的消息数量,最大值为50。
 */
@property (nonatomic, assign) int defaultHistoryMessageCountOfChatRoom;
@property (nonatomic, assign, readonly) int joinNum; //进入直播间的人数

- (instancetype)initWithFrame:(CGRect)frame andTargetId:(NSString *)targetId;

/*!
 发送消息(除图片消息外的所有消息)
 
 @param messageContent 消息的内容
 @param pushContent    接收方离线时需要显示的远程推送内容
 
 @discussion 当接收方离线并允许远程推送时，会收到远程推送。
 远程推送中包含两部分内容，一是pushContent，用于显示；二是pushData，用于携带不显示的数据。
 
 SDK内置的消息类型，如果您将pushContent置为nil，会使用默认的推送格式进行远程推送。
 自定义类型的消息，需要您自己设置pushContent来定义推送内容，否则将不会进行远程推送。
 
 如果您需要设置发送的pushData，可以使用RCIM的发送消息接口。
 */
- (void)sendMessage:(RCMessageContent *)messageContent
        pushContent:(NSString *)pushContent;

//发送文本消息
- (void)sendTextMessage:(RCTextMessage *)messageContent
            pushContent:(NSString *)pushContent;

- (void)scrollToBottomAnimated:(BOOL)animated;

// 清理环境（退出聊天室并断开融云连接）
- (void)quitConversationView;
@end
