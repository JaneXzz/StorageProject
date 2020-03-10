//
//  DBServiceIntegral.m
//  玛雅天气
//
//  Created by 1 on 2020/2/24.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "DBServiceIntegral.h"
#import "LoginPublic.h"
#import "DatabaseUtil.h"


 

@implementation DBService (Integral)
//插入一条数据
-(BOOL)insertIntegralOneData:(IntegralModel *)model{
    [self clearIntegralTable];
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"insert into integral (scoreUnitWord,scoreUnitName,scoreUnitsPerYuan,scoreShiftDesc,totalScore,todayScore,withdrawScore,level,levelName) values(?,?,?,?,?,?,?,?,?)",model.scoreUnitWord,model.scoreUnitName,@(model.scoreUnitsPerYuan),model.scoreShiftDesc,@(model.totalScore),@(model.todayScore),@(model.withdrawScore),@(model.level),model.levelName];
    }];
    return result;
}

/** 根据token更新数据 */
- (BOOL)updateIntegralModel:(IntegralModel *)model{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        result = [db executeUpdate:@"UPDATE integral set scoreUnitWord = ?,scoreUnitName = ?,scoreUnitsPerYuan = ?,scoreShiftDesc = ?,totalScore = ?,todayScore = ?,withdrawScore = ?,level = ?,levelName = ?",model.scoreUnitWord,model.scoreUnitName,@(model.scoreUnitsPerYuan),model.scoreShiftDesc,@(model.totalScore),@(model.todayScore),@(model.withdrawScore),@(model.level),model.levelName];
    }];
    return result;
}


//获取所有的数据
-(IntegralModel *)getIntegralAlldata{
    __block IntegralModel *integralModel = [[IntegralModel alloc] init];
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet *result = [db executeQuery:@"SELECT * from integral"];
        while ([result next]) {
            integralModel.scoreUnitWord = [result stringForColumn:@"scoreUnitWord"];
            integralModel.scoreUnitName = [result stringForColumn:@"scoreUnitName"];
            integralModel.scoreUnitsPerYuan = [result intForColumn:@"scoreUnitsPerYuan"];
            integralModel.scoreShiftDesc = [result stringForColumn:@"scoreShiftDesc"];
            integralModel.totalScore = [result intForColumn:@"totalScore"];
            integralModel.todayScore = [result intForColumn:@"todayScore"];
            integralModel.withdrawScore = [result intForColumn:@"withdrawScore"];
            integralModel.level = [result intForColumn:@"level"];
            integralModel.levelName = [result stringForColumn:@"levelName"];
        }
        [result close];
    }];
    return integralModel;
}

//删除一条数据
-(BOOL)removeIntegralOneData:(int)Id{
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sql = @"DELETE FROM integral WHERE id = ?";
        result = [db executeUpdate:sql,@(Id)];
    }];
    return result;
}

-(BOOL)clearIntegralTable {
    __block BOOL result = NO;
    [self.dbQueue inDatabase:^(FMDatabase *db) {
        static NSString *sql = @"DELETE FROM integral";
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
