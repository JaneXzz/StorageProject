//
//  Registered2VC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/30.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "Registered2VC.h"
#import "LoginPublic.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"
#import "LoginVC.h"
#import "NSDictionary+Extension.h"
#import "DBServiceUser.h"


@interface Registered2VC ()
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
@property (weak, nonatomic) IBOutlet UIView *codeView;

@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *iPhoneLabel;

@property(nonatomic) dispatch_source_t timer;
@property(nonatomic) NSInteger timecount;
@end

@implementation Registered2VC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self gradientView:self.lineView];
    [self gradientView:self.codeView];
    self.iPhoneLabel.text = self.iphoneNameStr;
    [self.verificationCodeTextField placeholderColor:KPlaceholderColor];
    [self didClickGetVerificationCode:nil];
}


#pragma mark ---- 获取验证码
- (IBAction)didClickGetVerificationCode:(UIButton *)sender {
    VSWeakSelf(self)
  
    if (![CheckInputValid checkForPhoneNumberWithInString:self.iphoneNameStr]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.iphoneNameStr] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    
    [UserManager getSendSMS:self.iphoneNameStr completionHandler:^(id  _Nullable responseObject){
         [weakself startTimer];
    } failure:^(NSString * _Nullable errorMessage) {
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

#pragma mark ---- 点击下一步
- (IBAction)didClickNextPage:(UIButton *)sender {
    NSString *codeStr = self.verificationCodeTextField.text;
    //检测手机号码
    if (![CheckInputValid checkForPhoneNumberWithInString:self.iphoneNameStr]) {
         [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.iphoneNameStr] duration:KDuration position:CSToastPositionCenter];
         return;
     } 
     if (![CheckInputValid checkForConfirmCodeWithInString:codeStr]) {
         [self.view makeToast:[CheckInputValid checkTheConfirmCodeStatus:codeStr] duration:KDuration position:CSToastPositionCenter];
         return;
     }
    if (![CheckInputValid checkForPasswordWithInString:self.passwordStr]) {
        [self.view makeToast:[CheckInputValid checkPasswordStatusString:self.passwordStr] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getRegisterByMobile:self.iphoneNameStr password:self.passwordStr smsCode:codeStr completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        [weakself accountLogin:self.iphoneNameStr password:self.passwordStr type:@"member"];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

-(void)accountLogin:(NSString *)name password:(NSString *)password type:(NSString *)type{
     VSWeakSelf(self)
        [[UIApplication sharedApplication].keyWindow makeToastActivity:CSToastPositionCenter];
        [UserManager getLogin:name password:password type:type completionHandler:^(id  _Nullable responseObject) {
            NSDictionary *dic = [NSDictionary changeType:responseObject];
            NSString *access_token = dic[@"access_token"]; 
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [UserManager getMemberInfo:access_token appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
                [[UIApplication sharedApplication].keyWindow hideToastActivity];
                NSDictionary *dic = [NSDictionary changeType:responseObject];
                UserModel *model = [[UserModel alloc] initWithDictionary:dic];
                model.accessToken = access_token;
                [[DBService shareInstance] insertUserOneData:model];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
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
 
- (IBAction)didClickTapGesture:(id)sender {
    [self.verificationCodeTextField resignFirstResponder];
}

#pragma mark ---- 返回
- (IBAction)didClickGoback:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
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

@end
