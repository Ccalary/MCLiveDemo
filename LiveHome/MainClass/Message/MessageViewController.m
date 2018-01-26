//
//  MessageViewController.m
//  LiveHome
//
//  Created by chh on 2017/11/7.
//  Copyright © 2017年 chh. All rights reserved.
//
#import "MessageViewController.h"
#import "MsgDetailViewController.h"
#import "UserHelper.h"
#import "UserInfoModel.h"
@interface MessageViewController ()
@property (nonatomic, strong) UIView *defaultView;
@end

@implementation MessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initRCIM];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initRCIM{
    [self setDisplayConversationTypes:@[@(ConversationType_SYSTEM)]]; //只接受系统通知
    self.emptyConversationView = self.defaultView;//空白图
    self.conversationListTableView.tableFooterView = [[UIView alloc] init];
    [self setConversationAvatarStyle:RC_USER_AVATAR_CYCLE];//图像为圆形
    [self setConversationPortraitSize:CGSizeMake(50*UIRate, 50*UIRate)];
}

- (UIView *)defaultView{
    if (!_defaultView){
        _defaultView = [[UIView alloc] initWithFrame:self.view.frame];
        _defaultView.backgroundColor = [UIColor clearColor];
        
        UIImageView *defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 115, 115)];
        defaultImageView.image = [UIImage imageNamed:@"default_nothing_115"];
        defaultImageView.center = _defaultView.center;
        [_defaultView addSubview:defaultImageView];
        
        UILabel *stringLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(defaultImageView.frame) + 10, ScreenWidth, 20)];
        stringLabel.text = @"什么都没有哎～";
        stringLabel.font = FONT_SYSTEM(15);
        stringLabel.textAlignment = NSTextAlignmentCenter;
        stringLabel.textColor = [UIColor fontColorLightGray];
        [_defaultView addSubview:stringLabel];
    }
    return _defaultView;
}

/*!
 即将显示Cell的回调
 
 @param cell        即将显示的Cell
 @param indexPath   该Cell对应的会话Cell数据模型在数据源中的索引值
 
 @discussion 您可以在此回调中修改Cell的一些显示属性。
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell
                             atIndexPath:(NSIndexPath *)indexPath{
    //得到每个列表cell的数据模型
    RCConversationModel *model = self.conversationListDataSource[indexPath.row];
    [self requestUserShortInfoWithID:model.targetId];
}


//点击cell的回掉
- (void)onSelectedTableRow:(RCConversationModelType)conversationModelType
         conversationModel:(RCConversationModel *)model
               atIndexPath:(NSIndexPath *)indexPath{
    MsgDetailViewController *vc = [[MsgDetailViewController alloc] init];
    vc.conversationType = model.conversationType;
    vc.targetId = model.targetId;
    vc.title = model.conversationTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)requestUserShortInfoWithID:(NSString *)targetID{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:targetID forKey:@"userid"];
    [LHConnect postUserShortInfo:params loading:@"" success:^(id  _Nonnull response) {
        UserInfoModel *model = [UserInfoModel mj_objectWithKeyValues:response];
        RCUserInfo *userInfo = [[RCUserInfo alloc]initWithUserId:model.userid name:model.username portrait:model.userimage];
        
        [[RCIM sharedRCIM]refreshUserInfoCache:userInfo withUserId:targetID];
    } successBackFail:^(id  _Nonnull response) {
        
    }];
}
@end
