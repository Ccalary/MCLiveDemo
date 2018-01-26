//
//  LiveRoomModel.h
//  LiveHome
//
//  Created by chh on 2017/11/11.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiveRoomModel : NSObject
//直播间的ID
@property (nonatomic,copy) NSString *roomid;

//主播的id
@property (nonatomic,copy) NSString *userid;

//主播昵称
@property (nonatomic,copy) NSString *username;

//主播头像
@property (nonatomic,copy) NSString *userimage;

//个性签名
@property (nonatomic,copy) NSString *ownsign;

//人气值
@property (nonatomic,assign) int pcount;

//房间号
@property (nonatomic,copy) NSString *roomno;

//是否关注
@property (nonatomic,copy) NSString *iscorcened;

//是否是守护
@property (nonatomic,assign) BOOL isguard;

//用户等级
@property (nonatomic,assign) int level;

//房间标题
@property (nonatomic,copy) NSString *roomtitle;

//粉丝数量
@property (nonatomic,copy) NSString *fanscount;

//关注数
@property (nonatomic,assign) int corcencount;

//直播流视频地址
@property (nonatomic,copy) NSString *streamurl;

//活动的图片
@property (nonatomic,copy) NSString *activityimage;

//活动的地址
@property (nonatomic,copy) NSString *activityurl;

//一个月守护的价格
@property (nonatomic,copy) NSString *guard1;

//3个月守护的价格
@property (nonatomic,copy) NSString *guard2;

//6个月守护的价格
@property (nonatomic,copy) NSString *guard3;

//12个月守护的价格
@property (nonatomic,copy) NSString *guard4;

//我的用户编号
@property (nonatomic,copy) NSString *myid;

//我的昵称
@property (nonatomic,copy) NSString *myname;

//我的头像
@property (nonatomic,copy) NSString *myheader;

// 我的等级
@property (nonatomic,assign) int mylevel;

//是否正在竞猜中
@property (nonatomic,assign) BOOL guessing;

//当前竞猜的商品编号
@property (nonatomic,copy) NSString *goodsid;

/// 标题
@property (nonatomic,copy) NSString *share_title;

/// 图片
@property (nonatomic,copy) NSString *share_img;

/// 描述
@property (nonatomic,copy) NSString *share_dec;

/// 地址
@property (nonatomic,copy) NSString *share_url;

//是否已经缴纳保证金
@property (nonatomic,assign) BOOL hasbaozhengjin;

//是否是房管
@property (nonatomic,assign) BOOL isadmin;

//是否直播
@property (nonatomic,assign)BOOL isonline;

//游戏种类 0无游戏，1是钓鱼， 2是抓娃娃
@property (nonatomic, assign) int gametype;
@end
