//
//  ChangePasswordVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "ChangePasswordVC.h"
#import "LoginPublic.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"
#import "LoginVC.h"

@interface ChangePasswordVC ()
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;

@end

@implementation ChangePasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self.textField placeholderColor:KPlaceholderColor];
    [self gradientView:self.lineView];
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


- (IBAction)didClickSavePassword:(id)sender {
    //检测手机号码
      if (![CheckInputValid checkForPhoneNumberWithInString:self.iphoneStr]) {
         [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.iphoneStr] duration:KDuration position:CSToastPositionCenter];
         return;
     }
     //密码
     if (![CheckInputValid checkForConfirmCodeWithInString:self.codeStr]) {
         [self.view makeToast:[CheckInputValid checkTheConfirmCodeStatus:self.codeStr] duration:KDuration position:CSToastPositionCenter];
         return;
     }
    
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getMobileChangePassword:self.iphoneStr smsCode:self.codeStr password:self.textField.text completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:@"密码修改成功" duration:KDuration position:CSToastPositionCenter];
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[LoginVC class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];

}
- (IBAction)didClickTap:(UITapGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
}

#pragma mark ---- 展示密码
- (IBAction)didClickShowPassword:(UIButton *)sender {
  self.textField.secureTextEntry = !self.textField.secureTextEntry;
    if (sender.selected == YES) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}

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
