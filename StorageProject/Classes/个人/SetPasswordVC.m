//
//  SetPasswordVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/11/21.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "SetPasswordVC.h"
#import "UserManager.h"
#import "LoginPublic.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "UserModel.h"
#import "DBServiceUser.h"
#import "UITextField+extension.h"


@interface SetPasswordVC ()

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation SetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self gradientView:self.lineView];
    self.userModel = [[DBServiceUser shareInstance] getUserAlldata];
    [self.textField placeholderColor:KPlaceholderColor];
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


- (IBAction)didClickTap:(UITapGestureRecognizer *)sender {
    [self.textField resignFirstResponder];
}

 
- (IBAction)didClickSavePassword:(id)sender {
    //密码
    if (![CheckInputValid checkForPasswordWithInString:self.textField.text]) {
        [self.view makeToast:[CheckInputValid checkPasswordStatusString:self.textField.text] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getChangePassword:self.userModel.accessToken password:@"" newPassword:self.textField.text completionHandler:^(id  _Nullable responseObject) {
        [[UIApplication sharedApplication].keyWindow makeToast:@"设置密码成功" duration:KDuration position:CSToastPositionCenter];
        [weakself.view hideToastActivity];
        weakself.userModel.emptyPwd = @"0";
        [[DBServiceUser shareInstance] updateUserModel:weakself.userModel];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [[UIApplication sharedApplication].keyWindow makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
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
