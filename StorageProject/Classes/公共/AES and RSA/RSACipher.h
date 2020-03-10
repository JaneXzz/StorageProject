//
//  RSACipher.h
//  玛雅日历
//
//  Created by 1 on 2019/10/23.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RSACipher : NSObject
+ (NSString *)encryptString:(NSString *)str publicKey:(NSString *)privKey;

+ (NSString *)decryptString:(NSString *)str privateKey:(NSString *)privKey;
+ (NSString *)decryptString:(NSString *)str publicKey:(NSString *)pubKey;
//随机产生的16位字符
+ (NSString *)randomlyGenerated16BitString;


@end

NS_ASSUME_NONNULL_END
