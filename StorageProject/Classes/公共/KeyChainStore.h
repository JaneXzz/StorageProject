//
//  KeyChainStore.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/29.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface KeyChainStore : NSObject

+ (void)save:(NSString*)service data:(id)data;

+ (id)load:(NSString*)service;

+ (void)deleteKeyData:(NSString*)service;


@end

NS_ASSUME_NONNULL_END
