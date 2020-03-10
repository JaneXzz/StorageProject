//
//  CheckInputValid.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/16.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "CheckInputValid.h"

@implementation CheckInputValid

NSString * const emailPattern = @"^[\\w!#$%&'*+/=?^_`{|}~-]+(?:\\.[\\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\\w](?:[\\w-]*[\\w])?\\.)+[\\w](?:[\\w-]*[\\w])?$";

//用户名 必须是4-32位,包含字母或汉字或数字或_或.号，必须字母或汉字或_开头
NSString * const nicknamePattern = @"^[a-zA-Z_\\u4e00-\\u9fa5][0-9a-zA-Z_.\\u4e00-\\u9fa5]{4,32}$";

//密码.~{}!@#$%^&*()<>
NSString * const passwordpattern = @"^(?![0-9]+$)(?![a-zA-Z]+$)[0-9A-Za-z.~{}!@#$%^&*<>]{6,24}$";
 
//code
NSString * const confirmCodedpattern = @"^[0-9]{6}$";

/**
验证密码合法性

@param checkString 密码
@return YES or NO
*/
+(BOOL)checkForPasswordWithInString:(NSString *)checkString {
      if (checkString.length == 0) {
          return NO;
      }
//      if (![self matchedInString:checkString withRegularString:passwordpattern]) {
//          return NO;
//      }
    
    if (checkString.length < 6 ||checkString.length > 24) {
        return NO;
    }
    //数字
    if ([self isStringContainNumberWith:checkString] == NO) {
        return NO;
    }
    //字母
    if ([self isStringContainAlphabetWith:checkString] == NO) {
         return NO;
    }
    
    if ([self hasChinese:checkString]) {
        return NO;
    }
    return YES;
}

//是否为空
//包含一个字母1个数字
+(NSString *)checkPasswordStatusString:(NSString *)checkString{
    NSString *str = @"密码必须6-24位,必须包含一个数字和一个字母,不能包含中文";
    if (checkString.length == 0) {
        return @"密码不能为空";
    }
    
    if (checkString.length < 6 ||checkString.length > 24 ) {
        return str;
    }
     
    //数字
    if ([self isStringContainNumberWith:checkString] == NO) {
        return str;
    }
    //字母
    if ([self isStringContainAlphabetWith:checkString] == NO) {
         return str;
    }
    
    if ([self hasChinese:checkString]) {
        return @"不能包含中文";
    }
    return str;
}
//判断是否包含中文
+(BOOL)hasChinese:(NSString *)str {
    for(int i=0; i< [str length];i++){
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff)
        {
            return YES;
        }
    }
    return NO;
}
//判断是否包含数字
+(BOOL)isStringContainNumberWith:(NSString *)str {
     NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
     NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
     //count是str中包含[0-9]数字的个数，只要count>0，说明str中包含数字
     if (count > 0) {
         return YES;
     }
     return NO;
 }

+(BOOL)isStringContainAlphabetWith:(NSString *)str {
    NSRegularExpression *numberRegular = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSInteger count = [numberRegular numberOfMatchesInString:str options:NSMatchingReportProgress range:NSMakeRange(0, str.length)];
    //count是str中包含[A-Za-z]数字的个数，只要count>0，说明str中包含数字
    if (count > 0) {
        return YES;
    }
    return NO;
}

/**
 验证昵称合法性
 
 @param checkString 昵称
 @return YES or NO
 */
+(BOOL)checkForNicknameWithInString:(NSString *)checkString {
    
    if (![self matchedInString:checkString withRegularString:@"^[a-zA-Z_.\\u4E00-\\u9FA5\\d]*$"]) {
        return NO;
    }
    
    if (checkString.length < 4 || checkString.length > 32 ) {
        return NO;
    }
    
    BOOL isEnglist = [self isEnglishFirst:checkString];
    BOOL isChinese = [self isChineseFirst:checkString];
    
    if (!isEnglist) {
        //没有英文开头
        if (!isChinese) {
            //没有中文开头
            return NO;
        }else{
            //中文开头
        }
    }else{
        //有英文开头
    }
    return YES;
}

+(NSString *)checkIfTheNicknameIsLegal:(NSString *)checkString {
    if (checkString.length == 0) {
        return @"昵称不能为空";
    }
    if (checkString.length < 4 || checkString.length > 32 ) {
        return @"昵称必须4-32位";
    }
    BOOL isEnglist = [self isEnglishFirst:checkString];
    BOOL isChinese = [self isChineseFirst:checkString];
    
    if (!isEnglist) {
        //没有英文开头
        if (!isChinese) {
            //没有中文开头
            return @"必须以字母或汉字或_开头";
        }else{
            //中文开头
        }
    }else{
        //有英文开头
    }
    if (![self matchedInString:checkString withRegularString:@"^[a-zA-Z_.\\u4E00-\\u9FA5\\d]*$"]) {
        return @"包含字母或汉字或数字或_或.";
    }
    return nil;
}

//  判断是否以字母开头
+(BOOL)isEnglishFirst:(NSString *)str {
    NSString *regular = @"^[A-Za-z_].+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regular];
    
    if ([predicate evaluateWithObject:str] == YES){
        return YES;
    }else{
        //开头不是字母
        return NO;
    }
}
//  判断是否以汉字开头
+(BOOL)isChineseFirst:(NSString *)str {
    int utfCode = 0;
    void *buffer = &utfCode;
    NSRange range = NSMakeRange(0, 1);
    BOOL b = [str getBytes:buffer maxLength:2 usedLength:NULL encoding:NSUTF16LittleEndianStringEncoding options:NSStringEncodingConversionExternalRepresentation range:range remainingRange:NULL];
    if (b && (utfCode >= 0x4e00 && utfCode <= 0x9fa5)){
        return YES;
    }else{
        return NO;
    }
}

/**
 验证邮箱合法性
 
 @param checkString 邮箱
 @return YES or NO
 */
+(BOOL)checkForEmailWithInString:(NSString *)checkString {
    return [self matchedInString:checkString withRegularString:emailPattern];
}

/**
 验证手机号合法性
 
 @param checkString 手机号
 @return YES or NO
 */
+(BOOL)checkForPhoneNumberWithInString:(NSString *)checkString {
    return [self validateContactNumber:checkString];
}

+(NSString *)checkThePhoneNumberStatus:(NSString *)checkString {
    if (checkString.length == 0) {
        return @"手机号码不能为空";
    }
    
    if (![self validateContactNumber:checkString]) {
        return @"手机号码格式错误";
    }
    return nil;
}

/**
 验证验证码合法性
 
 @param checkString 验证码
 @return YES or NO
 */
+(BOOL)checkForConfirmCodeWithInString:(NSString *)checkString {
    return [self matchedInString:checkString withRegularString:confirmCodedpattern];
}
 
+(NSString *)checkTheConfirmCodeStatus:(NSString *)checkString {
    if (checkString.length == 0) {
        return @"验证码不能为空";
    }
    if (![self matchedInString:checkString withRegularString:confirmCodedpattern]) {
        return @"验证码格式错误";
    }
    return nil;
}

+(BOOL)matchedInString:(NSString *)checkString withRegularString:(NSString *)pattern{
    if (!checkString) {
        return NO;
    }
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:nil];
    NSArray *matchArray = [regularExpression matchesInString:checkString options:NSMatchingReportProgress range:NSMakeRange(0,checkString.length)];
    return matchArray.count > 0;
}

+ (BOOL)validateContactNumber:(NSString *)mobileNum
{
    /**
     * 手机号码:
     * 13[0-9], 14[5,7], 15[0, 1, 2, 3, 5, 6, 7, 8, 9], 16[6], 17[5, 6, 7, 8], 18[0-9], 170[0-9], 19[89]
     * 移动号段: 134,135,136,137,138,139,150,151,152,157,158,159,182,183,184,187,188,147,178,1705,198
     * 联通号段: 130,131,132,155,156,185,186,145,175,176,1709,166
     * 电信号段: 133,153,180,181,189,177,1700,199
     */
    NSString *MOBILE = @"^1(3[0-9]|4[57]|5[0-35-9]|6[6]|7[05-8]|8[0-9]|9[89])\\d{8}$";

    NSString *CM = @"(^1(3[4-9]|4[7]|5[0-27-9]|7[8]|8[2-478]|9[8])\\d{8}$)|(^1705\\d{7}$)";
   
    NSString *CU = @"(^1(3[0-2]|4[5]|5[56]|66|7[56]|8[56])\\d{8}$)|(^1709\\d{7}$)";

    NSString *CT = @"(^1(33|53|77|8[019]|99)\\d{8}$)|(^1700\\d{7}$)";
    
    /**
     * 大陆地区固话及小灵通
     * 区号：010,020,021,022,023,024,025,027,028,029
     * 号码：七位或八位
     */
   // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
   // NSPredicate *regextestPHS = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", PHS];
    
    if(([regextestmobile evaluateWithObject:mobileNum] == YES)
       || ([regextestcm evaluateWithObject:mobileNum] == YES)
       || ([regextestct evaluateWithObject:mobileNum] == YES)
       || ([regextestcu evaluateWithObject:mobileNum] == YES)) {
        return YES;
    } else {
        return NO;
    }
}

@end
