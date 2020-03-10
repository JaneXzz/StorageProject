//
//  ForgotPasswordVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "ForgotPasswordVC.h"
#import "ChangePasswordVC.h"
#import "LoginPublic.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"
#import "NSDictionary+Extension.h"



@interface ForgotPasswordVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
//手机号码
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTextField;
//输入内验证码
@property (weak, nonatomic) IBOutlet UITextField *verificationCodeTextField;
//获取验证码倒计时
@property (weak, nonatomic) IBOutlet UIButton *codeButton;
//前缀
@property (weak, nonatomic) IBOutlet UIButton *prefixButton;

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (weak, nonatomic) IBOutlet UIView *codeView;


@property(nonatomic) dispatch_source_t timer;
@property(nonatomic) NSInteger timecount;

@end

@implementation ForgotPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.mobilePhoneTextField placeholderColor:KPlaceholderColor];
    [self.verificationCodeTextField placeholderColor:KPlaceholderColor];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self gradientView:self.line1View];
    [self gradientView:self.line2View];
    [self gradientView:self.codeView];
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

#pragma mark ---- 获取验证码
- (IBAction)didClickGetVerificationCode:(UIButton *)sender {
    VSWeakSelf(self)
     
    if (![CheckInputValid checkForPhoneNumberWithInString:self.mobilePhoneTextField.text]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.mobilePhoneTextField.text] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getSendSMS:self.mobilePhoneTextField.text completionHandler:^(id  _Nullable responseObject){
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



- (IBAction)didClickTap:(UITapGestureRecognizer *)sender {
    [self.mobilePhoneTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
}

#pragma mark ---- 点击下一步
- (IBAction)didClickNextPage:(UIButton *)sender {
    [self.mobilePhoneTextField resignFirstResponder];
    [self.verificationCodeTextField resignFirstResponder];
    //检测手机号码
    NSString *phoneStr = self.mobilePhoneTextField.text;
    NSString *codeStr = self.verificationCodeTextField.text;
    if (![CheckInputValid checkForPhoneNumberWithInString:phoneStr]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.mobilePhoneTextField.text] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    if (![CheckInputValid checkForConfirmCodeWithInString:codeStr]) {
        [self.view makeToast:[CheckInputValid checkTheConfirmCodeStatus:codeStr] duration:KDuration position:CSToastPositionCenter];
        return;
    }
 
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getMemberExistsField:phoneStr isRegistered:NO completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        int code = [dic[@"dic"] intValue];
        if (code == 0) {
            ChangePasswordVC *vc = [ChangePasswordVC loadViewFromXibOrNot];
            vc.iphoneStr = phoneStr;
            vc.codeStr = codeStr;
            [weakself.navigationController pushViewController:vc animated:YES];
        }
     } failure:^(NSString * _Nullable errorMessage) {
         [weakself.view hideToastActivity];
         [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionBottom];
     }];
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

@end
