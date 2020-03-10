//
//  RegisteredVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "RegisteredVC.h"
#import "LoginPublic.h"
#import "IXAttributeTapLabel.h"
#import "UserManager.h"
#import "UIView+Toast.h"
#import "CheckInputValid.h"
#import "Registered2VC.h"
#import "UITextField+extension.h"
#import "UrlPageVC.h"

@interface RegisteredVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
//手机号
@property (weak, nonatomic) IBOutlet UITextField *mobilePhoneTextField;
//密码
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
  
@property (weak, nonatomic) IBOutlet IXAttributeTapLabel *textLabel;

@property (weak, nonatomic) IBOutlet UIView *line1View;

@property (weak, nonatomic) IBOutlet UIView *line2View;

@property (assign, nonatomic) BOOL isAgreed;

@end

@implementation RegisteredVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self.mobilePhoneTextField placeholderColor:KPlaceholderColor];
    [self.passwordTextField placeholderColor:KPlaceholderColor];
    
    NSString *str = @"已阅读并同意《用户服务协议》和《隐私政策》";
    VSWeakSelf(self)
    self.textLabel.tapBlock = ^(NSString *string) {
        if ([string isEqualToString:@"《用户服务协议》"]) {
            UrlPageVC *vc = [UrlPageVC loadViewFromXibOrNot];
            vc.urlStr = @"http://www.doudoubird.com/ddn/ddnUserAgreement.html";
            [weakself.navigationController pushViewController:vc animated:YES];
        }else if([string isEqualToString:@"《隐私政策》"]){
            UrlPageVC * vc= [UrlPageVC loadViewFromXibOrNot];
            vc.urlStr = @"http://www.doudoubird.com/ddn/ddnPolicy.html";
            [self.navigationController pushViewController:vc animated:YES];
        }
    };
    
    IXAttributeModel *model = [IXAttributeModel new];
    model.range = [str rangeOfString:@"《用户服务协议》"];
    model.string = @"《用户服务协议》";
    model.attributeDic = @{NSForegroundColorAttributeName:RGB0X(0x6495ED)};
    
    IXAttributeModel *model1 = [IXAttributeModel new];
    model1.range = [str rangeOfString:@"《隐私政策》"];
    model1.string = @"《隐私政策》";
    model1.attributeDic = @{NSForegroundColorAttributeName:RGB0X(0x6495ED)};
    //label内容赋值
    [self.textLabel setText:str attributes:@{NSForegroundColorAttributeName:RGB0X(0xD8D8D8),NSFontAttributeName:[UIFont systemFontOfSize:15]} tapStringArray:@[model,model1]];
    
    [self gradientView:self.line1View];
    [self gradientView:self.line2View];
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


#pragma mark ---- 注册
- (IBAction)didClickRegistered:(UIButton *)sender {
    [self.mobilePhoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];
    //检测手机号码
    NSString *phoneStr = self.mobilePhoneTextField.text;
    if (![CheckInputValid checkForPhoneNumberWithInString:phoneStr]) {
        [self.view makeToast:[CheckInputValid checkThePhoneNumberStatus:self.mobilePhoneTextField.text] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    //密码
    NSString *password = self.passwordTextField.text;
    if (![CheckInputValid checkForPasswordWithInString:password]) {
        [self.view makeToast:[CheckInputValid checkPasswordStatusString:password] duration:KDuration position:CSToastPositionCenter];
        return;
    }
    //是否同意协议
    if (self.isAgreed != YES) {
        [self.view makeToast:@"请阅读《用户协议》和《隐私政策》并同意"];
        return;
    }
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getMemberCheckField:self.mobilePhoneTextField.text fieldType:@"mobile" completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        Registered2VC *vc = [Registered2VC loadViewFromXibOrNot];
        vc.iphoneNameStr = phoneStr;
        vc.passwordStr = password;
        [weakself.navigationController pushViewController:vc animated:YES];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [[UIApplication sharedApplication].keyWindow makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}
#pragma mark ---- 选择阅读
- (IBAction)didClickSelectButton:(UIButton *)sender {
    if (sender.selected) {
          sender.selected = NO;
      }else{
          sender.selected = YES;
      }
    self.isAgreed = sender.selected;
}

#pragma mark ---- 展示密码
- (IBAction)didClickShowPassword:(UIButton *)sender {
  self.passwordTextField.secureTextEntry = !self.passwordTextField.secureTextEntry;
    if (sender.selected == YES) {
        sender.selected = NO;
    }else{
        sender.selected = YES;
    }
}
- (IBAction)didClickTap:(UITapGestureRecognizer *)sender {
    [self.mobilePhoneTextField resignFirstResponder];
    [self.passwordTextField resignFirstResponder];

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
