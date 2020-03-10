//
//  UserManager.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/15.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "UserManager.h"
#import "AFManager.h"
#import "LoginPublic.h"
#import "CipherManagement.h"
#import "RSACipher.h"
#import "AESCipher.h"
#import "JsonHelper.h"
#import "UUID.h"
#import "UserModel.h"
#import "NetworkRequests.h"


@implementation UserManager
#pragma mark ----  登录ok
+(void)getLogin:(NSString *)userName password:(NSString *)password type:(NSString *)loginType completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{

    NSString *sms_code =  [loginType isEqualToString:@"sms"]?password:@"";
    NSString *str;
    if (![loginType isEqualToString:@"sms"]) {
        //如果没有短信
        str = [NSString stringWithFormat:@"grant_type=password&device_token=%@&client_id=iOS&client_secret=jdzN7z53cKr1ecYk&auth_type=%@&username=%@&password=%@",[UUID getUUID],loginType,userName,password];
    }else{
        //如果有短信
        str = [NSString stringWithFormat:@"grant_type=password&device_token=%@&client_id=iOS&client_secret=jdzN7z53cKr1ecYk&auth_type=%@&username=%@&password=%@&sms_code=%@",[UUID getUUID],loginType,userName,password,sms_code];
    }
    NSDictionary *dic = [CipherManagement encryption:str]; 
    NSURL *url = [NSURL URLWithString:KLogin];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyStr=[NSString stringWithFormat:@"key=%@&paramd=%@",dic[@"key"],dic[@"paramd"]];
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
 
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            //返回主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        NSDictionary *dic = [self stringConversion:data];
                        NSLog(@"%@",dic);
                        NSString *errorStr = dic[@"error"];
                        if (errorStr) {
                            NSString *messageStr = dic[@"message"];
                            failure(messageStr);
                        } else{
                            completion(dic);
                        }
                    }else{
                        failure(error.localizedDescription);
                    }
                    
                });
        });
       
    }];
    [dataTask resume];
    
    //    NSString *path = KLogin;
    //    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:path parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
    //        NSDictionary *dic = [self stringConversion:responseObject];
    //        NSLog(@"登录成功 = %@",dic);
    //        NSInteger code = [dic[@"code"] integerValue];
    //       if (code == 0) {
    //            completion(dic);
    //       }else{
    //           NSString *code = dic[@"message"];
    //           failure(code);
    //       }
    //    } failure:^(NSString * _Nullable errorMessage) {
    //        NSLog(@"登录失败 = %@",errorMessage);
    //        if ([errorMessage containsString:@"400"]) {
    //            failure(@"登录失败,请检查账号或密码");
    //        }else{
    //            failure(errorMessage);
    //        }
    //    }];
}

#pragma mark ----  第三方登录
+(void)getThirdLoginLogin:(NSString *)appid extra:(NSString *)extraStr type:(NSString *)loginType completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{

     NSString *str = [NSString stringWithFormat:@"grant_type=password&device_token=%@&client_id=iOS&client_secret=jdzN7z53cKr1ecYk&auth_type=%@&username=%@&password=%@&extra=%@",[UUID getUUID],loginType,appid,@"",extraStr];
    NSDictionary *dic = [CipherManagement encryption:str];
    NSURL *url = [NSURL URLWithString:KLogin];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *bodyStr=[NSString stringWithFormat:@"key=%@&paramd=%@",dic[@"key"],dic[@"paramd"]];
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
 
    NSURLSession *session=[NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            //返回主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        NSDictionary *dic = [self stringConversion:data];
                        NSLog(@"%@",dic);
                        NSString *errorStr = dic[@"error"];
                        if (errorStr) {
                            NSString *messageStr = dic[@"message"];
                                failure(messageStr);
                        } else{
                            completion(dic);
                        }
                    }else{
                        failure(error.localizedDescription);
                    }
                });
        });
       
    }];
    [dataTask resume];
//    NSString *path = KLogin;
//    NSLog(@"path = %@",path);
//    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:path parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
//        NSDictionary *dic = [self stringConversion:responseObject];
//        NSLog(@"登录成功 = %@",dic);
//        NSInteger code = [dic[@"code"] integerValue];
//       if (code == 0) {
//            completion(dic);
//       }else{
//           NSString *code = dic[@"message"];
//           failure(code);
//       }
//    } failure:^(NSString * _Nullable errorMessage) {
//        NSLog(@"登录失败 = %@",errorMessage);
//        failure(errorMessage);
//    }];
}
 
 
#pragma mark ----  手机注册ok
+(void)getRegisterByMobile:(NSString *)mobilePhone password:(NSString *)password smsCode:(NSString *)smsCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"mobile=%@&password=%@&smsCode=%@",mobilePhone,password,smsCode];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KRegisterByMobile parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"手机注册成功 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
             completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}



#pragma mark ---- 手机验证码ok
+(void)getSendSMS:(NSString *)mobile completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *iphone = [NSString stringWithFormat:@"mobile=%@",mobile];
    NSDictionary *dic = [CipherManagement encryption:iphone];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodGET serverUrl:@"" apiPath:KSendsms parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"手机验证码 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}
#pragma mark ---- 手机验证修改密码
+(void)getMobileChangePassword:(NSString *)mobile smsCode:(NSString *)smsCode password:(NSString *)password completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"mobile=%@&smsCode=%@&password=%@",mobile,smsCode,password];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KMobileChangePassword parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"手机验证修改密码 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }]; 
}



#pragma mark ---- 旧密码换为新密码
+(void)getChangePassword:(NSString *)accessToken password:(NSString *)password newPassword:(NSString *)newPassword completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&password=%@&newPassword=%@",accessToken,password,newPassword];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KChangePassword parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"旧密码换为新密码成功 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}


#pragma mark ---- 检测会员属性是否可以
+(void)getMemberCheckField:(NSString *)fieldValue fieldType:(NSString *)fieldType completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"fieldValue=%@&fieldType=%@",fieldValue,fieldType];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KMemberCheckField parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"检测是否已经存在手机号码成功 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 500) {
            NSString *message = dic[@"message"];
            failure(message);
        }else{
            completion(dic);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"手机验证失败");
        failure(errorMessage);
    }];
}


#pragma mark ---- 检测是否已经存在手机号码ok
+(void)getMemberExistsField:(NSString *)mobile isRegistered:(BOOL)isRegistered completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {
    NSString *str = [NSString stringWithFormat:@"fieldValue=%@&fieldType=mobile",mobile];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KMemberExistsField parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSInteger code = [dic[@"code"] integerValue];
        if (isRegistered == YES) {
            if (code == 0) {
                //已经存在或成功匹配,所以注册
                NSString *code = dic[@"message"];
                failure(code);
            }else{
                completion(dic);
            }
        }else{
            if (code == 0) {
                completion(dic);
            }else{
                NSString *code = dic[@"message"];
                failure(code);
            }
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}

 
#pragma mark ----  获取会员信息
+(void)getMemberInfo:(NSString *)accessToken appId:(NSString *)aidx completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&appId=%@",accessToken,aidx];
    NSLog(@"KGetMemberInfo = %@",KGetMemberInfo);
    NSDictionary *dic = [CipherManagement encryption:str];
//    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KGetMemberInfo parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
//        NSDictionary *dic = [self stringConversion:responseObject];
//        NSLog(@"获取会员信息成功 = %@",dic);
//        NSInteger code = [dic[@"code"] integerValue];
//        if (code == 0) {
//            completion(dic);
//        }else{
//            NSString *code = dic[@"message"];
//            failure(code);
//        }
//    } failure:^(NSString * _Nullable errorMessage) {
//        NSLog(@"获取会员信息失败");
//        failure(errorMessage);
//    }];
    NSURL *url = [NSURL URLWithString:KGetMemberInfo];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置request
    request.HTTPMethod = @"POST";
    NSString *bodyStr=[NSString stringWithFormat:@"key=%@&paramd=%@",dic[@"key"],dic[@"paramd"]];
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            //返回主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        NSDictionary *dic = [self stringConversion:data];
                        NSLog(@"%@",dic);
                        NSString *errorStr = dic[@"error"];
                        if (errorStr) {
                            NSString *messageStr = dic[@"message"];
                            failure(messageStr);
                        } else{
                           completion(dic);
                        }
                    }else{
                        failure(error.localizedDescription);
                    }
                });
        });
       
    }];
    [dataTask resume];
}

#pragma mark ----  退出
+(void)getLogout:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
        
    NSString *str = [NSString stringWithFormat:@"access_token=%@",accessToken];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KLogout parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"退出账号 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"退出失败");
        failure(errorMessage);
    }];
}

#pragma mark ----  修改信息
+(void)getModifyUserInformationAccessToken:(NSString *)accessToken content:(NSString *)content type:(NSString *)type completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&%@=%@",accessToken,type,content];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KSaveMemberInfo parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"修改信息 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
    
    
}
#pragma mark ----  验证手机号码
+(void)getCheckSMS:(NSString *)mobile smsCode:(NSString *)smsCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"mobile=%@&smsCode=%@",mobile,smsCode];
    NSDictionary *dic = [CipherManagement encryption:str];
      [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KChecksms parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
          NSDictionary *dic = [self stringConversion:responseObject];
          NSLog(@"验证手机号码 = %@",dic);
          NSInteger code = [dic[@"code"] integerValue];
          if (code == 0) {
              completion(dic);
          }else{
              NSString *code = dic[@"message"];
              failure(code);
          }
      } failure:^(NSString * _Nullable errorMessage) {
          NSLog(@"验证手机号码失败");
          failure(errorMessage);
      }];
}
#pragma mark ----  绑定手机
+(void)getBindMobile:(NSString *)accessToken oldMobile:(NSString *)oldMobile oldSmsCode:(NSString *)oldSmsCode newMobile:(NSString *)newMobile smsCode:(NSString *)smsCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {
    NSString *str;
    if (oldMobile.length == 0) {
        str = [NSString stringWithFormat :@"access_token=%@&mobile=%@&smsCode=%@",accessToken,newMobile,smsCode];
    }else{
        str = [NSString stringWithFormat:@"access_token=%@&oldMobile=%@&oldSmsCode=%@&mobile=%@&smsCode=%@",accessToken,oldMobile,oldSmsCode,newMobile,smsCode];
    }
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KBindMobile parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSLog(@"绑定手机号码 = %@",dic);
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"验证手机号码失败");
        failure(errorMessage);
    }];
}

 
#pragma mark ----  具体商品详细信息  KCommodityInfomation
+(void)getCommodityInfomation:(NSString *)accessToken payMode:(NSInteger)payModel completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {
//    NSString *str = [NSString stringWithFormat:@"aidx=%@&pClassification=1&sClassification=2&access_token=%@",KAIDX,accessToken];
    NSString *str = [NSString stringWithFormat:@"access_token=%@&aidx=%@&payMode=%ld",accessToken,KAIDX,(long)payModel];

    NSDictionary *dic = [CipherManagement encryption:str];
    NSURL *url = [NSURL URLWithString:KCommodityInfomation];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    //设置request
    request.HTTPMethod = @"POST";
    NSString *bodyStr=[NSString stringWithFormat:@"key=%@&paramd=%@",dic[@"key"],dic[@"paramd"]];
    request.HTTPBody=[bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSession *session=[NSURLSession sharedSession];
    
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_queue_t queue =  dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_async(queue, ^{
            //返回主线程
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (data) {
                        NSDictionary *dic = [self stringConversion:data];
                        NSLog(@"%@",dic);
                        NSString *errorStr = dic[@"error"];
                        if (errorStr) {
                            NSString *messageStr = dic[@"message"];
                            failure(messageStr);
                        } else{
                            NSInteger code = [dic[@"code"] integerValue];
                            if (code == 0) {
                                completion(dic);
                            }else{
                                NSString *code = dic[@"message"];
                                failure(code);
                            }
                        }
                    }else{
                        failure(error.localizedDescription);
                    }
                });
        });
       
    }];
    [dataTask resume];
//    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KCommodityInfomation parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
//        NSDictionary *dic = [self stringConversion:responseObject];
//        NSInteger code = [dic[@"code"] integerValue];
//        if (code == 0) {
//            completion(dic);
//        }else{
//            NSString *code = dic[@"message"];
//            failure(code);
//        }
//    } failure:^(NSString * _Nullable errorMessage) {
//        failure(errorMessage);
//    }];
}

#pragma mark ---- QQand微信的绑定
+(void)getBindThirdOauth:(NSString *)accessToken openId:(NSString *)openId thirdType:(NSString *)type extra:(NSString *)extra completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{ 
    NSString *str = [NSString stringWithFormat:@"access_token=%@&openId=%@&thirdType=%@&extra=%@",accessToken,openId,type,extra];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KBindThirdOauth parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}
#pragma mark ---- 取消绑定
+(void)getUnbindThirdOauth:(NSString *)accessToken thirdType:(NSString *)type completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {
    NSString *str = [NSString stringWithFormat:@"access_token=%@&thirdType=%@",accessToken,type];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KUnbindThirdOauth parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic);
        }else{
            NSInteger code = [dic[@"message"] integerValue];
            failure([self currentCode:code]);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}
#pragma mark ---- 商品下单
+(void)getOrderProduct:(NSString *)accessToken commodityId:(NSString *)commodityId commodityType:(NSString *)commodityType amount:(NSString *)amount payType:(NSString *)payType productId:(NSString *)productId iaptype:(NSString *)iaptype completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {
    NSString *str = [NSString stringWithFormat:@"access_token=%@&commodityId=%@&appId=%@&commodityType=%@&aliasId=""&amount=%@&payType=%@&productId=%@&iaptype=%@",accessToken,commodityId,KAIDX,commodityType,amount,payType,productId,iaptype];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KOrderProduct parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic[@"data"]);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}


+(void)getNotifyPay:(NSString *)accessToken orderId:(NSString *)orderId  receipt:(NSString *)receipt completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&orderId=%@&receipt=%@",accessToken,orderId,receipt];
    NSDictionary *dic = [CipherManagement encryption:str];
    
    NSString *dataStr = [NSString stringWithFormat:@"key=%@&paramd=%@",dic[@"key"],dic[@"paramd"]];
    NSData *requestData = [dataStr dataUsingEncoding:NSUTF8StringEncoding];
    
    NSString *serverString = KNotifyPay;
    NSURL *storeURL = [NSURL URLWithString:serverString];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
 
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            if (connectionError) {
                // 无法连接服务器,购买校验失败
                failure(connectionError.localizedDescription);
            } else {
                NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                NSDictionary *aesDic = JsonHelperDictionaryFromString(result);
                if (aesDic[@"error"]) {
                    NSString *code = aesDic[@"message"];
                    failure(code);
                    return;
                }
                NSDictionary *dic = [CipherManagement decryption:aesDic];
                NSLog(@"dic = %@",dic);
                NSInteger code = [dic[@"code"] integerValue];
                if (code == 0) {
                    completion(dic[@"data"]);
                }else{
                    NSString *code = dic[@"message"];
                    failure(code);
                }
            }
        });
    }];
     
}


#pragma mark ---- 检测微信支付是否成功
+(void)getQueryOrder:(NSString *)accessToken orderId:(NSString *)orderId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
     NSString *str = [NSString stringWithFormat:@"access_token=%@&orderId=%@",accessToken,orderId];
     NSDictionary *dic = [CipherManagement encryption:str];
     [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KQueryOrder parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
         NSDictionary *dic = [self stringConversion:responseObject];
         NSInteger code = [dic[@"code"] integerValue];
         if (code == 0) {
             NSString *status = dic[@"data"][@"status"];
             NSInteger statusInt = [status integerValue];
             switch (statusInt) {
                 case 0:
                     completion(@"等待支付");
                     break;
                 case 1:
                     completion(@"成功支付");
                     break;
                 case 2:
                     completion(@"失败");
                     break;
                 case 3:
                     completion(@"失败关闭");
                     break;
                 case 10:
                     completion(@"退款中");
                     break;
                 case 11:
                     completion(@"成功退款");
                     break;
                 default:
                     break;
             }
         }else {
             NSString *code = dic[@"message"];
             failure(code);
         }
     } failure:^(NSString * _Nullable errorMessage) {
         failure(errorMessage);
     }];
}

#pragma mark ---- 用户通知
+(void)getSelectCorrespondNoticeMemberId:(NSString *)memberId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str;
    if (memberId.length == 0) {
         str = [NSString stringWithFormat:@"aidx=%@",KAIDX];
    }else{
         str = [NSString stringWithFormat:@"aidx=%@&memberId=%@",KAIDX,memberId];
    }
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:KSelectCorrespondNotice parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [self stringConversion:responseObject];
        NSInteger code = [dic[@"code"] integerValue];
        if (code == 0) {
            completion(dic[@"data"]);
        }else{
            NSString *code = dic[@"message"];
            failure(code);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        failure(errorMessage);
    }];
}


/*********************积分接口******************************/

//5.1签到
+(void)getSignIn:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    
    NSString *str = [NSString stringWithFormat:@"access_token=%@",accessToken];
    NSDictionary *dic = [CipherManagement encryption:str];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodGET serverUrl:@"" apiPath:KGetSignIn parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        NSDictionary *dic = [CipherManagement decryption:responseObject];
        NSInteger code = [dic[@"code"] integerValue];
       if (code == 0) {
           completion(dic[@"data"]);
       }else{
           if (code == 304) {
               return ;
           }else{
               NSString *code = dic[@"message"];
               failure(code);
           }
       }
    } failure:^(NSString * _Nullable errorMessage) {
       failure(errorMessage);
    }];
    
}


//5.2签到数据信息
+(void)getSignInData:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@",accessToken];
    NSDictionary *dic = [CipherManagement encryption:str];
    [NetworkRequests postWithUrlString:KGetSignInData parameters:dic success:^(NSDictionary * _Nonnull dic) {
        if (dic) {
            NSInteger code = [dic[@"code"] integerValue];
            if (code == 0) {
                completion(dic[@"data"]);
            }else{
                NSString *message = dic[@"message"];
                failure(message);
            }
        }
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
    
}

//5.3获取积分任务列表
+(void)getMemberTasks:(NSString *)accessToken appId:(NSString *)appId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&appId=%@",accessToken,KAIDX];
    NSDictionary *dic = [CipherManagement encryption:str];
    
    [NetworkRequests postWithUrlString:KGetMemberTasks parameters:dic success:^(NSDictionary * _Nonnull dic) {
        if (dic) {
            NSInteger code = [dic[@"code"] integerValue];
            if (code == 0) {
                completion(dic[@"data"]);
            }else{
                NSString *message = dic[@"message"];
                failure(message);
            }
        }
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
}
//完成任务得积分
+(void)applyMemberTask:(NSString *)accessToken appId:(NSString *)appId taskId:(NSString *)taskId completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&appId=%@&taskId=%@",accessToken,KAIDX,taskId];
    NSDictionary *dic = [CipherManagement encryption:str];
    
    [NetworkRequests postWithUrlString:KApplyMemberTask parameters:dic success:^(NSDictionary * _Nonnull dic) {
           if (dic) {
               NSInteger code = [dic[@"code"] integerValue];
               if (code == 0) {
                   completion(dic[@"data"]);
               }else{
                   NSString *message = dic[@"message"];
                   failure(message);
               }
           }
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
//       [[AFManager sharedManager] sendRequestMethod:HTTPMethodGET serverUrl:@"" apiPath:KApplyMemberTask parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
//           NSDictionary *dic = [CipherManagement decryption:responseObject];
//           NSInteger code = [dic[@"code"] integerValue];
//           if (code == 0) {
//               completion(dic[@"data"]);
//           }else{
//               NSString *code = dic[@"message"];
//               failure(code);
//           }
//       } failure:^(NSString * _Nullable errorMessage) {
//          failure(errorMessage);
//       }];
}

//5.5获取积分纪录
+(void)getScoreRecords:(NSString *)accessToken month:(NSString *)month startDay:(NSString *)startDay endDay:(NSString *)endDay limit:(NSString *)limit lastId:(NSString *)lastId consumed:(NSString *)consumed scoreType:(NSString *)scoreType scoreTypes:(NSString *)scoreTypes completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
//    NSString *str = [NSString stringWithFormat:@"access_token=%@&month=%@&startDay=%@&endDay=%@&limit=%@&lastId=%@&consumed=%@&scoreType=%@&scoreTypes=%@",accessToken,month,startDay,endDay,limit,lastId,consumed,scoreType,scoreTypes];
    NSString *str = [NSString stringWithFormat:@"access_token=%@&scoreTypes=%@",accessToken,scoreTypes];
    NSDictionary *dic = [CipherManagement encryption:str];
    
    [NetworkRequests postWithUrlString:KGetScoreRecords parameters:dic success:^(NSDictionary * _Nonnull dic) {
           if (dic) {
               NSInteger code = [dic[@"code"] integerValue];
               if (code == 0) {
                   completion(dic[@"data"]);
               }else{
                   NSString *message = dic[@"message"];
                   failure(message);
               }
           }
    } failure:^(NSString * _Nonnull error) {
        failure(error);
    }];
    
    
//    [[AFManager sharedManager] sendRequestMethod:HTTPMethodGET serverUrl:@"" apiPath:KGetScoreRecords parameters:dic progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
//        NSDictionary *dic = [CipherManagement decryption:responseObject];
//        NSInteger code = [dic[@"code"] integerValue];
//        if (code == 0) {
//            completion(dic[@"data"]);
//        }else{
//            NSString *code = dic[@"message"];
//            failure(code);
//        }
//    } failure:^(NSString * _Nullable errorMessage) {
//        failure(errorMessage);
//    }];
}


#pragma mark ---- 支付宝授权码

+(void)getAliAuthCode:(NSString *)accessToken completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {

    NSString *str = [NSString stringWithFormat:@"access_token=%@&appId=%@",accessToken,KAIDX];
       NSDictionary *dic = [CipherManagement encryption:str];
       [NetworkRequests postWithUrlString:KGetAliAuthCode parameters:dic success:^(NSDictionary * _Nonnull dic) {
           if (dic) {
//               NSLog(@"支付宝授权码 = %@",dic);
               NSInteger code = [dic[@"code"] integerValue];
               if (code == 0) {
                   completion(dic[@"data"]);
               }else{
                   NSString *message = dic[@"message"];
                   failure(message);
               }
           }
       } failure:^(NSString * _Nonnull error) {
            failure(error);
       }];
}


#pragma mark ---- 支付宝授权码
+(void)getAliUserInfo:(NSString *)accessToken authCode:(NSString *)authCode completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure {
    NSString *str = [NSString stringWithFormat:@"access_token=%@&appId=%@&authCode=%@",accessToken,KAIDX,authCode];
   NSDictionary *dic = [CipherManagement encryption:str];
   [NetworkRequests postWithUrlString:KGetAliUserInfo parameters:dic success:^(NSDictionary * _Nonnull dic) {
       if (dic) {
           NSInteger code = [dic[@"code"] integerValue];
           if (code == 0) {
               completion(dic[@"data"]);
           }else{
               NSString *message = dic[@"message"];
               failure(message);
           }
       }
   } failure:^(NSString * _Nonnull error) {
        failure(error);
   }];
}

//积分兑换商品
+(void)exchangeProduct:(NSString *)accessToken commodityId:(NSString *)commodityId commodityType:(NSString *)commodityType score:(NSString *)score wxOpenId:(NSString *)wxOpenId aliAccount:(NSString *)aliAccount completionHandler:(nullable void (^)(id  _Nullable responseObject))completion failure:(nullable void (^)(NSString *_Nullable errorMessage))failure{
    NSString *str = [NSString stringWithFormat:@"access_token=%@&appId=%@&commodityId=%@&commodityType=%@&score=%@&wxOpenId=%@&aliAccount=%@",accessToken,KAIDX,commodityId,commodityType,score,wxOpenId,aliAccount];
    NSDictionary *dic = [CipherManagement encryption:str];
    [NetworkRequests postWithUrlString:KExchangeProduct parameters:dic success:^(NSDictionary * _Nonnull dic) {
        if (dic) {
            NSInteger code = [dic[@"code"] integerValue];
           if (code == 0) {
               completion(dic[@"data"]);
           }else{
               NSString *message = dic[@"message"];
               failure(message);
           }
       }
   } failure:^(NSString * _Nonnull error) {
        failure(error);
   }];
}


+(NSDictionary *)stringConversion:(id)responseObject{
    NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    NSDictionary *aesDic = JsonHelperDictionaryFromString(result);
    if (aesDic[@"error"]) {
        return aesDic;
    }
    NSDictionary *dic = [CipherManagement decryption:aesDic];
    return dic;
}


+(NSString *)currentCode:(NSInteger)code {
    NSString *string = @"";
    switch (code) {
        case 0:
            string = @"成功";
            break;
        case 304:
            string = @"成功,无数据更改";
            break;
        case 401:
            string = @"未登录或登录失败";
            break;
        case 402:
            string = @"账号未激活或被封禁";
            break;
        case 403:
            string = @"没有权限";
            break;
        case 407:
            string = @"访问加密错误";
            break;
        case 500:
            string = @"失败";
            break;
        case 501:
            string = @"参数错误";
            break;
        case 502:
            string = @"参数为空";
            break;
        case 503:
            string = @"数据库错误";
            break;
        default:
            break;
    }
    return string;
}

@end
