//
//  DatabaseUtil.m
//  Demo
//
//  Created by bomo on 2017/2/17.
//  Copyright © 2017年 bomo. All rights reserved.
//

#import "DatabaseUtil.h"
#import "ColumnMappingDelegate.h"

@implementation DatabaseUtil

+ (id)resultSetForModel:(FMResultSet *)set class:(Class)aClass
{
    id model = [[aClass alloc] init];
    return [self resultSetForModel:set model:model];
}

+ (id)resultSetForModel:(FMResultSet *)set model:(NSObject<ColumnMappingDelegate> *)model
{
    NSInteger columnCount = set.columnCount;
    NSDictionary *map = [model.class dbColumnMap];
    for (int i = 0; i < columnCount; i++) {
        NSString *columnName = [set columnNameForIndex:i];
        NSString *propertyName = [map objectForKey:columnName];
        id value = [set objectForColumnIndex:i];
//        NSLog(@"columnName = %@ propertyName = %@ value = %@",columnName,propertyName,value);
        if (value) {
            if (value != [NSNull null]) {
                if (propertyName) {
                    [model setValue:value forKey:propertyName];
                } else {
                    [model setValue:value forKey:columnName];
                }
            }
        }
    }
    return model;
}

@end
