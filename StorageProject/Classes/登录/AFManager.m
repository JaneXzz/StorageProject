
//
//  AFManager.m
//  Weather
//
//  Created by 1 on 2019/1/22.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "AFManager.h"

@interface AFManager ()

@property (retain,nonatomic) NSMutableArray *connectFailArr;
@property (nonatomic, strong) AFHTTPSessionManager *sessionManager;

@end

@implementation AFManager

static AFManager *networkManager = nil;
//static int netWorkState;
+ (instancetype)sharedManager {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!networkManager) {
            networkManager = [[AFManager alloc] init];
        }
        [networkManager chectReachAbility];
    });
    return networkManager;
}

/**
 初始化，APP每次启动时会调用该方法，运行时不会调用
 
 @return 基本的请求设置
 */
- (instancetype)init {
    if (self = [super init]) {
        self.sessionManager = [AFHTTPSessionManager manager];
        // 设置请求以及相应的序列化器
//        self.sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
        self.sessionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        // 设置响应内容的类型
        self.sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/java script",@"text/html",@"text/plain",nil];
//         [self.sessionManager.requestSerializer setValue:@"" forHTTPHeaderField:@"If-None-Match"];
        self.sessionManager.requestSerializer.timeoutInterval = 60;
 
    }
    return self;
}

-(void)chectReachAbility
{
    /**
     AFNetworkReachabilityStatusUnknown = -1, // 未知
     AFNetworkReachabilityStatusNotReachable = 0, // 无连接
     AFNetworkReachabilityStatusReachableViaWWAN = 1, // 3G 花钱
     AFNetworkReachabilityStatusReachableViaWiFi = 2, // 局域网络,不花钱
     */
    
    // 检测网络连接的单例,网络变化时的回调方法
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        self->_reachAbility = status;
    }];
    // 如果要检测网络状态的变化,必须用检测管理器的单例的startMonitoring
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
}

- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod
                                           serverUrl:(nonnull NSString *)serverUrl
                                             apiPath:(nonnull NSString *)apiPath
                                          parameters:(nullable id)parameters
                                            progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                             success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                             failure:(nullable void(^) (NSString * _Nullable errorMessage))failure {
    // 请求的地址
    NSString *requestPath = [serverUrl stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    switch (requestMethod) {
        case HTTPMethodGET:
        {
            task = [self.sessionManager GET:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPOST:
        {
            task = [self.sessionManager POST:requestPath parameters:parameters progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPUT:
        {
            task = [self.sessionManager PUT:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodPATCH:
        {
            task = [self.sessionManager PATCH:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure([self failHandleWithErrorResponse:error task:task]);
                }
            }];
        }
            break;
            
        case HTTPMethodDELETE:
        {
            task = [self.sessionManager DELETE:requestPath parameters:parameters success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(YES,responseObject);
                }            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    if (failure) {
                        failure([self failHandleWithErrorResponse:error task:task]);
                    }
                }];
        }
            break;
    }
    return task;
}

- (nullable NSURLSessionDataTask *)sendPOSTRequestWithserverUrl:(nonnull NSString *)serverUrl
                                                        apiPath:(nonnull NSString *)apiPath
                                                     parameters:(nullable id)parameters
                                                     imageArray:(NSArray *_Nullable)imageArray
                                                    targetWidth:(CGFloat )width
                                                       progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                                        success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                                        failure:(nullable void(^) (NSString  *_Nullable error))failure {
    // 请求的地址
    NSString *requestPath = [serverUrl stringByAppendingPathComponent:apiPath];
    NSURLSessionDataTask * task = nil;
    task = [self.sessionManager POST:requestPath parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
 
        
    } progress:progress success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
 
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
 
    }];
    return task;
}
- (NSString *)failHandleWithErrorResponse:( NSError * _Nullable )error task:( NSURLSessionDataTask * _Nullable )task {
    __block NSString *message = nil;
    // 这里可以直接设定错误反馈，也可以利用AFN 的error信息直接解析展示
    if ([error localizedDescription]) {
        message = error.localizedDescription;
        if ([message isEqualToString:@"请求超时。"]) {
            message = @"请求超时";
        }
    }else{
        NSData *afNetworking_errorMsg = [error.userInfo objectForKey:AFNetworkingOperationFailingURLResponseDataErrorKey];
        if (!afNetworking_errorMsg) {
            message = @"网络连接失败";
        }
        NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
        NSInteger responseStatue = response.statusCode;
        if (responseStatue >= 500) {  // 网络错误
            message = @"服务器维护升级中,请耐心等待";
        } else if (responseStatue >= 400) {
            // 错误信息
            NSDictionary *responseObject = [NSJSONSerialization JSONObjectWithData:afNetworking_errorMsg options:NSJSONReadingAllowFragments error:nil];
            message = responseObject[@"error"];
            if ([message isEqualToString:@"请求超时。"]) {
                message = @"请求超时";
            }
        }
    }
    return message;
}

- (void)postWithURLString:(NSString *)URLString
               parameters:(id)parameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manage = [AFHTTPSessionManager manager];
    [manage.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    manage.requestSerializer = [AFHTTPRequestSerializer serializer];
    manage.responseSerializer = [AFHTTPResponseSerializer serializer];
    manage.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/javascript",@"text/plain",@"", nil];
    [manage POST:URLString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
//        for (NSString *key in [parameters allKeys]) {
//            [formData appendPartWithFormData:[[parameters objectForKey:key] dataUsingEncoding:NSUTF8StringEncoding] name:key];
//        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {

    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *resultDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil]; 
        success(resultDic);

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
 
}


@end
