//
//  DatabaseUtil.h
//  Demo
//
//  Created by bomo on 2017/2/17.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import "FMDB.h"

/** 数据库工具类 */
@interface DatabaseUtil : NSObject

/** 数据库列转Model，自动映射 */
+ (id)resultSetForModel:(FMResultSet *)set class:(Class)aClass;

/** 数据库列转Model，自动映射 */
+ (id)resultSetForModel:(FMResultSet *)set model:(id)model;

@end
