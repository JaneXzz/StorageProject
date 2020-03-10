//
//  EditorChangePasswordVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "EditorChangePasswordVC.h"
#import "LoginPublic.h"
#import "UserModel.h"
#import "UIView+Toast.h"
#import "UserManager.h"
#import "DBServiceUser.h"
#import "ForgotPasswordVC.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"


@interface EditorChangePasswordVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *linesView;

@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password1TextField;
@property (weak, nonatomic) IBOutlet UITextField *password2TextField;
@property (weak, nonatomic) IBOutlet UIButton *forgotPasswordButton;

@property (nonatomic, strong) UserModel *userModel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthConstraint;

@end

@implementation EditorChangePasswordVC


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    self.view.backgroundColor = [UIColor whiteColor];
    [self.oldPasswordTextField placeholderColor:KPlaceholderColor];
    [self.password1TextField placeholderColor:KPlaceholderColor];
    [self.password2TextField placeholderColor:KPlaceholderColor];

    for (UIView *view in self.linesView) {
        [self gradientView:view];
    }
    
    if (_isMobile) {
        self.forgotPasswordButton.hidden = NO;
        self.widthConstraint.constant = 100;
    }else{
        self.forgotPasswordButton.hidden = YES;
        self.widthConstraint.constant = 0.5;
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
- (IBAction)didClickSaveButton:(UIButton *)sender {
 
    NSString *oldPassword = self.oldPasswordTextField.text;
    NSString *password1Str = self.password1TextField.text;
    NSString *password2Str = self.password2TextField.text;
    
    
    
    if (![CheckInputValid checkForPasswordWithInString:oldPassword]) {
        [self.view makeToast:[CheckInputValid checkPasswordStatusString:oldPassword] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    if (![CheckInputValid checkForPasswordWithInString:password1Str]) {
          [self.view makeToast:[CheckInputValid checkPasswordStatusString:password1Str] duration:KDuration position:CSToastPositionCenter];
          return;
    }
    
    if (![CheckInputValid checkForPasswordWithInString:password2Str]) {
        [self.view makeToast:[CheckInputValid checkPasswordStatusString:password2Str] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    
    if (![password1Str isEqualToString:password2Str]) {
        [self.view makeToast:@"两个密码不相同" duration:KDuration position:CSToastPositionCenter];
        return;
    }
    
    VSWeakSelf(self)
    if ([password1Str isEqualToString:password2Str]) {
        [self.view makeToastActivity:CSToastPositionCenter];
        [UserManager getChangePassword:self.userModel.accessToken password:oldPassword newPassword:password1Str completionHandler:^(id  _Nullable responseObject) {
            [weakself.view hideToastActivity];
            [[UIApplication sharedApplication].keyWindow makeToast:@"密码修改成功" duration:KDuration position:CSToastPositionCenter];
            [weakself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSString * _Nullable errorMessage) {
            [weakself.view hideToastActivity];
            [[UIApplication sharedApplication].keyWindow makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }];
    }
    
}
#pragma mark --- 忘记密码
- (IBAction)didClickForgetPassword:(UIButton *)sender {
    ForgotPasswordVC *VC = [ForgotPasswordVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:VC animated:YES];
}
-(UserModel *)userModel{
    if (!_userModel) {
         _userModel = [[DBServiceUser shareInstance] getUserAlldata];
    }
    return _userModel;
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
