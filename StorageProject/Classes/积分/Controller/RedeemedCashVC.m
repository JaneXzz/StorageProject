//
//  RedeemedCashVC.m
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "RedeemedCashVC.h"
#import "LoginPublic.h"
#import "RedeemedCashTwoCell.h"
#import "RedeemedCashFirstCell.h"
#import "RedeemedCashThreeCell.h"
#import "WebPageVC.h"
#import "AccountDetailsVC.h"
#import "DBServiceUser.h"
#import "IntegralRecordVC.h"
#import "DBServiceIntegral.h"
#import "UserManager.h"
#import <AlipaySDK/AlipaySDK.h>
#import "UIView+Toast.h"
#import "NSDictionary+Extension.h"
#import "WXApi.h"
#import "WeixinLoginManager.h"


@interface RedeemedCashVC ()<RedeemedCashCellDelegate,RedeemedCashDelegate>


@property (weak, nonatomic) IBOutlet UITableView *tableView;

/**授权编码*/
@property (nonatomic, strong) NSString *infoStr;

@property (nonatomic, strong) NSString *userId;
/**用户信息*/
@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) NSString *currentcommodityId;

@property (nonatomic, strong) NSString *currentPrice;

@end

@implementation RedeemedCashVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    
    [self.tableView registerNib:[RedeemedCashFirstCell nib] forCellReuseIdentifier:[RedeemedCashFirstCell cellReuseIdentifier]];
    [self.tableView registerNib:[RedeemedCashTwoCell nib] forCellReuseIdentifier:[RedeemedCashTwoCell cellReuseIdentifier]];
    [self.tableView registerNib:[RedeemedCashThreeCell nib] forCellReuseIdentifier:[RedeemedCashThreeCell cellReuseIdentifier]];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    if (KisLogin) {
        _userModel = [[DBServiceUser shareInstance] getUserAlldata];
    }
    
    VSWeakSelf(self)
    [UserManager getCommodityInfomation:self.userModel.accessToken payMode:2 completionHandler:^(id  _Nullable responseObject) {
        NSDictionary *tempDic = (NSDictionary *)responseObject;
        weakself.array = tempDic[@"data"];
        [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"SignInData错误 = %@",errorMessage);
    }];
    //获得支付宝授权代码
    [UserManager getAliAuthCode:self.userModel.accessToken completionHandler:^(id  _Nullable responseObject) {
        NSLog(@"responseObject = %@",responseObject);
        self.infoStr = [NSString stringWithFormat:@"%@",responseObject];
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"errorMessage = %@",errorMessage);
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        RedeemedCashFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:[RedeemedCashFirstCell cellReuseIdentifier]];
        cell.delegate = self;
        cell.beanLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userModel.integralModel.totalScore];
        cell.unitNameLabel.text = [NSString stringWithFormat:@"我的%@",self.userModel.integralModel.scoreUnitName];
        float totalScore = (float)self.userModel.integralModel.totalScore/self.userModel.integralModel.scoreUnitsPerYuan;
        cell.extractLabel.text = [NSString stringWithFormat:@"(可提现%.2f%@%@)",totalScore,self.userModel.integralModel.scoreUnitWord,self.userModel.integralModel.scoreUnitName];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        RedeemedCashTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:[RedeemedCashTwoCell cellReuseIdentifier]];
         cell.selectionStyle = UITableViewCellSelectionStyleNone;
         return cell;
    }else{
        RedeemedCashThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:[RedeemedCashThreeCell cellReuseIdentifier]];
        cell.delegate = self;
        cell.unitStr = self.userModel.integralModel.scoreUnitName;
        cell.array = self.array;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 200;
    }else if (indexPath.row == 1){
        return 40;
    }else{
        return 150;
    }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB0X(0xf7f7f7);
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"indexPath = %ld",(long)indexPath.row);
}


-(void)clickRecord {
    IntegralRecordVC *VC = [IntegralRecordVC loadViewFromXibOrNot];
    VC.userModel = self.userModel;
    [self.navigationController pushViewController:VC animated:YES];
}

- (void)clickChangeRules {
    WebPageVC *webPage = [WebPageVC loadViewFromXibOrNot];
    webPage.urlStr = @"http://www.doudoubird.com/ddn/shiftDesc.html";
    [self.navigationController pushViewController:webPage animated:YES];
}


- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)alipayWithdrawal:(NSInteger)integer {
    NSDictionary *dic = self.array[integer];
    self.currentcommodityId = [NSString stringWithFormat:@"%@",dic[@"commodityId"]];
    self.currentPrice = [NSString stringWithFormat:@"%@",dic[@"price"]];
    NSString *schemeStr = [NSString stringWithFormat:@"ap%@",KAlipay];
    [[AlipaySDK defaultService] auth_V2WithInfo:self.infoStr fromScheme:schemeStr callback:^(NSDictionary *resultDic) {
        NSString *result = resultDic[@"result"];
        NSString *authCode = nil;
        if (result.length>0) {
            NSArray *resultArr = [result componentsSeparatedByString:@"&"];
            for (NSString *subResult in resultArr) {
                if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                    authCode = [subResult substringFromIndex:10];
                    [self getUserInfo:authCode];
                    break;
                }
            }
        }
        NSLog(@"授权结果 authCode = %@", authCode?:@"");
    }];
}
//isWeChat:(BOOL)isWechat
-(void)getUserInfo:(NSString *)authCode {
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getAliUserInfo:self.userModel.accessToken authCode:authCode completionHandler:^(id  _Nullable responseObject) {
        weakself.userId = responseObject[@"user_id"];
        [UserManager exchangeProduct:weakself.userModel.accessToken commodityId:weakself.currentcommodityId commodityType:@"3" score:weakself.currentPrice wxOpenId:@"" aliAccount:weakself.userId completionHandler:^(id  _Nullable responseObject) {
            [weakself.view hideToastActivity];
            NSLog(@"支付宝授权提现 = %@",responseObject);
            [weakself.view makeToast:@"操作成功" duration:KDuration position:CSToastPositionCenter];
            [weakself updateMemberInfo];
        } failure:^(NSString * _Nullable errorMessage) {
            [weakself.view hideToastActivity];
            [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

- (void)weChatWithdrawal:(NSInteger)integer {
//    NSLog(@"微信支付 = %ld",(long)integer);
    
    NSDictionary *dic = self.array[integer];
    self.currentcommodityId = [NSString stringWithFormat:@"%@",dic[@"commodityId"]];
    self.currentPrice = [NSString stringWithFormat:@"%@",dic[@"price"]];

    VSWeakSelf(self)
    [[WeixinLoginManager shareManager] weChatAuthorization:^(NSString * _Nonnull extraStr, NSString * _Nonnull appID) {
        NSLog(@"微信打印 = %@",appID);
        [UserManager exchangeProduct:weakself.userModel.accessToken commodityId:weakself.currentcommodityId commodityType:@"3" score:weakself.currentPrice wxOpenId:appID aliAccount:@"" completionHandler:^(id  _Nullable responseObject) {
            [weakself.view hideToastActivity];
            NSLog(@"微信授权提现 = %@",responseObject);
            [weakself.view makeToast:@"操作成功" duration:KDuration position:CSToastPositionCenter];
            [weakself updateMemberInfo];
        } failure:^(NSString * _Nullable errorMessage) {
            [weakself.view hideToastActivity];
            [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }];
    }];
    
}


- (void)processAuth_V2Result:(NSURL *)resultUrl
             standbyCallback:(CompletionBlock)completionBlock{
    NSLog(@"sdds");
    
}

//更新会员信息
-(void)updateMemberInfo{
    VSWeakSelf(self)
    [[UIApplication sharedApplication].keyWindow makeToastActivity:CSToastPositionCenter];
    [UserManager getMemberInfo:self.userModel.accessToken appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        UserModel *model = [[UserModel alloc] initWithDictionary:dic];
        model.accessToken = self.userModel.accessToken;
        [[DBService shareInstance] insertIntegralOneData:model.integralModel];
        [[DBService shareInstance] insertUserOneData:model];
        [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
    }];
}


@end
