//
//  Connect.h
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, ConnectRequestType) {
    ConnectRequestTypeGet,
    ConnectRequestTypePost
};

@interface Connect : NSObject
+ (Connect *)sharedInstance;

/**
 get请求

 @param url 接口地址
 @param parameters 参数
 @param text 提示文字
 @param success 返回成功
 @param successBackFail 返回失败
 @param failure 请求失败
 */
- (void)getWithUrl:(NSString*)url
        parameters:(id)parameters
       loadingText:(NSString *)text
           success:(void (^)(id response))success
   successBackFail:(void (^)(id response))successBackFail
           failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

/**
 post请求
 
 @param url 接口地址
 @param parameters 参数
 @param text 提示文字
 @param success 返回成功
 @param successBackFail 返回失败
 @param failure 请求失败
 */
- (void)postWithUrl:(NSString*)url
         parameters:(id)parameters
        loadingText:(NSString *)text
            success:(void (^)(id response))success
    successBackFail:(void (^)(id response))successBackFail
            failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

/**
  图片上传

 @param url 接口地址
 @param parameters 参数
 @param text 提示文字
 @param array 图片数组
 @param success 返回成功
 @param successBackFail 返回失败
 @param failure 请求失败
 */
- (void)postImageWithUrl:(NSString*)url
              parameters:(id)parameters
             loadingText:(NSString *)text
              imageArray:(NSArray <UIImage *>*)array
                 success:(void (^)(id response))success
         successBackFail:(void (^)(id response))successBackFail
                 failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure;

@end
