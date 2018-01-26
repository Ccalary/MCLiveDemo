//
//  Connect.m
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "Connect.h"
#import "BaseModel.h"
#import "AFNetworking.h"
#import "NSString+Extend.h"
#import "NSDate+Format.h"
#import "FunUtil.h"
#import "UserHelper.h"

@implementation Connect
+ (Connect *)sharedInstance {
    static Connect * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[Connect alloc] init];
    });
    return _sharedInstance;
}

#pragma mark - 加解密
/**
 获得参数的签名
 @param dict 待签名的参数
 @param date 时间
 @return 签名
 */
- (NSString *)getParamsSignWithDictionary:(NSDictionary *)dict withTime:(NSDate *)date
{
    if(dict == nil || dict.allKeys.count == 0){
        return @"";
    }
    NSMutableDictionary *params = [[NSMutableDictionary alloc]initWithDictionary:dict];
    [params setObject:[date toDateTimeUTCFormat] forKey:@"_time"];
    NSString *key = [NSString stringWithFormat:@"lhSign=%@",[date toDateTimeUTCFormat]];
    NSString * resultString = key;
    NSMutableArray *stringArray = [NSMutableArray arrayWithArray:params.allKeys];
    [stringArray sortUsingComparator: ^NSComparisonResult (NSString *str1, NSString *str2) {
        NSString *n1 = [str1 lowercaseString];
        NSString *n2 = [str2 lowercaseString];
        return [n1 compare:n2];
    }];
    for(NSString * key in stringArray){
        NSString *value = [params valueForKey:key];
        
        NSString *s = [NSString stringWithFormat:@"%@",value];
        if([FunUtil isBlankString:s])
        {
            continue;
        }
        resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"&%@=%@",[key lowercaseString],[params valueForKey:key]]];
    }
    resultString = [resultString stringByAppendingString:[NSString stringWithFormat:@"&%@",key]];
    return [resultString md5];
}

/**
 获取加密后的参数对
 
 @param parameters 待加密的参数
 @param now 时间
 @return 加密后的参数对
 */
-(NSDictionary *)getEncryptParams:(NSDictionary *)parameters withTime:(NSDate *)now
{
    if(parameters == nil || parameters.allKeys.count == 0)
    {
        return nil;
    }
    //NSLog(@"时间戳: %@",[now toDateTimeUTCFormat]);
    NSString *unencrypt = [NSString stringWithFormat:@"%@=%@+%@+%@",
                           @"LiveHomeUpload",
                           @"ios",
                           [@"ios" md5],
                           [now toDateTimeUTCFormat]];
    //NSLog(@"未md5前的密匙: %@",unencrypt);
    NSString *upkey = [unencrypt md5];
    //NSLog(@"加密key: %@",upkey);
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString * p = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    p = [p AES256EncryptWithKey:upkey];
    return @{@"upload":p};
}

-(NSDictionary *)getSignParams:(NSDictionary *)parameters withTime:(NSDate *)now
{
    if(parameters == nil || parameters.allKeys.count == 0)
    {
        return nil;
    }
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    NSString *sign = [self getParamsSignWithDictionary:parameters withTime:now];
    [params setDictionary:parameters];
    [params setValue:sign forKey:@"_sign"];
    
    NSDictionary *p = [params copy];
    params = nil;
    return p;
}

#pragma mark - get/post总控制

- (AFHTTPSessionManager *) mgrWithTime:(NSDate *)now
{
    //AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:@"http://192.168.0.224:7007/"]];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager manager] initWithBaseURL:[NSURL URLWithString:LiveHome_URL]];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.requestSerializer.timeoutInterval = 1 * 60.f;
    manager.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    manager.securityPolicy.allowInvalidCertificates = YES;
    [manager.securityPolicy setValidatesDomainName:NO];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    UIWebView* webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString* secretAgent = [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString*  useragent = [NSString stringWithFormat:@"%@ livehome/%@",secretAgent,version];
    [manager.requestSerializer setValue:useragent forHTTPHeaderField:@"User-Agent"];
    
    long time = [now toLong];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%ld",time] forHTTPHeaderField:@"lh-time"];
    [manager.requestSerializer setValue:[NSString stringWithFormat:@"%.0f,%.0f",ScreenWidth*[UIScreen mainScreen].scale,ScreenHeight*[UIScreen mainScreen].scale] forHTTPHeaderField:@"lh-screen"];
    [manager.requestSerializer setValue:@"1" forHTTPHeaderField:@"lh-e"];
    NSString *diviceID = [[UIDevice currentDevice].identifierForVendor UUIDString];
    [manager.requestSerializer setValue:diviceID forHTTPHeaderField:@"lh-user-device"];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
    
    NSString *auth = [UserHelper getMemberAuth];
    NSString *userId = [UserHelper getMemberId];
    
    if(auth && userId)
    {
        [manager.requestSerializer setValue:userId forHTTPHeaderField:@"lh-user-id"];
        [manager.requestSerializer setValue:auth forHTTPHeaderField:@"lh-user-auth"];
    }
    return manager;
}

//请求成功后加密数据解密
- (id)resolveResponseObjectWith:(NSURLSessionDataTask *)task responseObject:(id)responseObject{
    if([responseObject isKindOfClass:[NSData class]])
    {
        NSString *str= [[NSMutableString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        responseObject = str;
    }
    NSString *time;
    BOOL encrypt = NO;
    NSDate *date;
    if ([task.response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *r = (NSHTTPURLResponse *)task.response;
        time = [r allHeaderFields][@"lh-time"];
        NSString *e = [r allHeaderFields][@"lh-e"];
        if(e == nil || [FunUtil isNull:e] || [e isEqualToString: @"0"])
        {
            encrypt = NO;
        }
        else
        {
            encrypt = YES;
        }
    }
    if(time)
    {
        date = [[NSDate alloc] initWithTimeIntervalSince1970:[time integerValue]/1000];
    }
    if(responseObject)
    {
        if(encrypt)
        {
            NSString *resultkey = [NSString stringWithFormat:@"%@=%@+%@+%@",@"WKFindReturn",@"ios",[@"ios" md5],[date toDateTimeUTCFormat]];
            resultkey = [resultkey md5];//解密key
            NSString *r = [responseObject AES256DecryptWithKey:resultkey];
            responseObject = [r jsonDeserialize];
        }
        else
        {
            responseObject = [responseObject jsonDeserialize];
        }
    }
    return responseObject;
}

#pragma mark - POST/GET请求
//get
- (void)getWithUrl:(NSString*)url
        parameters:(id)parameters
       loadingText:(NSString *)text
           success:(void (^)(id response))success
   successBackFail:(void (^)(id response))successBackFail
           failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    if (text.length > 0){
        [LCProgressHUD showLoading:text];
    }
    [self doRequestWithType:ConnectRequestTypeGet url:url parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } successBackfailError:^(id responseObject) {
        successBackFail(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(operation,error);
    }];
}
//post
- (void)postWithUrl:(NSString*)url
        parameters:(id)parameters
       loadingText:(NSString *)text
           success:(void (^)(id response))success
   successBackFail:(void (^)(id response))successBackFail
           failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure{
    if (text.length > 0){
        [LCProgressHUD showLoading:text];
    }
    [self doRequestWithType:ConnectRequestTypePost url:url parameters:parameters success:^(id responseObject) {
        success(responseObject);
    } successBackfailError:^(id responseObject) {
        successBackFail(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
        failure(operation,error);
    }];
}

//图片资源上传
- (void)postImageWithUrl:(NSString*)url
              parameters:(id)parameters
             loadingText:(NSString *)text
              imageArray:(NSArray <UIImage *>*)array
                 success:(void (^)(id response))success
         successBackFail:(void (^)(id response))successBackFail
                 failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    if (text.length > 0){
        [LCProgressHUD showLoading:text];
    }
    [self doPostImageWithUrl:url parameters:parameters imageArray:array success:^(id responseObject) {
        success(responseObject);
    } successBackfailError:^(id responseObject) {
         successBackFail(responseObject);
    } failure:^(NSURLSessionDataTask *operation, NSError *error) {
         failure(operation,error);
    }];
}

/**
 get/post请求

 @param type get/post
 @param url 接口地址
 @param parameters 参数
 @param success 成功
 @param successBackfailError 返回失败
 @param failure 请求失败
 */
- (void)doRequestWithType:(ConnectRequestType)type url:(NSString*)url parameters:(id)parameters success:(void (^)(id responseObject))success
successBackfailError:(void (^)(id responseObject))successBackfailError failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    DLog(@"url:%@\nparams:%@",url,parameters);
    NSDate *now = [NSDate date];
    NSDictionary *params = [self getSignParams:parameters withTime:now];
    params = [self getEncryptParams:params withTime:now];
    AFHTTPSessionManager *manager = [self mgrWithTime:now];
    
    if (type == ConnectRequestTypeGet){
        [manager GET:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success){
                id response = [self resolveResponseObjectWith:task responseObject:responseObject];
                DLog(@"url：%@\nGET返回结果:%@",url, response);
                [self parsingRequestBack:response sucess:success successBackfailError:successBackfailError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure){
                failure(task,error);
                [LCProgressHUD showKeyWindowFailure:@"网络异常，请稍后再试"];
            }
        }];
    }else {
        [manager POST:url parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            if (success){
                id response = [self resolveResponseObjectWith:task responseObject:responseObject];
                DLog(@"url：%@\nPOST返回结果:%@",url, response);
                [self parsingRequestBack:response sucess:success successBackfailError:successBackfailError];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            if (failure){
                failure(task,error);
                [LCProgressHUD showKeyWindowFailure:@"网络异常，请稍后再试"];
                DLog(@"POST返回结果:%@", error);
            }
        }];
    }
}

/**
 图片上传（文件流上传）
 
 @param url 接口地址
 @param parameters 参数
 @param array UIImage 的数组
 @param success 成功
 @param successBackfailError 返回失败
 @param failure 请求失败
 */
- (void)doPostImageWithUrl:(NSString*)url parameters:(id)parameters imageArray:(NSArray <UIImage *>*)array success:(void (^)(id responseObject))success
     successBackfailError:(void (^)(id responseObject))successBackfailError failure:(void (^)(NSURLSessionDataTask *operation, NSError *error))failure
{
    DLog(@"/n url:%@/n params:%@",url,parameters);
    NSDate *now = [NSDate date];
    NSDictionary *params = [self getSignParams:parameters withTime:now];
    params = [self getEncryptParams:params withTime:now];
    AFHTTPSessionManager *manager = [self mgrWithTime:now];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
       
        for (UIImage *image in array){
            NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat =@"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            //上传的参数(上传图片，以文件流的格式)
            [formData appendPartWithFileData:imageData
                                        name:@"file"
                                    fileName:fileName
                                    mimeType:@"image/jpeg"];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success){
            id response = [self resolveResponseObjectWith:task responseObject:responseObject];
            DLog(@"图片上传返回结果:%@", response);
            [self parsingRequestBack:response sucess:success successBackfailError:successBackfailError];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure){
            failure(task,error);
            [LCProgressHUD showKeyWindowFailure:@"网络异常，请稍后再试"];
        }
    }];
}

/**
 * 请求成功后的数据解析
 */
- (void)parsingRequestBack:(id)responseObject
                    sucess:(void (^)(id responseObject))success
      successBackfailError:(void (^)(id responseObject))successBackfailError
{
    BaseModel *baseModel = [BaseModel mj_objectWithKeyValues:responseObject];
    if([baseModel.code intValue] == 200) //200是成功
    {
        [LCProgressHUD hide];
        success(baseModel.data);
        return;
    }
    if ([baseModel.code intValue] == 300)//请求失败
    {
        [LCProgressHUD showKeyWindowFailure:baseModel.message];
        successBackfailError(baseModel.data);
    }else {
        successBackfailError(baseModel.data);
        [LCProgressHUD hide];
    }
}
@end
