//
//  UserModel.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ColumnMappingDelegate.h"
#import "IntegralModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface UserModel : NSObject<ColumnMappingDelegate>

@property (nonatomic, assign) NSInteger currentId;
//会员ID（唯一）
@property (nonatomic, copy) NSString *memberId;
//唯一用户名，用户名必须是4-32位，包含字母或汉字或数字或_或.号，必须字母或汉字或_开头，不可以包含_和.之外的符号
@property (nonatomic, copy) NSString *memberName;
//昵称
@property (nonatomic, copy) NSString *nickname;
//密码
@property (nonatomic, copy) NSString *password;
//邮箱
@property (nonatomic, copy) NSString *email;
//手机号码
@property (nonatomic, copy) NSString *mobile;
//登录类型
@property (nonatomic, copy) NSString *loginType;
//性别0.男,1.女
@property (nonatomic, assign) NSInteger sex;
//图标URL
@property (nonatomic, copy) NSString *iconUrl;
//去广告的截止时间，如果为null或者已经过去，说明现在不再没有广告
@property (nonatomic, copy) NSString *removeAdDay;
//QQ登录ID
@property (nonatomic, copy) NSString *qqOpenId;
//QQ名称
@property (nonatomic, copy) NSString *qqName;

@property (nonatomic, copy) NSString *qqbind;

//微信登录ID
@property (nonatomic, copy) NSString *wxOpenId;
@property (nonatomic, copy) NSString *wxName;
@property (nonatomic, copy) NSString *wxbind;
//账号是否可修改
@property (nonatomic, copy) NSString *modifiedAccount;
//授权码
@property (nonatomic, copy) NSString *accessToken;
@property (nonatomic, copy) NSString *tokenType;
//授权码过期时间，单位为秒
@property (nonatomic, copy) NSString *expiresIn;

//@property (nonatomic, copy) NSString *createdNew;
//@property (nonatomic, copy) NSString *scope;
//登录时间
@property (nonatomic, copy) NSString *loginTime;
//Boolean是否为空密码
@property (nonatomic, copy) NSString *emptyPwd;
//会员已购买的皮肤id，以&=&分隔
@property (nonatomic, copy) NSString *themeIds;
//修改名称
@property (nonatomic, assign)NSInteger chgMemberName;

@property (nonatomic, strong) IntegralModel *integralModel;


-(instancetype)initWithDictionary:(NSDictionary *)dic;
 
@end

NS_ASSUME_NONNULL_END
