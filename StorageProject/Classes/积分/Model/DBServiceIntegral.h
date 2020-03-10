//
//  DBServiceIntegral.h
//  玛雅天气
//
//  Created by 1 on 2020/2/24.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "DBService.h"
#import "IntegralModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef DBService DBServiceIntegral;

@interface DBService (Integral)
//插入一条数据
-(BOOL)insertIntegralOneData:(IntegralModel *)model;
//更新
- (BOOL)updateIntegralModel:(IntegralModel *)model;
//获取所有的数据
-(IntegralModel *)getIntegralAlldata;
//删除一条数据
-(BOOL)removeIntegralOneData:(int)Id;
//清空所有数据
-(BOOL)clearIntegralTable;

@end
NS_ASSUME_NONNULL_END
