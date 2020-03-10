//
//  NSDictionary+Extension.h
//  豆豆计算器
//
//  Created by 1 on 2019/12/6.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (Extension)

+(id)changeType:(id)myObj;

//将str转换为字典
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end

NS_ASSUME_NONNULL_END
