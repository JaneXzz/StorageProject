//
//  PayModel.h
//  豆豆计算器
//
//  Created by 1 on 2019/11/13.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnMappingDelegate.h"


NS_ASSUME_NONNULL_BEGIN

@interface PayModel : NSObject<ColumnMappingDelegate>

@property (nonatomic, copy) NSString *accesstoken;
 
/// 服务端订单ID
@property (nonatomic, copy) NSString *orderId;

/// 商家订单号
@property (nonatomic, copy) NSString *tradeNo;

/// 支付类型
@property (nonatomic, copy) NSString *payType;

/// 交易方式
@property (nonatomic, copy) NSString *tradeType;

/// 支付应用ID
@property (nonatomic, copy) NSString *appid;

/// 商户ID
@property (nonatomic, copy) NSString *partnerid;

/// 预支付交易ID
@property (nonatomic, copy) NSString *prepayid;

/// 随机字符串
@property (nonatomic, copy) NSString *noncestr;

/// 时间戳，精度到秒
@property (nonatomic, copy) NSString *timestamp;

/// 扩展字段
@property (nonatomic, copy) NSString *packageStr;

/// 签名
@property (nonatomic, copy) NSString *sign;

/// 二维码地址（微信/支付宝）阿里应用支付QueryString
@property (nonatomic, copy) NSString *codeUrl;

@end

NS_ASSUME_NONNULL_END
