//
//  NicknameVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "NicknameVC.h"
#import "LoginPublic.h"
#import "UserManager.h"
#import "UserModel.h"
#import "DBServiceUser.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "UITextField+extension.h"

@interface NicknameVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UITextField *nickNameTextField;
@property (nonatomic, strong) UserModel *userModel;

@end

@implementation NicknameVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    self.view.backgroundColor = [UIColor whiteColor];
    [self gradientView:self.lineView];
    self.nickNameTextField.text = self.userModel.nickname;
    [self.nickNameTextField placeholderColor:KPlaceholderColor];
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
    NSString *nickName = self.nickNameTextField.text;
    if (![CheckInputValid checkForNicknameWithInString:nickName]) {
        NSString *nickNameStr = [CheckInputValid checkIfTheNicknameIsLegal:nickName];
        [self.view makeToast:nickNameStr duration:KDuration position:CSToastPositionCenter];
        return;
    }


    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getModifyUserInformationAccessToken:self.userModel.accessToken content:nickName type:@"nickname" completionHandler:^(id  _Nullable responseObject) {
        weakself.refreshBlock();
        [weakself.view hideToastActivity];
        weakself.userModel.nickname = nickName;
        [[DBServiceUser shareInstance] updateUserModel:weakself.userModel];
        weakself.userModel = [[DBServiceUser shareInstance] getUserAlldata];
        [[UIApplication sharedApplication].keyWindow makeToast:@"昵称修改成功" duration:KDuration position:CSToastPositionCenter];
        [weakself.navigationController popViewControllerAnimated:YES];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

-(UserModel *)userModel{
    if (!_userModel) {
         _userModel = [[DBServiceUser shareInstance] getUserAlldata];
    }
    return _userModel;
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
