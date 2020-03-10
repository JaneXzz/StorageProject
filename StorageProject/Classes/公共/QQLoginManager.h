//
//  QQLoginManager.h
//  豆豆计算器
//
//  Created by 1 on 2019/11/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import <TencentOpenAPI/TencentOAuth.h>

NS_ASSUME_NONNULL_BEGIN

@interface QQLoginManager : NSObject<TencentSessionDelegate>

@property (nonatomic, copy) void (^ _Nullable qqSuccessful)(NSString *extraStr,NSString *appID);
@property (nonatomic, copy) void (^ _Nullable qqFailure)(NSString *error);

@property (nonatomic, assign) NSInteger count;


@property (nonatomic, strong) TencentOAuth *tencentOAuth;

+(instancetype)shareManager;
//QQ授权登录
-(void)qqLoginAuthorization;

@end

NS_ASSUME_NONNULL_END
