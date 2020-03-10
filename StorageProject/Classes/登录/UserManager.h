//
//  UserManager.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/15.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserManager : NSObject

//手机验证码
+(void)getSendSMS:(NSString *)mobile completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//登录:(1.短信验证码,2.密码登录)
+(void)getLogin:(NSString *)userName password:(NSString *)password type:(NSString *)loginType completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//登录:(QQ登录和微信登录)
+(void)getThirdLoginLogin:(NSString *)appid extra:(NSString *)extraStr type:(NSString *)loginType completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//注册手机号码和密码
+(void)getRegisterByMobile:(NSString *)mobilePhone password:(NSString *)password smsCode:(NSString *)smsCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//检验手机号码是否存在
+(void)getMemberExistsField:(NSString *)mobile isRegistered:(BOOL)isRegistered completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//手机验证修改密码
+(void)getMobileChangePassword:(NSString *)mobile smsCode:(NSString *)smsCode password:(NSString *)password completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//旧密码换为新密码
+(void)getChangePassword:(NSString *)accessToken password:(NSString *)password newPassword:(NSString *)newPassword completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//检测会员属性是否可以
+(void)getMemberCheckField:(NSString *)fieldValue fieldType:(NSString *)fieldType completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//获取会员信息
+(void)getMemberInfo:(NSString *)accessToken appId:(NSString *)aidx completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//保存会员信息
//+(void)getSaveMemberInfo:(NSString *)accessToken appId:(NSString *)memberName nickName:(NSString *)nickName  completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//退出
+(void)getLogout:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//修改信息
+(void)getModifyUserInformationAccessToken:(NSString *)accessToken content:(NSString *)content type:(NSString *)type completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//验证手机号码
+(void)getCheckSMS:(NSString *)mobile smsCode:(NSString *)smsCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//绑定手机
+(void)getBindMobile:(NSString *)accessToken oldMobile:(NSString *)oldMobile oldSmsCode:(NSString *)oldSmsCode newMobile:(NSString *)newMobile smsCode:(NSString *)smsCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//具体商品详情
+(void)getCommodityInfomation:(NSString *)accessToken payMode:(NSInteger)payModel completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//QQand微信的绑定
+(void)getBindThirdOauth:(NSString *)accessToken openId:(NSString *)openId thirdType:(NSString *)type extra:(NSString *)extra completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//解除绑定
+(void)getUnbindThirdOauth:(NSString *)accessToken thirdType:(NSString *)type completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//商品下单
+(void)getOrderProduct:(NSString *)accessToken commodityId:(NSString *)commodityId commodityType:(NSString *)commodityType amount:(NSString *)amount payType:(NSString *)payType productId:(NSString *)productId iaptype:(NSString *)iaptype completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//检测微信支付是否成功
+(void)getQueryOrder:(NSString *)accessToken orderId:(NSString *)orderId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;
//用户通知
+(void)getSelectCorrespondNoticeMemberId:(NSString *)memberId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//假日图片
//+(void)getQueryPicInfoCompletionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//苹果支付通知
+(void)getNotifyPay:(NSString *)accessToken orderId:(NSString *)orderId  receipt:(NSString *)receipt completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

 


/************积分相关接口**********/

//签到
+(void)getSignIn:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//签到数据信息
+(void)getSignInData:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//获取积分任务列表
+(void)getMemberTasks:(NSString *)accessToken appId:(NSString *)appId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//完成任务得积分
+(void)applyMemberTask:(NSString *)accessToken appId:(NSString *)appId taskId:(NSString *)taskId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//获取积分纪录
+(void)getScoreRecords:(NSString *)accessToken month:(NSString *)month startDay:(NSString *)startDay endDay:(NSString *)endDay limit:(NSString *)limit lastId:(NSString *)lastId consumed:(NSString *)consumed scoreType:(NSString *)scoreType scoreTypes:(NSString *)scoreTypes completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//积分兑换商品
+(void)exchangeProduct:(NSString *)accessToken commodityId:(NSString *)commodityId commodityType:(NSString *)commodityType score:(NSString *)score wxOpenId:(NSString *)wxOpenId aliAccount:(NSString *)aliAccount completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

//支付宝

+(void)getAliAuthCode:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

+(void)getAliUserInfo:(NSString *)accessToken authCode:(NSString *)authCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure;

 

@end

NS_ASSUME_NONNULL_END
