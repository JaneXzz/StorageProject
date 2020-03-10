//
//  FeedbackManager.h
//  PersonalCenter
//
//  Created by Jane on 2020/3/6.
//  Copyright © 2020 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface FeedbackManager : NSObject


+(void)getGroupCompletionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

/**
 上传内容和QQ或邮箱
 
 @param content 反馈内容
 @param contact 联系方式
 */
+(void)uploadFeedback:(NSString *)content contact:(NSString *)contact completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

+ (NSString *)gs_jsonStringCompactFormatForDictionary:(NSDictionary *)dicJson;

@end

NS_ASSUME_NONNULL_END
