//
//  AESCipher.h
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import <Foundation/Foundation.h>

@interface AESCipher : NSObject

//加密
+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key;
//解密
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key;

@end
 
