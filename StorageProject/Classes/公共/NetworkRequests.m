//
//  NetworkRequests.m
//  玛雅天气
//
//  Created by 1 on 2019/12/31.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "NetworkRequests.h"
#import "CipherManagement.h"
#import "JsonHelper.h"

@implementation NetworkRequests
/**
 *  get请求
 */
+ (void)getWithUrlString:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
}

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(NSDictionary *)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock{
    
    NSURL *tempUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tempUrl];
    request.HTTPMethod = @"POST";
    NSString *bodyStr = [NSString stringWithFormat:@"key=%@&paramd=%@",parameters[@"key"],parameters[@"paramd"]];
    request.HTTPBody = [bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
             if (error) {
                 failureBlock(error.localizedDescription);
             } else {
                 NSDictionary *dic = [self stringConversion:data];
                 NSString *errorStr = dic[@"error"];
                 if (errorStr) {
                     NSString *messageStr = dic[@"message"];
                     failureBlock(messageStr);
                 }else{
                     successBlock(dic);
                 }
             }
        });
    }];
    [dataTask resume];
    
}

+(NSDictionary *)stringConversion:(id)responseObject{
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSDictionary *aesDic = JsonHelperDictionaryFromString(result);
    NSDictionary *dic = [CipherManagement decryption:aesDic];
    return dic;
}

@end
