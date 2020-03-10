//
//  IntegralModel.h
//  玛雅天气
//
//  Created by 1 on 2020/2/24.
//  Copyright © 2020 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IntegralModel : NSObject

//积分量词
@property (nonatomic, copy) NSString *scoreUnitWord;

//积分单位名称
@property (nonatomic, copy) NSString *scoreUnitName;

//当前积分比例
@property (nonatomic, assign) NSInteger scoreUnitsPerYuan;

//积分提现规则描述
@property (nonatomic, copy) NSString *scoreShiftDesc;

//当前总积分
@property (nonatomic, assign) NSInteger totalScore;

//今日获取的积分
@property (nonatomic, assign) NSInteger todayScore;

//当前可用于提现的积分数
@property (nonatomic, assign) NSInteger withdrawScore;

//积分等级
@property (nonatomic, assign) NSInteger level;

//积分等级
@property (nonatomic, copy) NSString * levelName;

@end

NS_ASSUME_NONNULL_END
