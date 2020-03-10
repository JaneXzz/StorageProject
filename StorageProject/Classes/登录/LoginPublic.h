//
//  LoginPublic.h
//  PersonalCenter
//
//  Created by Jane on 2020/3/5.
//  Copyright © 2020 Jane. All rights reserved.
//

#ifndef LoginPublic_h
#define LoginPublic_h

#if DEBUG
//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"

#else
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"

#endif

/** 电池栏高度 */
#define STATUS_BAR_HEIGHT CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)
/** 导航栏高度 */
#define NAVGATION_BAR_HEIGHT 44

/** 状态栏加导航栏 */
#define NAVGATION_STATUS_BAR_HEIGHT (NAVGATION_BAR_HEIGHT+STATUS_BAR_HEIGHT)

/** 弱引用 */
#define VSWeakSelf(type)  __weak typeof(type) weak##type = type;

/** 是否登录 */
#define KisLogin [[NSUserDefaults standardUserDefaults] boolForKey:@"isLogin"]

#define KPlaceholderColor UIColorFromRGBA(0x000000, 0.2)

/** 颜色设置带透明度*/
#define UIColorFromRGBA(rgbValue,A) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:A]

#define KAIDX @"1008"

#define KEY_UUID @"com.doudoubird.calculator"

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

//#define KPlaceholderColor UIColorFromRGBA(0x000000, 0.2)
/** 颜色设置*/
#define RGB0X(rgbValue) [UIColor colorWithRed: ((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 \
green: ((float)((rgbValue & 0xFF00) >> 8)) / 255.0 \
blue: ((float)(rgbValue & 0xFF)) / 255.0 alpha: 1.0]

#define KDuration 2


/** 微信 id*/
#define KWeiXinAppID @"wx96d331e92607b0d6"

/** 微信 secret*/
#define KWeiXinAppSecret @"e09341c01b743b0e108ad805fc02b0ba"

/** QQ id*/
#define KQQAppID @"1109626990"

#define KAlipay @"2019101768425717"


/****************URL 链接********************/


//#define KHost @"http://192.168.1.211:8202"
 #define KHost @"http://git.doudoubird.cn:8759"
//#define KHost @"http://member.doudoubird.cn"

/** 注册 */
#define KRegister [NSString stringWithFormat:@"%@/auth/api/register.do",KHost]

/** 手机号注册*/
#define KRegisterByMobile [NSString stringWithFormat:@"%@/auth/api/registerByMobile.do",KHost]

/** 手机验证码*/
#define KSendsms [NSString stringWithFormat:@"%@/auth/api/sendsms",KHost]

/** 图片验证码 */
#define KRandimage [NSString stringWithFormat:@"%@/auth/api/randimage",KHost]

/** 手机验证码修改密码 */
#define KMobileChangePassword [NSString stringWithFormat:@"%@/auth/api/mobileChangePassword.do",KHost]

/** 以旧密码修改密码 */
#define KChangePassword [NSString stringWithFormat:@"%@/auth/api/changePassword.do",KHost]

/** 检查会员属性值是否可用 */
#define KMemberCheckField [NSString stringWithFormat:@"%@/auth/api/memberCheckField.do",KHost]

/** 检查会员属性值是否已经存在 */
#define KMemberExistsField [NSString stringWithFormat:@"%@/auth/api/memberExistsField.do",KHost]

/** 登录 */
#define KLogin [NSString stringWithFormat:@"%@/auth/oauth/token",KHost]

/** 获取会员信息 */
#define KGetMemberInfo [NSString stringWithFormat:@"%@/auth/api/getMemberInfo",KHost]

/** 保存会员信息 */
#define KSaveMemberInfo [NSString stringWithFormat:@"%@/auth/api/saveMemberInfo",KHost]

/** 验证手机验证码 */
#define KChecksms [NSString stringWithFormat:@"%@/auth/api/checksms",KHost]

/** 绑定会员手机 */
#define KBindMobile [NSString stringWithFormat:@"%@/auth/api/bindMobile",KHost]

/** 退出登录 */
#define KLogout [NSString stringWithFormat:@"%@/auth/api/logout",KHost]

/** 具体商品详细信息 */
#define KCommodityInfomation [NSString stringWithFormat:@"%@/auth/api/selectCommodityInfomation",KHost]
 
/** 绑定会员QQ登录/微信登录 */
#define KBindThirdOauth [NSString stringWithFormat:@"%@/auth/api/bindThirdOauth",KHost]

/** 解绑会员QQ登录/微信登录 */
#define KUnbindThirdOauth [NSString stringWithFormat:@"%@/auth/api/unbindThirdOauth",KHost]

/** 商品下单 */
#define KOrderProduct [NSString stringWithFormat:@"%@/auth/api/orderProduct",KHost]

/** 订单查询 */
#define KQueryOrder [NSString stringWithFormat:@"%@/auth/api/queryOrder",KHost]


/** 苹果支付通知 */
#define KNotifyPay [NSString stringWithFormat:@"%@/auth/api/ipay/notifyPay",KHost]


/** 注销 */
#define KLogoutPage [NSString stringWithFormat:@"%@/auth/memberLogout/logoutPage",KHost]
//
//#define KLogoutPage @"http://192.168.1.133:1202/auth/memberLogout/logoutPage"


/**********积分接口*************/

#define KGetSignIn [NSString stringWithFormat:@"%@/auth/api/signIn",KHost]

#define KGetSignInData [NSString stringWithFormat:@"%@/auth/api/getSignInData",KHost]

#define KGetMemberTasks [NSString stringWithFormat:@"%@/auth/api/getMemberTasks",KHost]

#define KApplyMemberTask [NSString stringWithFormat:@"%@/auth/api/applyMemberTask",KHost]

#define KGetScoreRecords [NSString stringWithFormat:@"%@/auth/api/getScoreRecords",KHost]





#define KSelectCorrespondNotice [NSString stringWithFormat:@"%@/auth/api/selectCorrespondNotice",KHost]

#define KSelectDrawingInfomation [NSString stringWithFormat:@"%@/auth/api/selectDrawingInfomation",KHost]

#define KQueryPicInfo [NSString stringWithFormat:@"%@/auth/api/queryPicInfo",KHost]

#define KUploadFeedback @"http://www.doudoubird.com:8080/ddn_app/saveFeedBackInfoIOS"


#define KDoWhat @"http://www.doudoubird.com:8080/ddn_app/doWhat"


/**********支付宝提现*************/

/*** 获得支付宝授权代码**/
#define KGetAliAuthCode [NSString stringWithFormat:@"%@/auth/api/getAliAuthCode",KHost]

/*** 获得支付宝授权代码**/
#define KGetAliUserInfo [NSString stringWithFormat:@"%@/auth/api/getAliUserInfo",KHost]

/*** 积分兑换商品**/
#define KExchangeProduct [NSString stringWithFormat:@"%@/auth/api/exchangeProduct",KHost]




#endif /* LoginPublic_h */
