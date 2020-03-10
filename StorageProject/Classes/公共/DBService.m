//
//  DBService.m
//  NovelRead
//
//  Created by 1 on 2018/8/21.
//  Copyright © 2018年 Jane. All rights reserved.
//

#import "DBService.h"

@implementation DBService

@synthesize dbQueue = _dbQueue;

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

/**
 先关闭原有数据库
 */
- (void)close {
    if (_dbQueue) {
        [_dbQueue close];
        _dbQueue = nil;
    }
}

- (FMDatabaseQueue * _Nonnull)dbQueue {
    if (_dbQueue == nil) {
         NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
        NSString *dbPath = [path stringByAppendingPathComponent:@"history.db"];
        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
        [self createTable];
    }
    return _dbQueue;
}

-(NSMutableArray *)dataArray{
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
/** 创建表 */
- (void)createTable {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        NSError* error = nil;
         
         
        //用户
        NSString *user_sql = @"CREATE TABLE IF NOT EXISTS user (\
        id integer PRIMARY KEY AUTOINCREMENT,\
        memberId text, \
        memberName text, \
        nickname text, \
        password text, \
        email text, \
        mobile text, \
        loginType text, \
        sex integer, \
        iconUrl text, \
        removeAdDay text, \
        qqOpenId text, \
        qqName text, \
        qqbind text, \
        wxOpenId text, \
        wxName text, \
        wxbind text, \
        modifiedAccount text, \
        accessToken text, \
        tokenType text, \
        expiresIn text, \
        loginTime integer, \
        emptyPwd text, \
        themeIds text)";
 
        NSString *integral_sql = @"CREATE TABLE IF NOT EXISTS integral (\
        id integer PRIMARY KEY AUTOINCREMENT,\
        scoreUnitWord text, \
        scoreUnitName text, \
        scoreUnitsPerYuan integer, \
        scoreShiftDesc text, \
        totalScore integer, \
        todayScore integer, \
        withdrawScore integer, \
        level integer, \
        levelName text)";
 
        
        BOOL ok = [db executeUpdate:user_sql withErrorAndBindings:&error];
        if (!ok) {
            NSLog(@"user_sql ERROR: %@", error);
        }
        
        ok = [db executeUpdate:integral_sql withErrorAndBindings:&error];
        if (!ok) {
            NSLog(@"integral_sql ERROR: %@", error);
        }
        
    }];
}

@end
