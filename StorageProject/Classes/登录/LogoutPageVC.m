//
//  LogoutPageVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/11/19.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "LogoutPageVC.h"
#import "DBServiceUser.h"
#import "UserModel.h"
#import "LoginPublic.h"
#import "UIView+Toast.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CipherManagement.h"
#import "DBServiceIntegral.h"


@interface LogoutPageVC ()<UIWebViewDelegate>

@property (nonatomic, strong) UserModel *userModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation LogoutPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self createUIWebViewTest];
    [self.view makeToastActivity:CSToastPositionCenter];
}

- (void)createUIWebViewTest {
    self.webView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    NSString *str = [NSString stringWithFormat:@"access_token=%@",self.userModel.accessToken];
//    NSDictionary *dic = [CipherManagement encryption:str];
//    NSString *path = [NSString stringWithFormat:@"%@?key=%@&paramd=%@",KLogoutPage,dic[@"key"],dic[@"paramd"]];
 

    NSURL *remoteURL = [NSURL URLWithString:self.str];
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}

//开始加载网页
- (void)webViewDidStartLoad:(UIWebView *)webView {
   
}

//网页加载完成
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [self.view hideToastActivity];
    JSContext *jsContext = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    jsContext[@"callIOSAction"] = ^(NSString *str) {
         dispatch_async(dispatch_get_main_queue(), ^{
             if ([str isEqualToString:@"0"]) {
                 [self.navigationController popViewControllerAnimated:YES];
             }else if([str isEqualToString:@"1"]){
                 [self exitAccount];
             }
        });
    };
    NSString *htmlTitle = @"document.title";
    NSString *titleHtmlInfo = [webView stringByEvaluatingJavaScriptFromString:htmlTitle];
    self.titleLabel.text = titleHtmlInfo;
}


-(void)exitAccount {
    [[DBServiceUser shareInstance] clearUserTable];
    [[DBServiceIntegral shareInstance] clearIntegralTable];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popToRootViewControllerAnimated:YES];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];
 }
 

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}


//网页加载错误
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [self.view hideToastActivity];
    [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:KDuration position:CSToastPositionCenter];
    [self didClickGoback:nil];
}

- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

-(UserModel *)userModel {
     if (!_userModel) {
         _userModel = [[DBServiceUser shareInstance] getUserAlldata];
     }
     return _userModel;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
