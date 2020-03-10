///
//  AFManager.h
//  Weather
//
//  Created by 1 on 2019/1/22.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
/**
 * GET：获取资源，不会改动资源
 * POST：创建记录
 * PATCH：改变资源状态或更新部分属性
 * PUT：更新全部属性
 * DELETE：删除资源
 */
typedef NS_ENUM(NSUInteger, HTTPMethod) {
    
    HTTPMethodGET,
    HTTPMethodPOST,
    HTTPMethodPUT,
    HTTPMethodPATCH,
    HTTPMethodDELETE,
};

@interface AFManager : NSObject
@property (assign,nonatomic,readonly) AFNetworkReachabilityStatus reachAbility;

+ (instancetype _Nullable )sharedManager;
- (nullable NSURLSessionDataTask *)sendRequestMethod:(HTTPMethod)requestMethod
                                           serverUrl:(nonnull NSString *)serverUrl
                                             apiPath:(nonnull NSString *)apiPath
                                          parameters:(nullable id)parameters
                                            progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                             success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                             failure:(nullable void(^) (NSString * _Nullable errorMessage))failure ;

- (nullable NSURLSessionDataTask *)sendPOSTRequestWithserverUrl:(nonnull NSString *)serverUrl
                                                        apiPath:(nonnull NSString *)apiPath
                                                     parameters:(nullable id)parameters
                                                     imageArray:(NSArray *_Nullable)imageArray
                                                    targetWidth:(CGFloat )width
                                                       progress:(nullable void (^)(NSProgress * _Nullable progress))progress
                                                        success:(nullable void(^) (BOOL isSuccess, id _Nullable responseObject))success
                                                        failure:(nullable void(^) (NSString *_Nullable error))failure ;


/**
 *  发送post请求
 *
 *  @param URLString  请求的网址字符串
 *  @param parameters 请求的参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 */
- (void)postWithURLString:(NSString *_Nullable)URLString
               parameters:(id _Nullable )parameters
                  success:(void (^_Nullable)(id _Nullable responseObject))success
                  failure:(void (^_Nullable)(NSError * _Nullable error))failure;
@end
