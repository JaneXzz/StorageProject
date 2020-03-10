//
//  VIPMemberVC.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasisViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshCallBlock)(void);


@interface VIPMemberVC : BasisViewController

typedef NS_ENUM(NSUInteger, PayType) {
    WeChatPaymentType = 0,           //微信
    WeChatScanCodePaymentType = 1,   //微信扫码
    AlipayPaymentType = 10,           //支付宝
    AlipayScanCodePaymentType = 11,   //支付宝扫码
    ApplePay = 20,   //苹果支付

};
@property (nonatomic, assign) BOOL isLogin;
@property (nonatomic, assign) BOOL isRefresh;

@property (nonatomic, strong) RefreshCallBlock refreshBlock;


@end

NS_ASSUME_NONNULL_END
