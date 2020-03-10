//
//  DBServiceUser.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/15.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "DBServiceUser.h"
#import "LoginPublic.h"
#import "DatabaseUtil.h"
#import "DBServiceIntegral.h"

@implementation DBService (User)
//插入一条数据
-(BOOL)insertUserOneData:(UserModel *)model{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"insert into user (memberId,memberName,nickname,password,email,mobile,loginType,sex,iconUrl,removeAdDay,qqOpenId,qqName, qqbind,wxOpenId,wxName,wxbind,modifiedAccount,accessToken,tokenType,expiresIn,loginTime,emptyPwd,themeIds) values(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",model.memberId,model.memberName,model.nickname,model.password,model.email,model.mobile,model.loginType,@(model.sex),model.iconUrl,model.removeAdDay,model.qqOpenId,model.qqName, model.qqbind,model.wxOpenId,model.wxName,model.wxbind,model.modifiedAccount,model.accessToken,model.tokenType,model.expiresIn,@([self  integerGetCurrentTimestamp]),model.emptyPwd,model.themeIds];
    }];
    return result;
}

/** 根据token更新数据 */
- (BOOL)updateUserModel:(UserModel *)model{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"UPDATE user set memberId = ?,memberName = ?,nickname = ?,password = ?,email = ?,mobile = ?,loginType = ?,sex = ?,iconUrl = ?,removeAdDay = ?,qqOpenId = ?,qqName = ?, qqbind = ?,wxOpenId = ?,wxName = ?,wxbind = ?,modifiedAccount = ?,tokenType = ?,expiresIn = ?,loginTime = ?,emptyPwd = ?,themeIds = ? where accessToken = ?",model.memberId,model.memberName,model.nickname,model.password,model.email,model.mobile,model.loginType,@(model.sex),model.iconUrl,model.removeAdDay,model.qqOpenId,model.qqName, model.qqbind,model.wxOpenId,model.wxName,model.wxbind,model.modifiedAccount,model.tokenType,model.expiresIn,@([self  integerGetCurrentTimestamp]),model.emptyPwd,model.themeIds,model.accessToken];
    }];
    return result;
}


//获取所有的数据
-(UserModel *)getUserAlldata{
    
    __block UserModel *userModel = [[UserModel alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * from user"];
        while ([result next]) {
            userModel = [DatabaseUtil resultSetForModel:result class:[UserModel class]];
        }
        [result close];
    }];
    userModel.integralModel = [[DBServiceIntegral shareInstance] getIntegralAlldata];

    return userModel;
}

//删除一条数据
-(BOOL)removeUserOneData:(int)Id{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sql = @"DELETE FROM user WHERE id = ?";
        result = [db executeUpdate:sql,@(Id)];
    }];
    return result;
}

-(BOOL)clearUserTable {
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sql = @"DELETE FROM user";
        result = [db executeUpdate:sql];
    }];
    return result;
}

- (NSInteger)integerGetCurrentTimestamp{
    NSDate *dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSInteger time = round(a);
    return time;
}

@end
