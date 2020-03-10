//
//  SignInCenterVC.m
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "SignInCenterVC.h"
#import "SignInCalendarCell.h"
#import "SignInRemindCell.h"
#import "LoginPublic.h"
#import "SignInShareVC.h"
#import "UserModel.h"
#import "DBServiceUser.h"
#import "DBServiceIntegral.h"
#import "UserManager.h"
#import "AppDelegate.h"
#import "UIView+Toast.h"
#import "WebPageVC.h"
#import <UserNotifications/UserNotifications.h>


@interface SignInCenterVC ()<SignInCalendarDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (strong, nonatomic) UserModel *userModel;

@property (strong, nonatomic) NSDictionary *dic;

//@property (strong, nonatomic) UILocalNotification *notif;


@end

@implementation SignInCenterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.userModel = [[DBServiceUser shareInstance] getUserAlldata];
    
    [self hiddenNavgation:YES];
    [self.tableView registerNib:[SignInCalendarCell nib] forCellReuseIdentifier:[SignInCalendarCell cellReuseIdentifier]];
    [self.tableView registerNib:[SignInRemindCell nib] forCellReuseIdentifier:[SignInRemindCell cellReuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.tableView.backgroundColor = [UIColor clearColor];
    self.view.backgroundColor = RGB0X(0xf7f7f7);
    
    
    //今天签到
    [self todaySignIn];
    //获得签到数据
    [self getTheCheckInData];
    
    
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"Remind"];
    if (isOpen) {
        [self addlocalNotificationForNewVersion];
    }else{
        [self removeNotification];
    }

}

-(void)todaySignIn{
    VSWeakSelf(self)
    [UserManager getSignIn:self.userModel.accessToken completionHandler:^(id  _Nullable responseObject) {
//        BOOL isSignIn = [responseObject boolValue];
//        if (isSignIn) {
//            [[UIApplication sharedApplication].keyWindow makeToast:@"签到成功" duration:KDuration position:CSToastPositionCenter];
//        }
        NSLog(@"dic = %@",responseObject);
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"getSignInData = %@",errorMessage);
        if ([errorMessage containsString:@"token非法或者失效"]||[errorMessage containsString:@"401"]) {
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


-(void)getTheCheckInData{
    VSWeakSelf(self)
    [UserManager getSignInData:self.userModel.accessToken completionHandler:^(id  _Nullable responseObject) {
        weakself.dic = (NSDictionary *)responseObject;
        weakself.userModel.integralModel.totalScore = [[NSString stringWithFormat:@"%@",weakself.dic[@"totalScore"]] integerValue];
        [[DBServiceIntegral shareInstance] updateIntegralModel:weakself.userModel.integralModel];
         [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"getSignInData errorMessage = %@",errorMessage);
        if ([errorMessage containsString:@"token非法或者失效"]||[errorMessage containsString:@"401"]) {
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        return 580;
    }else{
        return 80;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        SignInCalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:[SignInCalendarCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        cell.totalScoreLabel.text = [NSString stringWithFormat:@"%ld",(long)self.userModel.integralModel.totalScore];
        NSLog(@"cell.totalScoreLabel.text = %@",cell.totalScoreLabel.text);
        cell.nameLabel.text = [NSString stringWithFormat:@"我的%@",self.userModel.integralModel.scoreUnitName];
        cell.totalSignInLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"totalSignIn"]];
        cell.conSignInLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"conSignIn"]];
        cell.signInArray = self.dic[@"monthData"];
        return cell;
    }else {
        SignInRemindCell *cell = [tableView dequeueReusableCellWithIdentifier:[SignInRemindCell cellReuseIdentifier]];
        [cell.switchButton setDidChangeHandler:^(BOOL isOn) {
            [[NSUserDefaults standardUserDefaults] setBool:isOn forKey:@"Remind"];
                   [[NSUserDefaults standardUserDefaults] synchronize];
            if (isOn) {
                [self addlocalNotificationForNewVersion];
            }else{
                [self removeNotification];
            }
         }];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
 
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB0X(0xf7f7f7);
    return bgView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

#pragma mark --- 签到规则
- (void)signInRules{
    NSLog(@"亲到规则");
    WebPageVC *webPage = [WebPageVC loadViewFromXibOrNot];
    webPage.urlStr = @"http://www.doudoubird.com/ddn/scoreRule.html";
    [self.navigationController pushViewController:webPage animated:YES];
}

- (IBAction)didClickShareButton:(id)sender {
    SignInShareVC *vc = [SignInShareVC loadViewFromXibOrNot];
    vc.dic = self.dic;
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)addlocalNotificationForNewVersion {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
        content.body = @"亲，你该去天气签到了！";
        content.sound = [UNNotificationSound defaultSound];

        NSDateComponents *dateCom = [[NSDateComponents alloc] init];
        dateCom.hour = 8;
        UNCalendarNotificationTrigger *trigger = [UNCalendarNotificationTrigger triggerWithDateMatchingComponents:dateCom repeats:YES];
//        NSTimeInterval time = [[NSDate dateWithTimeIntervalSinceNow:10] timeIntervalSinceNow];
//        UNTimeIntervalNotificationTrigger *trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:time repeats:NO];
        UNNotificationRequest *notificationRequest = [UNNotificationRequest requestWithIdentifier:@"SignInRemind10" content:content trigger:trigger];
        [center addNotificationRequest:notificationRequest withCompletionHandler:^(NSError * _Nullable error) {
            NSLog(@"推送成功");
        }];
    }else{
        UILocalNotification *notif = [[UILocalNotification alloc] init];
        // 发出推送的日期
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"HH:mm:ss"];
        NSDate *date = [formatter dateFromString:@"08:00:00"];
        notif.fireDate = date;
        // 推送的内容
        notif.alertBody = @"亲，你该去天气签到了！";
        // 可以添加特定信息
        NSDictionary *info = [NSDictionary dictionaryWithObject:@"name" forKey:@"SignInRemind8"];
        notif.userInfo = info;
        // 提示音
        notif.soundName = UILocalNotificationDefaultSoundName;
        // 每周天循环提醒
        notif.repeatInterval = kCFCalendarUnitDay;
        [[UIApplication sharedApplication] scheduleLocalNotification:notif];
    }
}

// 移除所有通知
- (void)removeNotification {
    if (@available(iOS 10.0, *)) {
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center removeAllPendingNotificationRequests];
    }else {
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
}

- (void)checkUserNotificationEnable { // 判断用户是否允许接收通知
    if (@available(iOS 10.0, *)) {
        __block BOOL isOn = NO;
        UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
        [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
            if (settings.notificationCenterSetting == UNNotificationSettingEnabled) {
                isOn = YES;
                NSLog(@"打开了通知");
            }else {
                isOn = NO;
                NSLog(@"关闭了通知");
               [self showAlertView];
            }
        }];
    }else {
        if ([[UIApplication sharedApplication] currentUserNotificationSettings].types == UIUserNotificationTypeNone){
            NSLog(@"关闭了通知");
            [self showAlertView];
        }else {
            NSLog(@"打开了通知");
        }
    }
}

- (void)showAlertView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"通知" message:@"未获得通知权限，请前去设置" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [alert addAction:[UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
         [self goToAppSystemSetting];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
#pragma mark -- 跳转到设置
- (void)goToAppSystemSetting {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIApplication *application = [UIApplication sharedApplication];
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        if ([application canOpenURL:url]) {
            if (@available(iOS 10.0, *)) {
                if ([application respondsToSelector:@selector(openURL:options:completionHandler:)]) {
                    [application openURL:url options:@{} completionHandler:nil];
                }
            }else {
                [application openURL:url];
            }
        }
    });
}

@end
