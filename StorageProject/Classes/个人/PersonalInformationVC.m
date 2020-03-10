//
//  PersonalInformationVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/9.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "PersonalInformationVC.h"
#import "InformationHeaderCell.h"
#import "InformationCell.h"
#import "NicknameVC.h"
#import "AccountSetVC.h"
#import "OldMobilePhoneVC.h"
#import "NewMobilePhoneVC.h"
#import "EditorChangePasswordVC.h"
#import "ExitAccountCell.h"
#import "HeaderVC.h"
#import "LoginPublic.h"
#import "UserModel.h"
#import "DBServiceUser.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "DBServiceUser.h"
#import "UIImageView+WebCache.h"
#import "QQLoginManager.h"
#import "WeixinLoginManager.h"
#import "AdvancedSettingsVC.h"
#import "SetPasswordVC.h"
#import "NSDictionary+Extension.h"
#import "NSString+Extension.h" 

@interface PersonalInformationVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UIView *genderView;
@property (weak, nonatomic) IBOutlet UIImageView *manImageView;
@property (weak, nonatomic) IBOutlet UIImageView *femaleImageView;


@property (nonatomic, strong) NSMutableDictionary *dic;
@property (nonatomic, strong) NSArray *titleArray;

@property (nonatomic, strong) UserModel *userModel;
//是否可以修改账号
@property (nonatomic, assign) NSInteger chgMemberName;
//@property (nonatomic, strong) SetPasswordVC
@property (nonatomic, assign) BOOL isUpdate;


@end

@implementation PersonalInformationVC

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateData];
}

-(void)currentData{
    VSWeakSelf(self)
    [UserManager getMemberInfo:self.userModel.accessToken appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        UserModel *model = [[UserModel alloc] initWithDictionary:dic];
        model.accessToken = weakself.userModel.accessToken;
        weakself.chgMemberName = [dic[@"chgMemberName"] integerValue];
        [[DBService shareInstance] updateUserModel:model];
        weakself.userModel = [[DBServiceUser shareInstance] getUserAlldata];
        [weakself updateData];
    } failure:^(NSString * _Nullable errorMessage) {
        if ([errorMessage containsString:@"token非法或者失效"]) {
            [[DBServiceUser shareInstance] clearUserTable];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:nil];
            
        }else{
            [[UIApplication sharedApplication].keyWindow makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    self.view.backgroundColor = RGB0X(0xf7f7f7);

    [self.tableView registerNib:[InformationHeaderCell nib] forCellReuseIdentifier:[InformationHeaderCell cellReuseIdentifier]];
    [self.tableView registerNib:[InformationCell nib] forCellReuseIdentifier:[InformationCell cellReuseIdentifier]];
    [self.tableView registerNib:[ExitAccountCell nib] forCellReuseIdentifier:[ExitAccountCell cellReuseIdentifier]];

    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.genderView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:self.genderView];
    
    self.manImageView.hidden = NO;
    self.femaleImageView.hidden = YES;
    self.genderView.hidden = YES;
    [self updateData];
    [self currentData];
}

- (NSMutableDictionary *)dic {
    if (!_dic) {
        _dic = [NSMutableDictionary dictionary];
    }
    return _dic;
}

-(void)updateData{
    self.userModel = [[DBServiceUser shareInstance] getUserAlldata];
    self.manImageView.hidden = self.userModel.sex == 0?NO:YES;
    self.femaleImageView.hidden = self.userModel.sex == 0?YES:NO;
     
    NSString *sexStr = self.userModel.sex == 0 ? @"男" : @"女";
    NSString *mobile = [NSString isBlankString:self.userModel.mobile] ? @"未绑定" : self.userModel.mobile;
    NSString *nameStr = [NSString isBlankString:self.userModel.nickname] ? @"" : self.userModel.nickname;
    NSString *imageStr = [NSString isBlankString:self.userModel.iconUrl] ? @"account_head_portrait5" : self.userModel.iconUrl;
    NSString *qqLoginStr = [NSString isBlankString:self.userModel.qqOpenId] ? @"未绑定" : @"已绑定";
    NSString *wxLoginStr =[NSString isBlankString:self.userModel.wxOpenId] ? @"未绑定" : @"已绑定";

    _dic = [NSMutableDictionary dictionaryWithDictionary:@{
    @"1":@{@"头像":imageStr,@"昵称":nameStr,@"账号":[NSString stringWithFormat:@"%@",self.userModel.memberName],@"性别":sexStr},
    @"2":@{@"更换手机":mobile,@"修改密码":@""},
    @"3":@{@"绑定QQ":qqLoginStr,@"绑定微信":wxLoginStr},@"4":@{@"高级设置":@""},@"5":@{@"退出账号":@"退出账号"}}];
    [self.tableView reloadData];
}

 
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dic.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *str = [NSString stringWithFormat:@"%ld",(long)section+1];
    NSDictionary *array = self.dic[str];
    return array.allKeys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
    NSDictionary *array = self.dic[str];
    NSString *titleStr = array.allKeys[indexPath.row];
    NSString *describeStr = array[titleStr];
    if ([titleStr isEqualToString:@"头像"]) {
        InformationHeaderCell *cell = [tableView dequeueReusableCellWithIdentifier:[InformationHeaderCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleStr;
        UIImage *image = [UIImage imageNamed:describeStr];
        if (image) {
            cell.headImageView.image = image;
        }else{
            [cell.headImageView sd_setImageWithURL:[NSURL URLWithString:describeStr]];
        }
        return cell;
    }
 
    if ([titleStr isEqualToString:@"昵称"]||[titleStr isEqualToString:@"账号"]||[titleStr isEqualToString:@"性别"]||[titleStr isEqualToString:@"更换手机"]||[titleStr isEqualToString:@"修改密码"]||[titleStr isEqualToString:@"绑定微信"]||[titleStr isEqualToString:@"绑定QQ"]||[titleStr isEqualToString:@"高级设置"]) {
         
        InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:[InformationCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.titleLabel.text = titleStr;
        if ([describeStr isEqualToString:@"未绑定"]&&[titleStr isEqualToString:@"更换手机"]) {
            cell.titleLabel.text = @"绑定手机";
        }
        
        if ([self.userModel.emptyPwd isEqualToString:@"1"]&&[titleStr isEqualToString:@"修改密码"]) {
            cell.titleLabel.text = @"设置密码";
        }
        
        cell.describeNameLabel.text = describeStr;
        if (indexPath.row == 2 && indexPath.section == 0 && self.chgMemberName == 0) {
            cell.arrowImageView.hidden = YES;
            cell.describeNameLabel.hidden = YES;
            cell.describeName1Label.hidden = NO;
            cell.describeName1Label.text = describeStr;
         }else{
            cell.arrowImageView.hidden = NO;
            cell.describeNameLabel.hidden = NO;
            cell.describeName1Label.hidden = YES;
        }
        return cell;
    }
 
    if ([titleStr isEqualToString:@"退出账号"]) {
        ExitAccountCell *cell = [tableView dequeueReusableCellWithIdentifier:[ExitAccountCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = [NSString stringWithFormat:@"%ld",(long)indexPath.section+1];
    NSDictionary *array = self.dic[str];
    NSString *titleStr = array.allKeys[indexPath.row];
    if ([titleStr isEqualToString:@"头像"]) {
        HeaderVC *vc = [HeaderVC loadViewFromXibOrNot];
        [vc setRefreshBlock:^{
            self.refreshBlock();
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titleStr isEqualToString:@"昵称"]) {
        NicknameVC *vc = [NicknameVC loadViewFromXibOrNot];
        [vc setRefreshBlock:^{
            self.refreshBlock();
        }];
        [self.navigationController pushViewController:vc animated:YES];
    }
    if ([titleStr isEqualToString:@"账号"]) {
        if (self.chgMemberName == 1) {
            AccountSetVC *vc = [AccountSetVC loadViewFromXibOrNot];
            [vc setBlock:^{
                [self currentData];
            }];
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if ([titleStr isEqualToString:@"性别"]) {
        self.manImageView.hidden = self.userModel.sex == 0?NO:YES;
        self.femaleImageView.hidden = self.userModel.sex == 0?YES:NO;
        self.genderView.hidden = NO;
    }
    if ([titleStr isEqualToString:@"更换手机"]) {
        if (self.userModel.mobile.length == 0) {
            NewMobilePhoneVC *VC = [NewMobilePhoneVC loadViewFromXibOrNot];
            [self.navigationController pushViewController:VC animated:YES];
        }else{
            OldMobilePhoneVC *VC = [OldMobilePhoneVC loadViewFromXibOrNot];
            VC.iPhoneStr = [self.userModel.mobile substringFromIndex:3];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
    if ([titleStr isEqualToString:@"修改密码"]) {
        if ([self.userModel.emptyPwd isEqualToString:@"1"]) {
            SetPasswordVC *vc = [SetPasswordVC loadViewFromXibOrNot];
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            //
            EditorChangePasswordVC *vc = [EditorChangePasswordVC loadViewFromXibOrNot];
            if (self.userModel.mobile.length == 0) {
                vc.isMobile = NO;
            }else{
                vc.isMobile = YES;
            }
            [self.navigationController pushViewController:vc animated:YES];
        }
    }
    if ([titleStr isEqualToString:@"绑定微信"]) {
        if ([NSString isBlankString:self.userModel.wxOpenId]) {
            [self weichatLogin];
        }else{
            [self replaceAccount:@"wx"];
        }
    }
    if ([titleStr isEqualToString:@"绑定QQ"]) {
        if ([NSString isBlankString:self.userModel.qqOpenId]) {
            [self qqLogin];
        }else{
            [self replaceAccount:@"qq"];
        }
    }
    if ([titleStr isEqualToString:@"高级设置"]) {
        AdvancedSettingsVC *VC = [AdvancedSettingsVC loadViewFromXibOrNot];
        [self.navigationController pushViewController:VC animated:YES];
    }
    if ([titleStr isEqualToString:@"退出账号"]) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"退出将无法继续享受会员服务,请确定是否要退出?" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self exitAccount];
        }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {}];
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)exitAccount {
    [[DBServiceUser shareInstance] clearUserTable];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication].keyWindow makeToast:@"退出成功" duration:KDuration position:CSToastPositionCenter];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];

     
    [UserManager getLogout:self.userModel.accessToken completionHandler:^(id  _Nullable responseObject) {
    } failure:^(NSString * _Nullable errorMessage) {
    }];
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 4) {
        return 20;
    }
    return 8;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 70;
    }
    return 51;
}


- (IBAction)didClickSex:(UIButton *)sender {
    if (sender.tag == 30000) {
        self.manImageView.hidden = NO;
        self.femaleImageView.hidden = YES;
    }else if(sender.tag == 30001){
        self.manImageView.hidden = YES;
        self.femaleImageView.hidden = NO;
    }
}
#pragma mark ----- 确定性别
- (IBAction)didClickGenderSure:(UIButton *)sender {
    BOOL isMan = self.manImageView.hidden;
    __block NSString *sexStr = isMan == YES ? @"1":@"0";
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getModifyUserInformationAccessToken:self.userModel.accessToken content:sexStr type:@"sex" completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        [weakself.genderView setHidden:YES];
        weakself.userModel.sex = [sexStr integerValue];
        [[DBServiceUser shareInstance] updateUserModel:weakself.userModel];
        weakself.userModel = [[DBServiceUser shareInstance] getUserAlldata];
        [weakself updateData];
        [weakself.view makeToast:@"性别修改成功" duration:KDuration position:CSToastPositionCenter];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}


-(void)qqLogin{
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        [[QQLoginManager shareManager] qqLoginAuthorization];
        [[QQLoginManager shareManager] setQqSuccessful:^(NSString * _Nonnull extraStr, NSString * _Nonnull appID) {
            [self getUserLogin:extraStr appID:appID type:@"qq"];
        }];
        [[QQLoginManager shareManager] setQqFailure:^(NSString * _Nonnull error) {
            [self.view makeToast:error duration:KDuration position:CSToastPositionCenter];
        }];
    } else{
        [self.view makeToast:@"没有安装QQ" duration:KDuration position:CSToastPositionCenter];
    }
}

-(void)weichatLogin{
    //判断微信是否安装
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        [self.view makeToast:@"没有安装微信" duration:KDuration position:CSToastPositionCenter];
    }else{
        [[WeixinLoginManager shareManager] sendAuthRequest];
        [[WeixinLoginManager shareManager] setSuccessful:^(NSString * _Nonnull extraStr, NSString * _Nonnull appID) {
            [self getUserLogin:extraStr appID:appID type:@"wx"];
        }];
        [[WeixinLoginManager shareManager] setFailure:^(NSString * _Nonnull error) {
            [self.view makeToast:error duration:KDuration position:CSToastPositionCenter];
        }];
    }
}

-(void)getUserLogin:(NSString *)extraStr appID:(NSString *)appId type:(NSString *)type{
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getBindThirdOauth:self.userModel.accessToken openId:appId thirdType:type extra:extraStr completionHandler:^(id  _Nullable responseObject) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UserManager getMemberInfo:weakself.userModel.accessToken appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
            [weakself.view hideToastActivity]; 
            NSDictionary *dic = [NSDictionary changeType:responseObject]; 
            UserModel *model = [[UserModel alloc] initWithDictionary:dic];
            model.accessToken = weakself.userModel.accessToken;
            [[DBService shareInstance] insertUserOneData:model];
            weakself.userModel = [[DBServiceUser shareInstance] getUserAlldata];
            [weakself updateData];
        } failure:^(NSString * _Nullable errorMessage) {
            [weakself.view hideToastActivity];
            [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

//取消绑定
-(void)replaceAccount:(NSString *)type {
    NSString *currentType = [type isEqualToString:@"qq"]?@"QQ":@"微信";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                      message:[NSString stringWithFormat:@"是否要替换%@",currentType]
                                                               preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"替换" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
        if ([type isEqualToString:@"qq"]) {
            [self qqLogin];
        }else{
            [self weichatLogin];
        }
    }];
    UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {}];
    [alert addAction:defaultAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:nil];

}

- (IBAction)didClickCancleGenderView:(UITapGestureRecognizer *)sender {
    [self.genderView setHidden:YES];
}


- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
 }

-(UserModel *)userModel{
    if (!_userModel) {
         _userModel = [[DBServiceUser shareInstance] getUserAlldata];
    }
    return _userModel;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
