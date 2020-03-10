//
//  FeedbackManager.m
//  PersonalCenter
//
//  Created by Jane on 2020/3/6.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "FeedbackManager.h"
#import "AFManager.h"
#import "LoginPublic.h"
#import "NetworkRequests.h"
#import "JsonHelper.h"


@implementation FeedbackManager


+(void)getGroupCompletionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString *modifiedVersion = [app_Version stringByReplacingOccurrencesOfString:@"." withString:@""];
    NSString *aidxStr = [NSString stringWithFormat:@"%@_",@"1012"];
    NSDictionary *paramDict = @{@"aidx":aidxStr,
                                @"currentversion":modifiedVersion,
                                @"imei": @"unknow",
                                @"mac": @"unknow",
                                @"source": @"iOS"};
    
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodGET serverUrl:@"" apiPath:KDoWhat parameters:paramDict progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSString *result =[[ NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSDictionary *aesDic = JsonHelperDictionaryFromString(result);
        NSDictionary *dic = (NSDictionary *)aesDic;
        completion(dic[@"feedBackConfig"]);
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}


/**
 上传内容和QQ或邮箱
 
 @param content 反馈内容
 @param contact 联系方式
 */
+(void)uploadFeedback:(NSString *)content contact:(NSString *)contact completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSString* phoneModel = [[UIDevice currentDevice] model];
    NSDictionary *paramDict = @{@"content":content,
                                @"contact":contact,
                                @"androidVersion": @"unknow",
                                @"apkname": @"iOS-天气-com.doudoubird.weather",
                                @"model": phoneModel,
                                @"operator": @"unknow",
                                @"appversion": app_Version,
                                @"resolution":@"unknow",
                                @"netType":@"unknow"
                                };
       
   [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KUploadFeedback parameters:paramDict progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
       completion(responseObject);
   } failure:^(NSString * _Nullable errorMessage) {
       failure(errorMessage);
   }];
    
    
    
}
//将字典转换成json格式字符串,不含\n这些符号
+ (NSString *)gs_jsonStringCompactFormatForDictionary:(NSDictionary *)dicJson {
    if (![dicJson isKindOfClass:[NSDictionary class]] || ![NSJSONSerialization isValidJSONObject:dicJson]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dicJson options:0 error:nil];
    NSString *strJson = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    return strJson;
}


@end
