//
//  QQLoginManager.m
//  豆豆计算器
//
//  Created by 1 on 2019/11/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "QQLoginManager.h"
#import "UserManager.h"
#import "JsonHelper.h"
#import "LoginPublic.h"


@implementation QQLoginManager

+(instancetype)shareManager{
    static QQLoginManager *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[QQLoginManager alloc] init];
        instance.count = 0;
    });
    return instance;
}

-(void)qqLoginAuthorization {
    //QQ或者TIM已安装
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        self.tencentOAuth = [[TencentOAuth alloc] initWithAppId:KQQAppID andDelegate:self];
        NSArray *permissions = [NSMutableArray arrayWithObjects:@"get_user_info",@"get_simple_userinfo",nil];
        [self.tencentOAuth RequestUnionId];
        [self.tencentOAuth authorize:permissions inSafari:NO];
    } 
}

- (void)tencentDidLogin {
    if (_tencentOAuth.accessToken.length > 0) {
        [_tencentOAuth RequestUnionId];
        [_tencentOAuth getUserInfo];
    } else {
        self.qqFailure(@"登录不成功 没有获取accesstoken");
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled {
    if(cancelled) {
        NSLog(@"取消登录");
    }
}

- (void)tencentDidNotNetWork {
    self.qqFailure(@"无网络连接，请设置网络");
}
-(void)didGetUnionID{
    [_tencentOAuth getUserInfo];
}

-(void)getUserInfoResponse:(APIResponse*)response {
    self.count +=1;
    if (self.count == 1) {
        NSDictionary *dic = response.jsonResponse;
        NSString *sex = [dic[@"gender"] isEqualToString:@"男"] ? @"0": @"1";
        NSMutableDictionary *dicM = [NSMutableDictionary dictionary];
        [dicM setValue:sex forKey:@"sex"];
        [dicM setValue:dic[@"figureurl_qq"] forKey:@"icon"];
        [dicM setValue:dic[@"nickname"] forKey:@"nickname"];
        NSString *str = JsonHelperToString(dicM);
        NSString *charactersToEscape = @"?!@#$^&%*+,:;='\"`<>()[]{}/\\| ";
        NSCharacterSet *allowedCharacters = [[NSCharacterSet characterSetWithCharactersInString:charactersToEscape] invertedSet];
        NSString *encodingString = [str stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacters];
        NSLog(@"unionid = %@  dic = %@",self.tencentOAuth.unionid,dic);
        if (self.tencentOAuth.unionid) {
            self.qqSuccessful(encodingString,self.tencentOAuth.unionid);
        }else {
            self.qqFailure(@"获取unionid失败");
        }
     }else{
        self.count = 0;
    }
}


 
@end
