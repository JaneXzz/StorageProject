//
//  NetworkRequests.h
//  玛雅天气
//
//  Created by 1 on 2019/12/31.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^CompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^SuccessBlock)(NSDictionary *dic);
typedef void (^FailureBlock)(NSString *error);

@interface NetworkRequests : NSObject

/**
 *  get请求
 */
+ (void)getWithUrlString:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;
 
@end

NS_ASSUME_NONNULL_END
