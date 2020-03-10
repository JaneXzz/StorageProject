//
//  UserModel.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "UserModel.h" 

@implementation UserModel
+ (NSDictionary *)dbColumnMap {
    return @{
        @"id":@"currentId",
        @"memberId": @"memberId",
        @"memberName": @"memberName",
        @"nickname": @"nickname",
        @"password": @"password",
        @"email": @"email",
        @"mobile": @"mobile",
        @"loginType": @"loginType",
        @"sex": @"sex",
        @"iconUrl": @"iconUrl",
        @"removeAdDay": @"removeAdDay",
        @"qqOpenId": @"qqOpenId",
        @"qqName": @"qqName",
        @"qqbind": @"qqbind",
        @"wxOpenId": @"wxOpenId",
        @"wxName": @"wxName",
        @"wxbind": @"wxbind",
        @"modifiedAccount": @"modifiedAccount",
        @"accessToken": @"accessToken",
        @"tokenType": @"tokenType",
        @"expiresIn": @"expiresIn",
        @"loginTime": @"loginTime",
        @"emptyPwd": @"emptyPwd",
        @"themeIds": @"themeIds",
        @"chgMemberName": @"chgMemberName",
    };
}

-(instancetype)initWithDictionary:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.memberId = dic[@"memberId"];
        self.memberName = dic[@"memberName"];
        self.nickname = dic[@"nickname"];
        self.emptyPwd = dic[@"emptyPwd"];
        self.email = dic[@"email"];
        self.mobile = dic[@"mobile"];
        self.qqOpenId = dic[@"qqOpenId"];
        self.wxOpenId = dic[@"wxOpenId"];
        self.sex = [dic[@"sex"] integerValue];
        self.iconUrl = dic[@"icon"];
        self.removeAdDay = dic[@"appObj"][@"removeAdDay"];
        self.themeIds = @"";
        IntegralModel *model = [[IntegralModel alloc] init];
        model.scoreUnitWord = dic[@"sysSetting"][@"scoreUnitWord"];
        model.scoreUnitName = dic[@"sysSetting"][@"scoreUnitName"];
        model.scoreUnitsPerYuan = [dic[@"sysSetting"][@"scoreUnitsPerYuan"] integerValue];
        model.scoreShiftDesc = dic[@"sysSetting"][@"scoreShiftDesc"];
        
        model.totalScore = [dic[@"scoreObj"][@"totalScore"] integerValue];
        model.withdrawScore = [dic[@"scoreObj"][@"withdrawScore"] integerValue];
        model.todayScore = [dic[@"scoreObj"][@"todayScore"] integerValue];
        model.level = [dic[@"scoreObj"][@"level"] integerValue];
        model.levelName = dic[@"scoreObj"][@"levelName"];
        self.integralModel = model;
    }
    return self;
}

@end
