//
//  DBServiceUser.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/15.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "DBService.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN
typedef DBService DBServiceUser;

@interface DBService (User) 
//插入一条数据
-(BOOL)insertUserOneData:(UserModel *)model;
//更新
- (BOOL)updateUserModel:(UserModel *)model;
//获取所有的数据
-(UserModel *)getUserAlldata;
//删除一条数据
-(BOOL)removeUserOneData:(int)Id;
//清空所有数据
-(BOOL)clearUserTable;

@end

NS_ASSUME_NONNULL_END
