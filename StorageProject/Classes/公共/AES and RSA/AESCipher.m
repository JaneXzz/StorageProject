//
//  AESCipher.m
//  AESCipher
//
//  Created by Welkin Xie on 8/13/16.
//  Copyright © 2016 WelkinXie. All rights reserved.
//
//  https://github.com/WelkinXie/AESCipher-iOS
//

#import "AESCipher.h"
#import <CommonCrypto/CommonCryptor.h>
#import <iconv.h>


NSString const *kInitVector = @"16-Bytes--String";//@"A-16-Byte-String";
size_t const kKeySize = kCCKeySizeAES128;

@implementation AESCipher

+ (NSString *)encryptAES:(NSString *)content key:(NSString *)key {

    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *contentData = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSUInteger dataLength = contentData.length;
    
    // 密文长度 <= 明文长度 + BlockSize
    size_t encryptSize = dataLength + kCCBlockSizeAES128;
    void *encryptedBytes = malloc(encryptSize);
    size_t actualOutSize = 0;
    
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt,
                                          kCCAlgorithmAES,
                                          kCCOptionPKCS7Padding,
                                          keyData.bytes,
                                          kKeySize,
                                          initVector.bytes,
                                          contentData.bytes,
                                          dataLength,
                                          encryptedBytes,
                                          encryptSize,
                                          &actualOutSize);
    
    if (cryptStatus == kCCSuccess) {
        // 对加密后的数据进行 base64 编码
        NSString *tempStr =  [[NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        return [AESCipher encryptionConversionString:tempStr];
    }
    free(encryptedBytes);
    return nil;
}


//+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key{
//
//    content = [AESCipher decryptionConversionString:content];
//    NSData *contentData = [[NSData alloc] initWithBase64EncodedString:content options:NSDataBase64DecodingIgnoreUnknownCharacters];
//
//
//    NSData *keyData = [key dataUsingEncoding:NSUTF8StringEncoding];
//    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];
//    NSUInteger dataLength = contentData.length;
//
//    size_t encryptSize = dataLength + kCCBlockSizeAES128;
//    void *encryptedBytes = malloc(encryptSize);
//    size_t actualOutSize = 0;
//    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
//                                          kCCAlgorithmAES,
//                                          kCCOptionPKCS7Padding,
//                                          keyData.bytes,
//                                          kKeySize,
//                                          initVector.bytes,
//                                          contentData.bytes,
//                                          dataLength,
//                                          encryptedBytes,
//                                          encryptSize,
//                                          &actualOutSize);
//
//    if (cryptStatus == kCCSuccess) {
//        NSData *data =  [NSData dataWithBytesNoCopy:encryptedBytes length:actualOutSize];
//        NSLog(@"data == %@",data);
//        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
//
//        NSLog(@"sting = %@",string);
//        return string;
//    }
//    free(encryptedBytes);
//    return nil;
//}
 
+ (NSString *)decryptAES:(NSString *)content key:(NSString *)key{
    //转换
    content = [AESCipher decryptionConversionString:content];
    char keyPtr[kCCKeySizeAES128];
    memset(keyPtr, 0, sizeof(keyPtr));
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    

    NSData *data = [[NSData alloc] initWithBase64EncodedString:content options:0];//base64解码
    
    NSUInteger dataLength = [data length];
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
        
    NSData *initVector = [kInitVector dataUsingEncoding:NSUTF8StringEncoding];

    size_t numBytesCrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt,
                                          kCCAlgorithmAES128,
                                          kCCOptionPKCS7Padding,
                                          keyPtr,
                                          kCCBlockSizeAES128,
                                          initVector.bytes,
                                          [data bytes],
                                          dataLength,
                                          buffer,
                                          bufferSize,
                                          &numBytesCrypted);
    if (cryptStatus == kCCSuccess) {
        NSData *resultData = [NSData dataWithBytesNoCopy:buffer length:numBytesCrypted];
        NSString *string = [[NSString alloc] initWithData:resultData encoding:NSUTF8StringEncoding];
//        NSLog(@"string = %@",string);
        return string;
    }
    free(buffer);
    return nil;

}
 
+(NSString *)decryptionConversionString:(NSString *)str{
    //URL_SAFE：这个参数意思是编码时不使用对URL和文件名有特殊意义的字符来作为编码字符，具体就是以-和_取代+和/
    str = [str stringByReplacingOccurrencesOfString:@"-"  withString:@"+"];
    str = [str stringByReplacingOccurrencesOfString:@"_"  withString:@"/"];
    //NO_PADDING  这个参数是略去编码字符串最后的“=”
    NSInteger dValue = str.length%4;
    //这一步的处理，只是一种尝试，尚不确定是否万能C
     for (int i = 0; i < dValue; i++) {
        str = [str stringByAppendingString:@"="];
    }
    return str;
}
 
 

+(NSString *)encryptionConversionString:(NSString *)str{
    //NO_PADDING  这个参数是略去编码字符串最后的“=”
    while ([str hasSuffix:@"="]) {
        str =  [str substringToIndex:str.length-1];
    }
    //URL_SAFE：这个参数意思是编码时不使用对URL和文件名有特殊意义的字符来作为编码字符，具体就是以-和_取代+和/
    str = [str stringByReplacingOccurrencesOfString:@"+"  withString:@"-"];
    str = [str stringByReplacingOccurrencesOfString:@"/"  withString:@"_"];
    return str;
}



@end
 
