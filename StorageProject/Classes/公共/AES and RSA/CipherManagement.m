//
//  CipherManagement.m
//  玛雅日历
//
//  Created by 1 on 2019/10/23.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "CipherManagement.h"
#import "JsonHelper.h"
#import "RSACipher.h"
#import "AESCipher.h"
#import "NSDictionary+Extension.h"

#define KPublishKey @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCpbrPaZE+5aVBCyvRIvpMsoS+E7L+xQmSdQ+tW0S157yJEDcFUjkfypZyPC/+12wcftyjs0sqHtDXxXFzCVfR4rBdcizlHmeQkHQCp4x2jajguNsN2/tiePS+X4F96oaITaGjvfyOgtygeHsFkDx60ckmr/JARgVQ8e7G1rW8uIQIDAQAB"

@implementation CipherManagement
//传入值
+(NSDictionary *)encryption:(NSString *)value{
    NSString *key = [RSACipher randomlyGenerated16BitString]; 
    //aes密码
    NSString *AESString = [AESCipher encryptAES:value key:key];
    //rsa密码
    NSString *encWithPubKey = [RSACipher encryptString:key publicKey:KPublishKey];
    //上传
    NSDictionary *dic = @{@"paramd":AESString,@"key":encWithPubKey};
    return dic;
}

//解密
+(NSDictionary *)decryption:(id)responseObject{
    NSDictionary *dic = [NSDictionary changeType:responseObject];
    NSString *dataStr = dic[@"data"];
    NSString *keyStr = dic[@"key"]; 
    //RSA解密
    NSString *rsaKeyStr = [RSACipher decryptString:keyStr publicKey:KPublishKey];
    //将获取的json字符串转换为字典
    NSDictionary *rsaDic = JsonHelperDictionaryFromString(rsaKeyStr);
    //AES解密
    NSString *aesDataStr = [AESCipher decryptAES:dataStr key:rsaDic[@"value"]];
    //将获取的json字符串转换为字典
    NSDictionary *aesDic = JsonHelperDictionaryFromString(aesDataStr);

    return aesDic;
}

//解密
+(NSDictionary *)fixedDecryption{
     NSString *dataStr = @"2tvxUiswvD_dnN0wrucAxRF3hgfUdEYyr32VTeINh_Y3fgt8FB6TYVX3KTzZkX5c9M5Kzq10EUnS2IYo7QoqCqL8i8mroSFXXaIsdMRefipHIHRiasAVaJ-1y6QCYl91H5Jejm2A2HohSN49YKM1rxTHgyoRu92HUb0JZbGa5BOvH8pJwYGKzGFdm2CRRxqmJTtW_a5X71bbkb7lb6YikoYLGO9LGnByaSuMHLzSg11x-wzHG5pWhoMW4HwhHGrvJPQoZUWOMWR4Be4TxvMBLb2K7i7h3AQ-5Nqc6I113b_MYL3pzx3LkwxoIaIiOanWg8PA3nERgZDlhWuunyBiK-8MUyt8ZzQ01D7SuUni8ZXErVe2atMY7sGcC5KWqA3Nb5X9Aq685gEyBDW3TMlUOHS--srtGICXePL96CJlfOE";
    NSString *keyStr = @"aTdEJs_KfnGE5MBmA0_QsZ1RViEXb0KsuFRj0xSMi5oiwNQyq6O0u7GECPtrhP97EhS1d_8bdvzG0p-iYMSm1xNFAgDah5SwdWX1veygrzhxr_taVVVgZ5S2esZZYt4fXEMESnDP-9wKCT_V095vmKSFlnQGOzqcc7yAq0AfjY4";
    //RSA解密
    NSString *rsaKeyStr = [RSACipher decryptString:keyStr publicKey:KPublishKey];
    //将获取的json字符串转换为字典
    NSDictionary *rsaDic = JsonHelperDictionaryFromString(rsaKeyStr);
    //AES解密
//    NSLog(@"rsaDic = %@  %@",dataStr,rsaDic[@"value"]);
    NSString *aesDataStr = [AESCipher decryptAES:dataStr key:rsaDic[@"value"]];
    //将获取的json字符串转换为字典
    NSDictionary *aesDic = JsonHelperDictionaryFromString(aesDataStr);

    return aesDic;
}


@end
