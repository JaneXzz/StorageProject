//
//  LoginVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "LoginVC.h"
#import "LoginPublic.h"
#import "ForgotPasswordVC.h"
#import "RegisteredVC.h"
#import "IXAttributeTapLabel.h"
#import "CheckInputValid.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "UUID.h"
#import "UserModel.h"
#import "DBServiceUser.h"
#import "WeixinLoginManager.h"
#import "QQLoginManager.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"
//#import "VIPMemberVC.h"
#import "NSDictionary+Extension.h"
#import "UrlPageVC.h"
#import "DBServiceIntegral.h"


@interface LoginVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@property (weak, nonatomic) IBOutlet UITextField *userNameTextField;

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

@property (weak, nonatomic) IBOutlet UITextField *iphoneTextField;

@property (weak, nonatomic) IBOutlet UITextField *verificationTextField;

@property (weak, nonatomic) IBOutlet IXAttributeTapLabel *textLabel;
 
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *linesView;

@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UIView *shortMessageView;

@property(nonatomic) dispatch_source_t timer;
@property(nonatomic) NSInteger timecount;

@property (weak, nonatomic) IBOutlet UIButton *switchModelButton;


@property (weak, nonatomic) IBOutlet UIButton *weixinButton;
@property (weak, nonatomic) IBOutlet UIButton *QQButton;

@property (weak, nonatomic) IBOutlet UILabel *weixinLabel;
@property (weak, nonatomic) IBOutlet UILabel *QQLabel;

@property (weak, nonatomic) IBOutlet UILabel *threeLoginLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *lines1View;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *weixinConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *qqConstraint;
@end

@implementation LoginVC


- (void)viewDidLoad {
    [super viewDidLoad];
 
    self.view.backgroundColor = [UIColor whiteColor];
    [self.userNameTextField placeholderColor:KPlaceholderColor];
    [self.passwordTextField placeholderColor:KPlaceholderColor];
    [self.iphoneTextField placeholderColor:KPlaceholderColor];
    [self.verificationTextField placeholderColor:KPlaceholderColor];
      
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    NSString *str = @"注册表明已阅读并接受《用户服务协议》";
    VSWeakSelf(self)
    self.textLabel.tapBlock = ^(NSString *string) {
//        UserAgreementVC *vc = [UserAgreementVC loadViewFromXibOrNot];
//        [weakself.navigationController pushViewController:vc animated:YES];
        UrlPageVC *vc = [UrlPageVC loadViewFromXibOrNot];
        vc.urlStr = @"http://www.doudoubird.com/ddn/ddnUserAgreement.html";
        [weakself.navigationController pushViewController:vc animated:YES];

    };
    IXAttributeModel *model = [IXAttributeModel new];
    model.range = [str rangeOfString:@"《用户服务协议》"];
    model.string = @"《用户服务协议》";
    model.attributeDic = @{NSForegroundColorAttributeName:RGB0X(0x6495ED)};
    [self.textLabel setText:str attributes:@{NSForegroundColorAttributeName:RGB0X(0xD8D8D8),NSFontAttributeName:[UIFont systemFontOfSize:15]} tapStringArray:@[model]];
 
    [self gradientView:self.codeView];
    for (UIView *view in self.linesView) {
        [self gradientView:view];
    }
    
    if (![QQApiInterface isQQInstalled] && ![QQApiInterface isQQSupportApi]) {
        NSLog(@"没有安装QQ");
        self.QQButton.hidden = YES;
        self.QQLabel.hidden = YES;
        self.qqConstraint.constant = 80;
    }else{
        NSLog(@"安装QQ");
        self.qqConstraint.constant = 0;
    }
    
    if (![[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        NSLog(@"没有安装微信");
        self.weixinButton.hidden = YES;
        self.weixinLabel.hidden = YES;
        self.weixinConstraint.constant = -80;
    }else{
        NSLog(@"安装微信");
        self.weixinConstraint.constant = 0;
    }
    
    if (self.weixinLabel.hidden == YES && self.QQLabel.hidden == YES) {
        self.threeLoginLabel.hidden = YES;
        for (int i = 0; i < self.lines1View.count; i++) {
            UIView *lineView = self.lines1View[i];
            lineView.hidden = YES;
        }
    }
    if ((self.weixinLabel.hidden == NO) && (self.QQLabel.hidden == NO)) {
        self.weixinConstraint.constant = -80;
        self.qqConstraint.constant = 80;
    }
}


 
-(void)gradientView:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = @[(__bridge id)RGB0X(0x996df5).CGColor,
                             (__bridge id)RGB0X(0x3e9dff).CGColor];
    gradientLayer.startPoint = (CGPoint){.0};
    gradientLayer.endPoint = (CGPoint){1.0};
    [view.layer addSublayer:gradientLayer];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = (CGRect){.0, .0,  gradientLayer.bounds.size.width, gradientLayer.bounds.size.height};
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    gradientLayer.mask = maskLayer;
}
#pragma mark --- 验证码
- (IBAction)didClickVerificationCode:(UIButton *)sender {
     
    if (![CheckInputValid checkForPhoneNumberWithInString:self.iphoneTextField.text]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.iphoneTextField.text] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getSendSMS:self.iphoneTextField.text completionHandler:^(id  _Nullable responseObject){
        [weakself.view hideToastActivity]; 
        [weakself startTimer];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

- (void)startTimer{
    _timecount = 120;
    _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_global_queue(0, 0));
    dispatch_source_set_timer(_timer, DISPATCH_TIME_NOW, 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(_timer, ^{
        if (self.timecount == 1) {
            //关闭定时器
            dispatch_source_cancel(self.timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = YES;
            });
        }else{
            self.timecount -=1;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.codeButton setTitle:[NSString stringWithFormat:@"%ld秒",(long)self.timecount]  forState:UIControlStateNormal];
                self.codeButton.userInteractionEnabled = NO;
            });
        }
    });
    dispatch_resume(self.timer);
}

#pragma mark ---- 忘记密码
-(IBAction)didClickForgotPassword:(UIButton *)sender{
    NSLog(@"忘记密码");
    ForgotPasswordVC *VC = [ForgotPasswordVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:VC animated:YES];
}
#pragma mark ---- 是否显示密码
- (IBAction)didClickDisplayPasswordOrNot:(UIButton *)sender {
    NSLog(@"是否显示密码");
    self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    if (sender.selected == YES) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}


#pragma mark ---- 立即登录
-(IBAction)didClickLoginImmediately:(UIButton *)sender{
    if (self.switchModelButton.selected) {
        //手机验证码登录
        [self.iphoneTextField resignFirstResponder];
        [self.verificationTextField resignFirstResponder];
        
        NSString *phoneStr = self.iphoneTextField.text;
        NSString *codeStr = self.verificationTextField.text;
        if (![CheckInputValid checkForPhoneNumberWithInString:phoneStr]) {
              [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:phoneStr] duration:KDuration position:CSToastPositionCenter];
              return;
          }
          if (![CheckInputValid checkForConfirmCodeWithInString:codeStr]) {
              [self.view makeToast:[CheckInputValid checkTheConfirmCodeStatus:codeStr] duration:KDuration position:CSToastPositionCenter];
              return;
          }
        [self accountLogin:phoneStr password:codeStr type:@"sms"];
    }else{
        //手机密码登录
        [self.userNameTextField resignFirstResponder];
        [self.passwordTextField resignFirstResponder];
        
        NSString *nameStr = self.userNameTextField.text;
        NSString *password = self.passwordTextField.text;
 
        if (![CheckInputValid checkForPasswordWithInString:password]) {
            NSString *passwordStr = [CheckInputValid checkPasswordStatusString:password];
            [self.view makeToast:passwordStr duration:KDuration position:CSToastPositionCenter];
            return;
        }
        [self accountLogin:nameStr password:password type:@"member"];
    }
}


-(void)accountLogin:(NSString *)name password:(NSString *)password type:(NSString *)type{
    VSWeakSelf(self)
    [[UIApplication sharedApplication].keyWindow makeToastActivity:CSToastPositionCenter];
    [UserManager getLogin:name password:password type:type completionHandler:^(id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *access_token = dic[@"access_token"];
//        [[NSUserDefaults standardUserDefaults] setObject:access_token forKey:@"AccessToken"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UserManager getMemberInfo:access_token appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
            NSDictionary *dic = [NSDictionary changeType:responseObject];
            UserModel *model = [[UserModel alloc] initWithDictionary:dic];
            model.accessToken = access_token;
            [[DBService shareInstance] insertIntegralOneData:model.integralModel];
            [[DBService shareInstance] insertUserOneData:model];
            IntegralModel *aaa =  [[DBService shareInstance] getIntegralAlldata];
            NSLog(@"IntegralModel =%@",aaa);
            if (weakself.isVip == YES) {
                weakself.myBlock(model);
//                VIPMemberVC *vc = [VIPMemberVC loadViewFromXibOrNot];
//                vc.isLogin = YES;
//                [self.navigationController pushViewController:vc animated:YES];
            }else{
                weakself.myBlock(model);
                [weakself.navigationController popViewControllerAnimated:YES];
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];
        } failure:^(NSString * _Nullable errorMessage) {
            [[UIApplication sharedApplication].keyWindow hideToastActivity];
        }];
        [weakself.view makeToast:@"登录成功" duration:KDuration position:CSToastPositionCenter];
    } failure:^(NSString * _Nullable errorMessage) {
        [[UIApplication sharedApplication].keyWindow hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

#pragma mark ---- 短信验证码登录
-(IBAction)didClickNoteLogin:(UIButton *)sender {
    NSLog(@"短信验证码登录");
    self.passwordView.hidden = !self.passwordView.hidden;
    self.shortMessageView.hidden = !self.shortMessageView.hidden;
    if (sender.selected == YES) {
        sender.selected = NO;
        [sender setTitle:@"短信验证码登录" forState:UIControlStateNormal];
    }else{
        sender.selected = YES;
        [sender setTitle:@"密码登录" forState:UIControlStateNormal];
    }
}
#pragma mark ---- 新用户注册
-(IBAction)didClickRegister:(UIButton *)sender{
    RegisteredVC *VC = [RegisteredVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark ---- 微信
- (IBAction)didClickWeChat:(UIButton *)sender {
    [self weichatLogin];
}

#pragma mark ---- QQ
- (IBAction)didClickQQ:(UIButton *)sender {
    [self qqLogin];
}

- (IBAction)didClickTap:(UITapGestureRecognizer *)sender {
    [self.userNameTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
}

-(void)qqLogin{
    if ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]) {
        [[QQLoginManager shareManager] qqLoginAuthorization];
           [[QQLoginManager shareManager] setQqSuccessful:^(NSString * _Nonnull extraStr, NSString * _Nonnull appID) {
               [self getUserLogin:extraStr appID:appID type:@"qqLogin"];
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
            [self getUserLogin:extraStr appID:appID type:@"wxLogin"];
        }];
        [[WeixinLoginManager shareManager] setFailure:^(NSString * _Nonnull error) {
            [self.view makeToast:error duration:KDuration position:CSToastPositionCenter];
        }];
    }
   
}

-(void)getUserLogin:(NSString *)extraStr appID:(NSString *)appId type:(NSString *)type{
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getThirdLoginLogin:appId extra:extraStr type:type completionHandler:^(id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        NSString *access_token = dic[@"access_token"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UserManager getMemberInfo:access_token appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
            [weakself.view hideToastActivity];
            NSDictionary *dic = [NSDictionary changeType:responseObject];
            UserModel *model = [[UserModel alloc] initWithDictionary:dic];
            model.accessToken = access_token;
            [[DBService shareInstance] insertUserOneData:model];
            weakself.myBlock(model); 
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];
        } failure:^(NSString * _Nullable errorMessage) { 
            [weakself.view hideToastActivity];
        }];
        [weakself.view makeToast:@"登录成功" duration:KDuration position:CSToastPositionCenter];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

#pragma mark ---- 返回
- (IBAction)didClickGoback:(UIButton *)sender {
    NSLog(@"返回");
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
