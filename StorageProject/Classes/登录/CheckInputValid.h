//
//  CheckInputValid.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/16.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CheckInputValid : NSObject
/**
验证密码合法性

@param checkString 密码
@return YES or NO
*/
+(BOOL)checkForPasswordWithInString:(NSString *)checkString;
+(NSString *)checkPasswordStatusString:(NSString *)checkString;
/**
 验证昵称合法性
 
 @param checkString 昵称
 @return YES or NO
 */
+(BOOL)checkForNicknameWithInString:(NSString *)checkString;
+(NSString *)checkIfTheNicknameIsLegal:(NSString *)checkString;
/**
 验证邮箱合法性
 
 @param checkString 邮箱
 @return YES or NO
 */
+(BOOL)checkForEmailWithInString:(NSString *)checkString;

/**
 验证手机号合法性
 
 @param checkString 手机号
 @return YES or NO
 */
+(BOOL)checkForPhoneNumberWithInString:(NSString *)checkString;
+(NSString *)checkThePhoneNumberStatus:(NSString *)checkString;

/**
 验证验证码合法性
 
 @param checkString 验证码
 @return YES or NO
 */
+(BOOL)checkForConfirmCodeWithInString:(NSString *)checkString;
+(NSString *)checkTheConfirmCodeStatus:(NSString *)checkString;

@end

NS_ASSUME_NONNULL_END
