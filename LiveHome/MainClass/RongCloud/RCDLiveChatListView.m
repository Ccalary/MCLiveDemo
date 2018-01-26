//
//  RCDLiveChatListView.m
//  LiveHome
//
//  Created by chh on 2017/11/7.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "RCDLiveChatListView.h"
#import "RCDLiveTipMessageCell.h"
#import "RCDLiveTextMessageCell.h"
#import "RCDGiveGiftMessageCell.h"
#import "RCDEntryRoomMessageCell.h"
#import "RCDLiveKitUtility.h"
#import "RCDLiveCollectionViewHeader.h"
#import "RCDLive.h"
#import <RongIMKit/RongIMKit.h>
#import "RCDEntryRoomMessage.h"
#import "RCDGiveGiftMessage.h"
#import "ToolsHelper.h"
#import "UserHelper.h"
#import "UserInfoModel.h"

//输入框的高度
#define MinHeight_InputView 50.0f

@interface RCDLiveChatListView()<UICollectionViewDataSource,UICollectionViewDelegate, UICollectionViewDelegateFlowLayout,RCConnectionStatusChangeDelegate>
@property(nonatomic, strong)RCDLiveCollectionViewHeader *collectionViewHeader;
/**
 *  底部显示未读消息view
 */
@property (nonatomic, strong) UIView *unreadButtonView;
@property(nonatomic, strong) UILabel *unReadNewMessageLabel;
/**
 *  滚动条不在底部的时候，接收到消息不滚动到底部，记录未读消息数
 */
@property (nonatomic, assign) NSInteger unreadNewMsgCount;
//是否正在加载消息
@property(nonatomic) BOOL isLoading;
//是否需要滚动到底部
@property(nonatomic, assign) BOOL isNeedScrollToButtom;

/**
 *  当前融云连接状态
 */
@property (nonatomic, assign) RCConnectionStatus currentConnectionStatus;

/*!
 当前会话的会话类型
 */
@property(nonatomic) RCConversationType conversationType;
/*!
 目标会话ID
 */
@property (nonatomic, strong) NSString *targetId;

@property (nonatomic, strong) UserInfoModel *useInfomodel;

@property (nonatomic, assign, readwrite) int joinNum; //进入直播间的人数
@end

//文本cell标示
static NSString *const RCDLiveTextCellID = @"RCDLiveTextCellID";

//Tip,cell标示
static NSString *const RCDLiveTipMessageCellIndentifier = @"RCDLiveTipMessageCellIndentifier";
//送礼物
static NSString *const RCDGiveGiftMessageCellID = @"RCDGiveGiftMessageCellID";
//进入直播间
static NSString *const RCDEntryRoomMessageCellIndentifier = @"RCDEntryRoomMessageCellIndentifier";

@implementation RCDLiveChatListView
- (instancetype)initWithFrame:(CGRect)frame andTargetId:(NSString *)targetId{
    if (self = [super initWithFrame:frame]){
        
        [[RCIMClient sharedRCIMClient] setRCConnectionStatusChangeDelegate:self];
        //是否关闭所有的前台消息提示音，默认值是NO
        [[RCIM sharedRCIM] setDisableMessageAlertSound:YES];
        //APP是否独占音频
        [RCIM sharedRCIM].isExclusiveSoundPlayer = YES;
        self.joinNum = 0;
        self.conversationType = ConversationType_CHATROOM;
        self.conversationDataRepository = [[NSMutableArray alloc] init];
        self.conversationMessageCollectionView = nil;
        self.targetId = targetId;
        [self registerNotification];
        self.defaultHistoryMessageCountOfChatRoom = -1;//历史消息
        [self initCollectionView];
        
        //用户信息
        NSDictionary *dic = [UserHelper getUserInfo];
        _useInfomodel = [UserInfoModel mj_objectWithKeyValues:dic];
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = _useInfomodel.userid;
        user.portraitUri = _useInfomodel.userimage;
        user.name = _useInfomodel.username;
        [RCIMClient sharedRCIMClient].currentUserInfo = user;
        
        [self jionChatRoom];
    }
    return self;
}

- (void)jionChatRoom{
    //聊天室类型进入时需要调用加入聊天室接口，退出时需要调用退出聊天室接口
    if (ConversationType_CHATROOM == self.conversationType) {
        [[RCIMClient sharedRCIMClient]
         joinChatRoom:self.targetId
         messageCount:self.defaultHistoryMessageCountOfChatRoom
         success:^{
             dispatch_async(dispatch_get_main_queue(), ^{
                 RCInformationNotificationMessage *joinChatroomMessage = [[RCInformationNotificationMessage alloc]init];
                 joinChatroomMessage.message = [NSString stringWithFormat:@"%@加入了聊天室",[RCDLive sharedRCDLive].currentUserInfo.name];
                 [self sendMessage:joinChatroomMessage pushContent:nil];
             });
         }
         error:^(RCErrorCode status) {
         }];
    }
}

// 清理环境（退出聊天室并断开融云连接）
- (void)quitConversationView {
    if (self.conversationType == ConversationType_CHATROOM) {
        //退出聊天室
        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId
                                            success:^{
                                                self.conversationMessageCollectionView.dataSource = nil;
                                                self.conversationMessageCollectionView.delegate = nil;
                                                [[NSNotificationCenter defaultCenter] removeObserver:self];
                                                
                                                //断开融云连接，如果你退出聊天室后还有融云的其他通讯功能操作，可以不用断开融云连接，否则断开连接后需要重新connectWithToken才能使用融云的功能
                                                //                                                [[RCDLive sharedRCDLive]logoutRongCloud];
                                                
//                                                dispatch_async(dispatch_get_main_queue(), ^{
//                                                    [self.navigationController popViewControllerAnimated:YES];
//                                                });
                                                
                                            } error:^(RCErrorCode status) {
                                                
                                            }];
    }
}

/**
 *  注册监听Notification
 */
- (void)registerNotification {
    //注册接收消息
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didReceiveMessageNotification:)
     name:RCDLiveKitDispatchMessageNotification
     object:nil];
}

- (void)initCollectionView{
    //聊天消息区
    UICollectionViewFlowLayout *customFlowLayout = [[UICollectionViewFlowLayout alloc] init];
    customFlowLayout.minimumLineSpacing = 0;
    customFlowLayout.sectionInset = UIEdgeInsetsMake(5.0f, 5.0f,5.0f, 5.0f);
    customFlowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    
    self.conversationMessageCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, self.frame.size.height) collectionViewLayout:customFlowLayout];
    [self.conversationMessageCollectionView setBackgroundColor:[UIColor clearColor]];
    self.conversationMessageCollectionView.showsVerticalScrollIndicator = NO;
    self.conversationMessageCollectionView.alwaysBounceVertical = YES;
    self.conversationMessageCollectionView.dataSource = self;
    self.conversationMessageCollectionView.delegate = self;
    [self addSubview:self.conversationMessageCollectionView];
    
    self.collectionViewHeader = [[RCDLiveCollectionViewHeader alloc]
                                 initWithFrame:CGRectMake(0, -50, self.bounds.size.width, 40)];
    _collectionViewHeader.tag = 1999;
    [self.conversationMessageCollectionView addSubview:_collectionViewHeader];
    //注册cell
    [self registerClass:[RCDLiveTextMessageCell class]forCellWithReuseIdentifier:RCDLiveTextCellID];//文本
    [self registerClass:[RCDLiveTipMessageCell class]forCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier];
    [self registerClass:[RCDGiveGiftMessageCell class] forCellWithReuseIdentifier:RCDGiveGiftMessageCellID];//礼物
    [self registerClass:[RCDEntryRoomMessageCell class] forCellWithReuseIdentifier:RCDEntryRoomMessageCellIndentifier];//进入直播间
}

#pragma mark - 消息注册cell
- (void)registerClass:(Class)cellClass forCellWithReuseIdentifier:(NSString *)identifier {
    [self.conversationMessageCollectionView registerClass:cellClass
                               forCellWithReuseIdentifier:identifier];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section {
    return self.conversationDataRepository.count;
}

/**
 *  每个UICollectionView展示的内容
 */
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    RCDLiveMessageBaseCell *cell = nil;
    if ([messageContent isKindOfClass:[RCTextMessage class]])
    {
        RCDLiveTextMessageCell *cells = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTextCellID forIndexPath:indexPath];
        [cells setDataModel:model];
        cell = cells;
    } else if ([messageContent isKindOfClass:[RCDGiveGiftMessage class]])
    {
        RCDGiveGiftMessageCell *cells = [collectionView dequeueReusableCellWithReuseIdentifier:RCDGiveGiftMessageCellID forIndexPath:indexPath];
        [cells setDataModel:model];
        cell = cells;
    }else if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]){
        RCDLiveTipMessageCell *__cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDLiveTipMessageCellIndentifier forIndexPath:indexPath];
        __cell.isFullScreenMode = YES;
        [__cell setDataModel:model];
        cell = __cell;
    } else if ([messageContent isKindOfClass:[RCDEntryRoomMessage class]])
    {
        RCDEntryRoomMessageCell *_cell = [collectionView dequeueReusableCellWithReuseIdentifier:RCDEntryRoomMessageCellIndentifier forIndexPath:indexPath];
        [_cell setDataModel:model];
        cell = _cell;
    }
    return cell ? cell : [[UICollectionViewCell alloc] init];
}

#pragma mark <UICollectionViewDelegateFlowLayout>

/**
 *  cell的大小
 */
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    if (model.cellSize.height > 0) {
        return model.cellSize;
    }
    RCMessageContent *messageContent = model.content;
    if ([messageContent isMemberOfClass:[RCTextMessage class]]
        || [messageContent isMemberOfClass:[RCInformationNotificationMessage class]]
        || [messageContent isMemberOfClass:[RCDGiveGiftMessage class]]
        || [messageContent isMemberOfClass:[RCDEntryRoomMessage class]])//进入房间
    {
        model.cellSize = [self sizeForItem:collectionView atIndexPath:indexPath];
    } else {
        return CGSizeZero;
    }
    return model.cellSize;
}

/**
 *  计算不同消息的具体尺寸
 */
- (CGSize)sizeForItem:(UICollectionView *)collectionView
          atIndexPath:(NSIndexPath *)indexPath {
    CGFloat width = CGRectGetWidth(collectionView.frame);
    RCDLiveMessageModel *model =
    [self.conversationDataRepository objectAtIndex:indexPath.row];
    RCMessageContent *messageContent = model.content;
    CGFloat height = 0.0f;
    CGSize labelSize;
    NSString *localizedMessage;
    
    if ([messageContent isMemberOfClass:[RCInformationNotificationMessage class]]) {
        RCInformationNotificationMessage *notification = (RCInformationNotificationMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        
         labelSize = [RCDLiveTipMessageCell getTipMessageCellSize:localizedMessage andMaxWidth:self.frame.size.width];
    }else if ([messageContent isMemberOfClass:[RCTextMessage class]])
    {
        RCTextMessage *notification = (RCTextMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        NSString *name;
        if (messageContent.senderUserInfo) {
            name = messageContent.senderUserInfo.name;
        }else {
            name = @"游客";
        }
        localizedMessage = [NSString stringWithFormat:@"%@:%@",name,localizedMessage];
    
        labelSize = [RCDLiveTextMessageCell getTipMessageCellSize:localizedMessage andMaxWidth:self.frame.size.width];
        
    }else if ([messageContent isMemberOfClass:[RCDGiveGiftMessage class]])
    {
        RCDGiveGiftMessage *notification = (RCDGiveGiftMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        
        NSDictionary *params = [ToolsHelper dictionaryFromJson:notification.extra];
        NSString *textStr =[NSString stringWithFormat:@"%@送出了礼物",params[@"username"]];
        NSString *numStr = [NSString stringWithFormat:@"X%i",[params[@"count"]intValue]];
        NSString *str =[NSString stringWithFormat:@"%@%@",textStr,numStr];
       
        labelSize = [RCDGiveGiftMessageCell getTipMessageCellSize:str andMaxWidth:self.frame.size.width];
       
    }else if ([messageContent isMemberOfClass:[RCDEntryRoomMessage class]])
    {
        RCDEntryRoomMessage *notification = (RCDEntryRoomMessage *)messageContent;
        localizedMessage = [RCDLiveKitUtility formatMessage:notification];
        labelSize = [RCDEntryRoomMessageCell getTipMessageCellSize:localizedMessage andMaxWidth:self.frame.size.width];
    }

    height = height + labelSize.height;
    return CGSizeMake(width, height);
}


- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeZero;
}

/**
 *  未读消息View
 */
- (UIView *)unreadButtonView {
    if (!_unreadButtonView) {
        _unreadButtonView = [[UIView alloc]initWithFrame:CGRectMake((self.frame.size.width - 80)/2, self.frame.size.height - MinHeight_InputView - 30, 80, 30)];
        _unreadButtonView.userInteractionEnabled = YES;
        _unreadButtonView.backgroundColor = [UIColor whiteColor];
        _unreadButtonView.alpha = 0.7;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tabUnreadMsgCountIcon:)];
        [_unreadButtonView addGestureRecognizer:tap];
        _unreadButtonView.hidden = YES;
        [self addSubview:_unreadButtonView];
        _unreadButtonView.layer.cornerRadius = 4;
    }
    return _unreadButtonView;
}

/**
 *  底部新消息文字
 *
 *  @return return value description
 */
- (UILabel *)unReadNewMessageLabel {
    if (!_unReadNewMessageLabel) {
        _unReadNewMessageLabel = [[UILabel alloc]initWithFrame:_unreadButtonView.bounds];
        _unReadNewMessageLabel.backgroundColor = [UIColor clearColor];
        _unReadNewMessageLabel.font = [UIFont systemFontOfSize:12.0f];
        _unReadNewMessageLabel.textAlignment = NSTextAlignmentCenter;
        _unReadNewMessageLabel.textColor = [UIColor grayColor];
        [self.unreadButtonView addSubview:_unReadNewMessageLabel];
    }
    return _unReadNewMessageLabel;
    
}

/**
 *  更新底部新消息提示显示状态
 */
- (void)updateUnreadMsgCountLabel{
    if (self.unreadNewMsgCount == 0) {
        self.unreadButtonView.hidden = YES;
    }
    else{
        self.unreadButtonView.hidden = NO;
        self.unReadNewMessageLabel.text = @"底部有新消息";
    }
}

/**
 *  检查是否更新新消息提醒
 */
- (void) checkVisiableCell{
    NSIndexPath *lastPath = [self getLastIndexPathForVisibleItems];
    if (lastPath.row >= self.conversationDataRepository.count - self.unreadNewMsgCount || lastPath == nil || [self isAtTheBottomOfTableView] ) {
        self.unreadNewMsgCount = 0;
        [self updateUnreadMsgCountLabel];
    }
}

/**
 *  获取显示的最后一条消息的indexPath
 *
 *  @return indexPath
 */
- (NSIndexPath *)getLastIndexPathForVisibleItems
{
    NSArray *visiblePaths = [self.conversationMessageCollectionView indexPathsForVisibleItems];
    if (visiblePaths.count == 0) {
        return nil;
    }else if(visiblePaths.count == 1) {
        return (NSIndexPath *)[visiblePaths firstObject];
    }
    NSArray *sortedIndexPaths = [visiblePaths sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSIndexPath *path1 = (NSIndexPath *)obj1;
        NSIndexPath *path2 = (NSIndexPath *)obj2;
        return [path1 compare:path2];
    }];
    return (NSIndexPath *)[sortedIndexPaths lastObject];
}

/**
 *  点击未读提醒滚动到底部
 *
 *  @param gesture gesture description
 */
- (void)tabUnreadMsgCountIcon:(UIGestureRecognizer *)gesture {
    if (gesture.state == UIGestureRecognizerStateEnded) {
        [self scrollToBottomAnimated:YES];
    }
}


/**
 *  顶部插入历史消息
 *
 *  @param model 消息Model
 */
- (void)pushOldMessageModel:(RCDLiveMessageModel *)model {
    if (!(!model.content && model.messageId > 0)
        && !([[model.content class] persistentFlag] & MessagePersistent_ISPERSISTED)) {
        return;
    }
    long ne_wId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        if (ne_wId == __item.messageId) {
            return;
        }
    }
    [self.conversationDataRepository insertObject:model atIndex:0];
}

/**
 *  加载历史消息(暂时没有保存聊天室消息)
 */
- (void)loadMoreHistoryMessage {
    long lastMessageId = -1;
    if (self.conversationDataRepository.count > 0) {
        RCDLiveMessageModel *model = [self.conversationDataRepository objectAtIndex:0];
        lastMessageId = model.messageId;
    }
    
    NSArray *__messageArray =
    [[RCIMClient sharedRCIMClient] getHistoryMessages:_conversationType
                                             targetId:_targetId
                                      oldestMessageId:lastMessageId
                                                count:10];
    for (int i = 0; i < __messageArray.count; i++) {
        RCMessage *rcMsg = [__messageArray objectAtIndex:i];
        RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMsg];
        [self pushOldMessageModel:model];
    }
    [self.conversationMessageCollectionView reloadData];
    if (_conversationDataRepository != nil &&
        _conversationDataRepository.count > 0 &&
        [self.conversationMessageCollectionView numberOfItemsInSection:0] >=
        __messageArray.count - 1) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForRow:__messageArray.count - 1 inSection:0];
        [self.conversationMessageCollectionView scrollToItemAtIndexPath:indexPath
                                                       atScrollPosition:UICollectionViewScrollPositionTop
                                                               animated:NO];
    }
}


#pragma mark <UIScrollViewDelegate>
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
}

/**
 *  滚动条滚动时显示正在加载loading
 */
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // 是否显示右下未读icon
    if (self.unreadNewMsgCount != 0) {
        [self checkVisiableCell];
    }
    
    if (scrollView.contentOffset.y < -5.0f) {
        [self.collectionViewHeader startAnimating];
    } else {
        [self.collectionViewHeader stopAnimating];
        _isLoading = NO;
    }
}

/**
 *  滚动结束加载消息 （聊天室消息还没存储，所以暂时还没有此功能）
 *
 *  @param scrollView scrollView description
 *  @param decelerate decelerate description
 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView
                  willDecelerate:(BOOL)decelerate {
    if (scrollView.contentOffset.y < -15.0f && !_isLoading) {
        _isLoading = YES;
    }
}

/**
 *  消息滚动到底部
 *
 *  @param animated 是否开启动画效果
 */
- (void)scrollToBottomAnimated:(BOOL)animated {
    if ([self.conversationMessageCollectionView numberOfSections] == 0) {
        return;
    }
    NSUInteger finalRow = MAX(0, [self.conversationMessageCollectionView numberOfItemsInSection:0] - 1);
    if (0 == finalRow) {
        return;
    }
    NSIndexPath *finalIndexPath =
    [NSIndexPath indexPathForItem:finalRow inSection:0];
    [self.conversationMessageCollectionView scrollToItemAtIndexPath:finalIndexPath
                                                   atScrollPosition:UICollectionViewScrollPositionTop
                                                           animated:animated];
}

/**
 *  判断消息是否在collectionView的底部
 *
 *  @return 是否在底部
 */
- (BOOL)isAtTheBottomOfTableView {
    if (self.conversationMessageCollectionView.contentSize.height <= self.conversationMessageCollectionView.frame.size.height) {
        return YES;
    }
    if(self.conversationMessageCollectionView.contentOffset.y +200 >= (self.conversationMessageCollectionView.contentSize.height - self.conversationMessageCollectionView.frame.size.height)) {
        return YES;
    }else{
        return NO;
    }
}

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
        pushContent:(NSString *)pushContent {
    if (_targetId == nil) {
        return;
    }
    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;
    if (messageContent == nil) {
        return;
    }
    
    [[RCDLive sharedRCDLive] sendMessage:self.conversationType
                                targetId:self.targetId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId) {
                                     __weak typeof(&*self) __weakself = self;
                                     dispatch_async(dispatch_get_main_queue(), ^{
                                         RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                                                     targetId:__weakself.targetId
                                                                                    direction:MessageDirection_SEND
                                                                                    messageId:messageId
                                                                                      content:messageContent];
//                                         if ([message.content isMemberOfClass:[RCDLiveGiftMessage class]] ) {
//                                             message.messageId = -1;//插入消息时如果id是-1不判断是否存在
//                                         }
                                         [__weakself appendAndDisplayMessage:message];
                                     });
                                 } error:^(RCErrorCode nErrorCode, long messageId) {
                                     [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
                                 }];
}


#pragma mark -发送文本消息，增加敏感词过滤
- (void)sendTextMessage:(RCTextMessage *)messageContent
        pushContent:(NSString *)pushContent {
    if (_targetId == nil) {
                return;
    }

    if (messageContent == nil) {
        return;
    }

    //敏感词过滤
    NSArray *liveKeyWordsArr = [UserHelper getLiveKeyWords];
    for (NSString *str in liveKeyWordsArr)
    {
        if([messageContent.content containsString:str])
        {
            messageContent.content = [messageContent.content stringByReplacingOccurrencesOfString:str withString:@"***"];
        }
    }

    messageContent.senderUserInfo = [RCDLive sharedRCDLive].currentUserInfo;

    RCTextMessage *message = [[RCTextMessage alloc] init];
    message.extra = [NSString stringWithFormat:@"{\"userid\":\"%@\",\"username\":\"%@\"}",
                     _useInfomodel.userid,
                     _useInfomodel.username];

    messageContent.extra = message.extra;

    [[RCDLive sharedRCDLive] sendMessage:ConversationType_CHATROOM
                                targetId:self.targetId
                                 content:messageContent
                             pushContent:pushContent
                                pushData:nil
                                 success:^(long messageId)
     {
         __weak typeof(&*self) __weakself = self;
         dispatch_async(dispatch_get_main_queue(), ^{
             RCMessage *message = [[RCMessage alloc] initWithType:__weakself.conversationType
                                                         targetId:__weakself.targetId
                                                        direction:MessageDirection_SEND
                                                        messageId:messageId
                                                          content:messageContent];
             [__weakself appendAndDisplayMessage:message];
         });
     }
     error:^(RCErrorCode nErrorCode, long messageId)
     {
         [[RCIMClient sharedRCIMClient]deleteMessages:@[ @(messageId) ]];
     }];
}


/**
 *  接收到消息的回调
 */
- (void)didReceiveMessageNotification:(NSNotification *)notification {
    __block RCMessage *rcMessage = notification.object;
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
    
    RCMessageContent *messageContent = model.content;
    if ([messageContent isKindOfClass:[RCDEntryRoomMessage class]]){//进入房间信息
        self.joinNum++;
    }
    NSDictionary *leftDic = notification.userInfo;
    if (leftDic && [leftDic[@"left"] isEqual:@(0)]) {
        self.isNeedScrollToButtom = YES;
    }
    if (model.conversationType == self.conversationType &&
        [model.targetId isEqual:self.targetId]) {
        __weak typeof(&*self) __blockSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            if (rcMessage) {
                [__blockSelf appendAndDisplayMessage:rcMessage];
                UIMenuController *menu = [UIMenuController sharedMenuController];
                menu.menuVisible=NO;
                //如果消息不在最底部，收到消息之后不滚动到底部，加到列表中只记录未读数
                if (![self isAtTheBottomOfTableView]) {
                    self.unreadNewMsgCount ++ ;
                    [self updateUnreadMsgCountLabel];
                }
            }
        });
    }
}

/**
 *  将消息加入本地数组
 */
- (void)appendAndDisplayMessage:(RCMessage *)rcMessage {
    if (!rcMessage) {
        return;
    }
    RCDLiveMessageModel *model = [[RCDLiveMessageModel alloc] initWithMessage:rcMessage];
//    if([rcMessage.content isMemberOfClass:[RCDGiveGiftMessage class]]){
//        model.messageId = -1;
//    }
    if ([self appendMessageModel:model]) {
        NSIndexPath *indexPath =
        [NSIndexPath indexPathForItem:self.conversationDataRepository.count - 1
                            inSection:0];
        if ([self.conversationMessageCollectionView numberOfItemsInSection:0] !=
            self.conversationDataRepository.count - 1) {
            return;
        }
        [self.conversationMessageCollectionView
         insertItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
        if ([self isAtTheBottomOfTableView] || self.isNeedScrollToButtom) {
            [self scrollToBottomAnimated:YES];
            self.isNeedScrollToButtom=NO;
        }
    }
}

/**
 *  如果当前会话没有这个消息id，把消息加入本地数组
 *
 *  @return bool
 */
- (BOOL)appendMessageModel:(RCDLiveMessageModel *)model {
    long newId = model.messageId;
    for (RCDLiveMessageModel *__item in self.conversationDataRepository) {
        /*
         * 当id为－1时，不检查是否重复，直接插入
         * 该场景用于插入临时提示。
         */
        if (newId == -1) {
            break;
        }
        if (newId == __item.messageId) {
            return NO;
        }
    }
    if (!model.content) {
        return NO;
    }
    //这里可以根据消息类型来决定是否显示，如果不希望显示直接return NO
    
    //数量不可能无限制的大，这里限制收到消息过多时，就对显示消息数量进行限制。
    //用户可以手动下拉更多消息，查看更多历史消息。
    if (self.conversationDataRepository.count>100) {
        //                NSRange range = NSMakeRange(0, 1);
        RCDLiveMessageModel *message = self.conversationDataRepository[0];
        [[RCIMClient sharedRCIMClient]deleteMessages:@[@(message.messageId)]];
        [self.conversationDataRepository removeObjectAtIndex:0];
        [self.conversationMessageCollectionView reloadData];
    }
    
    [self.conversationDataRepository addObject:model];
    return YES;
}

/**
 *  连接状态改变的回调
 */
- (void)onConnectionStatusChanged:(RCConnectionStatus)status {
    self.currentConnectionStatus = status;
}

@end
