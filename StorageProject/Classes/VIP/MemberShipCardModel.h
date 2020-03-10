//
//  MemberShipCardModel.h
//  豆豆计算器
//
//  Created by 1 on 2019/11/6.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ColumnMappingDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberShipCardModel : NSObject 

@property (nonatomic, copy) NSString *bizType;
//唯一商品ID
@property (nonatomic, copy) NSString *commodityId;
//商品类型
@property (nonatomic, copy) NSString *commodityType;
//扩展信息
@property (nonatomic, copy) NSString *extras;
//订单号
@property (nonatomic, copy) NSString *orderNum;
//商品一级目录
@property (nonatomic, copy) NSString *pclassification;
//商品的图片地址
@property (nonatomic, copy) NSString *picture;
//商品价格
@property (nonatomic, copy) NSString *price;
//商品二级目录
@property (nonatomic, copy) NSString *sclassification;
//商品标题
@property (nonatomic, copy) NSString *title;
//购买成功后的提示图片
@property (nonatomic, copy) NSString *feedBackUrl;

@property (nonatomic, copy) NSString *productId;
@property (nonatomic, copy) NSString *productName;
@property (nonatomic, copy) NSString *iaptype;


@end

NS_ASSUME_NONNULL_END
