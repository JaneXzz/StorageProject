//
//  DBService.h
//  NovelRead
//
//  Created by 1 on 2018/8/21.
//  Copyright © 2018年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"


@interface DBService : NSObject

+(instancetype)shareInstance;
/** 使用DatabaseQueue不需要自己维护线程安全 */
@property (nonatomic, strong, readonly) FMDatabaseQueue *dbQueue;
@property (nonatomic, strong) NSMutableArray *dataArray;

@end
