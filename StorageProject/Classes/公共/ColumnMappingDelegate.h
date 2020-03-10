//
//  DatabaseUtil.h
//  Demo
//
//  Created by bomo on 2017/2/17.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 用于数据库Column到属性的映射 */
@protocol ColumnMappingDelegate <NSObject>

@required
/** 数据库column到属性的映射（如果只定义不同的即可） */
+ (NSDictionary *)dbColumnMap;

@end
