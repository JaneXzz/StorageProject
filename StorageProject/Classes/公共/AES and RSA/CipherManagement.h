//
//  CipherManagement.h
//  玛雅日历
//
//  Created by 1 on 2019/10/23.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CipherManagement : NSObject

//传入值
+(NSDictionary *)encryption:(NSString *)value;

//解密
+(NSDictionary *)decryption:(id)responseObject;
+(NSDictionary *)fixedDecryption;

@end

NS_ASSUME_NONNULL_END
