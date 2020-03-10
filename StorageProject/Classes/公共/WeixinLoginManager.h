//
//  WeixinLoginManager.h
//  豆豆计算器
//
//  Created by 1 on 2019/11/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WeixinLoginManager : NSObject

@property (nonatomic, copy) void (^ _Nullable successful)(NSString *extraStr,NSString *appID);

@property (nonatomic, strong) void (^ _Nullable failure)(NSString *error);
@property (nonatomic, assign) BOOL isAuthorization;//授权


+(instancetype)shareManager;
//登录授权
-(void)sendAuthRequest;

- (void)WeChatShare;

- (void)weChatAuthorization:(nullable void (^)(NSString *extraStr,NSString *appID))successful;

@end

NS_ASSUME_NONNULL_END
