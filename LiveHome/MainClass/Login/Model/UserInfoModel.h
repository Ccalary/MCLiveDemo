//
//  UserInfoModel.h
//  LiveHome
//
//  Created by chh on 2017/11/10.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface UserInfoModel : NSObject

/** 用户ID */
@property (nonatomic,copy) NSString *userid;

/** 用户头像 */
@property (nonatomic,copy) NSString *userimage;

/** 用户昵称 */
@property (nonatomic,copy) NSString *username;

/** 属性 0-事业单位 1-外企 2-私企 3-民企*/
@property (nonatomic,copy) NSString *prop;

/** 转化后的单位属性 */
@property (nonatomic,copy) NSString *propName;

/** 用户性别 1-男 2-女*/
@property (nonatomic,copy) NSString *sex;

/** 账户id */
@property (nonatomic,copy) NSString *findid;

/** 省 */
@property (nonatomic,copy) NSString *province;

/** 市 */
@property (nonatomic,copy) NSString *city;

/** 实名认证状态 0-未申请认证 1-待审核 2-审核通过 3-审核不通过*/
@property (nonatomic,copy) NSString *iscer;

/** 转化后的认证状态 */
@property (nonatomic,copy) NSString *cerStr;
@end
