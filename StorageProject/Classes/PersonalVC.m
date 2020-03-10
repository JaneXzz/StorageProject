//
//  PersonalVC.m
//  PersonalCenter
//
//  Created by Jane on 2020/3/5.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "PersonalVC.h"
#import "LoginVC.h"
#import "VIPMemberVC.h"
#import "IntegralVC.h"
#import "DBServiceUser.h"
#import "WebPageVC.h"
#import "PersonalInformationVC.h"
#import "FeedbackVC.h"

@interface PersonalVC ()
@property (nonatomic, strong) UserModel *userModel;
@end

@implementation PersonalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _userModel = [[DBServiceUser shareInstance] getUserAlldata];
 
}
- (IBAction)didClickVIP:(id)sender {
    VIPMemberVC *vc = [VIPMemberVC loadViewFromXibOrNot];
    [vc setRefreshBlock:^{
        NSLog(@"VIPMemberVC刷新");
    }];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)didClickLogin:(id)sender {
    LoginVC *loginVC = [LoginVC loadViewFromXibOrNot];
    loginVC.isVip = NO;
    [loginVC setMyBlock:^(UserModel * _Nonnull model) {
        NSLog(@"LoginVC刷新");
    }];
    [self.navigationController pushViewController:loginVC animated:YES];
}

- (IBAction)didClickIntegral:(id)sender {
    IntegralVC *integralVC = [IntegralVC loadViewFromXibOrNot];
    integralVC.userModel = self.userModel;
    [self.navigationController pushViewController:integralVC animated:YES];
}

//客服
- (IBAction)didClickCustomerServiceSupport:(id)sender{
    FeedbackVC *feedbackVC = [FeedbackVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:feedbackVC animated:YES];
}
//隐私
- (IBAction)didClickPrivacy:(id)sender{
    WebPageVC *VC = [WebPageVC loadViewFromXibOrNot];
    VC.urlStr = @"http://www.doudoubird.com/ddn/ddnPolicy.html";
    [self.navigationController pushViewController:VC animated:YES];
}
//个人
- (IBAction)didClickPersonal:(id)sender{
    PersonalInformationVC *VC = [PersonalInformationVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:VC animated:YES];
}

@end
