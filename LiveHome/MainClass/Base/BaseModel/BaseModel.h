//
//  BaseModel.h
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 wk_Success = 200,       //成功
 wk_NetworkFail = 201,   //调用接口出错,由本地调用代码报错，例如网络环境不正确，连不上网络等
 wk_Known = 300,         //已知异常，如果可能，显示ApiResultData的message
 wk_NeedLogin = 301,     //需要登录
 wk_LackHeaders = 302,   //缺少头部
 wk_Sign = 303,          //签名错误
 wk_Auth = 304,          //登录授权失败
 wk_Config = 305,        //服务器端接口问题，服务器配置错误，例如短信配置等
 wk_Unknown = 399,       //服务器端接口问题，未知异常，请联系服务器端
 wk_Analysis = 400,      //解析错误
 wk_Paramters = 401,     //调用参数不正确
 wk_FaceEnough = 402,    //笑脸已满
 wk_FaceOutTime = 403,   //笑脸的时间不到
 wk_FaceEmpty = 404,     //无笑脸
 */
@interface BaseModel : NSObject
/** 状态码 */
@property (nonatomic,copy) NSString *code;
/** 返回的信息 */
@property (nonatomic,copy) NSString *message;
/* 共用数据字典 */
@property (nonatomic,strong) id data;
@end
