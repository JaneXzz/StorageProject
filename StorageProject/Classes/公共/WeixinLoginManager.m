//
//  WeixinLoginManager.m
//  豆豆计算器
//
//  Created by 1 on 2019/11/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "WeixinLoginManager.h"
#import "WXApi.h"
#import "AFManager.h"
#import "UserManager.h"
#import "JsonHelper.h"
#import "LoginPublic.h"

#define KAccessTokenUrl @"https://api.weixin.qq.com/sns/oauth2/access_token?"
#define KUserinfo @"https://api.weixin.qq.com/sns/userinfo?"


@implementation WeixinLoginManager

+(instancetype)shareManager{
    static WeixinLoginManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[WeixinLoginManager alloc] init];
    });
    return instance;
}
//登录授权
-(void)sendAuthRequest{
    _isAuthorization = NO;
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
         NSLog(@"没有安装微信");
    }else{
        SendAuthReq *weChatReq = [[SendAuthReq alloc] init];
        weChatReq.scope = @"snsapi_userinfo";
        weChatReq.openID = KWeiXinAppID;
//        [WXApi sendReq:weChatReq];
        [WXApi sendReq:weChatReq completion:nil];
    }
}


//授权回调的结果
-(void)onResp:(BaseResp *)resp {
    if([resp isKindOfClass:[SendAuthResp class]]){
        //拿到微信返回的Code
        SendAuthResp *res = (SendAuthResp *)resp;
        [self loginSuccessByCode:res.code];
    }
}

-(void)loginSuccessByCode:(NSString *)code{
    if (code) {
        NSString *url = [NSString stringWithFormat:@"%@appid=%@&secret=%@&code=%@&grant_type=authorization_code",KAccessTokenUrl,KWeiXinAppID,KWeiXinAppSecret,code];
        [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:url parameters:nil progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
            if (responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                NSString *accessToken = [dic valueForKey:@"access_token"];
                NSString *openID = [dic valueForKey:@"openid"];
                [self requestUserInfoByToken:accessToken andOpenid:openID];
            }
        } failure:^(NSString * _Nullable errorMessage) {
            self.failure(errorMessage);
        }];
    } 
}

-(void)requestUserInfoByToken:(NSString *)token andOpenid:(NSString *)openID{
    VSWeakSelf(self)
    NSString *url = [NSString stringWithFormat:@"%@access_token=%@&openid=%@",KUserinfo,token,openID];
    [[AFManager sharedManager] sendRequestMethod:HTTPMethodPOST serverUrl:@"" apiPath:url parameters:nil progress:^(NSProgress * _Nullable progress) {} success:^(BOOL isSuccess, id  _Nullable responseObject) {
        if (responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"获取到的微信用户的信息dic = %@",dic);
            NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
            [dicM setValue:dic[@"nickname"] forKey:@"nickname"];
            NSString *sexStr = [NSString stringWithFormat:@"%@",dic[@"sex"]];
            if ([sexStr isEqualToString:@"2"]) {
                [dicM setValue:@"1" forKey:@"sex"];
            }else if([sexStr isEqualToString:@"1"]){
                [dicM setValue:@"0" forKey:@"sex"];
            }
            [dicM setValue:dic[@"headimgurl"] forKey:@"icon"];
            
            NSString *str = JsonHelperToString(dicM);
            NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
                   NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
            NSString *encodingString = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
            weakself.successful(encodingString,openID);
        }
    } failure:^(NSString * _Nullable errorMessage) {
        self.failure(errorMessage);
    }];
}

- (void)weChatAuthorization:(nullable void (^)(NSString *extraStr,NSString *appID))successful{
    _successful = successful;
    _isAuthorization = YES;
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
         NSLog(@"没有安装微信");
    }else{
        SendAuthReq *weChatReq = [[SendAuthReq alloc] init];
        weChatReq.scope = @"snsapi_userinfo";
        weChatReq.openID = KWeiXinAppID;
        [WXApi sendReq:weChatReq completion:^(BOOL success) {}];
    }
}

@end
