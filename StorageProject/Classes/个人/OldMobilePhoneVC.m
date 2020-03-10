//
//  OldMobilePhoneVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "OldMobilePhoneVC.h"
#import "NewMobilePhoneVC.h"
#import "LoginPublic.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"


@interface OldMobilePhoneVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *iphoneLabel;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *linesView;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *codeButton;

@property(nonatomic) dispatch_source_t timer;
@property(nonatomic) NSInteger timecount;
@end

@implementation OldMobilePhoneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    self.view.backgroundColor = [UIColor whiteColor];
    for (UIView *view in self.linesView) {
        [self gradientView:view];
    }
    self.iphoneLabel.text = [NSString stringWithFormat:@"原手机号码: %@",self.iPhoneStr];
    [self.codeTextField placeholderColor:KPlaceholderColor];
    
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
#pragma mark --- 发送验证码
- (IBAction)didClickCodeButton:(UIButton *)sender {
    
    
    if (![CheckInputValid checkForPhoneNumberWithInString:self.iPhoneStr]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.iPhoneStr] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getSendSMS:self.iPhoneStr completionHandler:^(id  _Nullable responseObject){
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


- (IBAction)didClickNextPage:(id)sender {
    NSString *codeStr = self.codeTextField.text;
    //检测手机号码
    if (![CheckInputValid checkForPhoneNumberWithInString:self.iPhoneStr]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.iPhoneStr] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    if (![CheckInputValid checkForConfirmCodeWithInString:codeStr]) {
        [self.view makeToast:[CheckInputValid checkTheConfirmCodeStatus:codeStr] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    
    VSWeakSelf(self)
    NewMobilePhoneVC *vc = [NewMobilePhoneVC loadViewFromXibOrNot];
    vc.oldMobile = self.iPhoneStr;
    vc.oldSmsCode = codeStr;
    [weakself.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}
@end
