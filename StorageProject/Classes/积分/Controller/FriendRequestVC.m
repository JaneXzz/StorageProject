//
//  FriendRequestVC.m
//  玛雅天气
//
//  Created by Jane on 2020/3/3.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "FriendRequestVC.h"
#import "DBServiceUser.h"
#import "UserModel.h"
#import "LoginPublic.h"
#import "UIView+Toast.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "CipherManagement.h"
#import "DBServiceIntegral.h"
#import "JsonHelper.h"
#import "WXApiManager.h"
#import "ShareApiManager.h"

@interface FriendRequestVC ()

@property (nonatomic, strong) UserModel *userModel;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *shareView;

@property (nonatomic, strong) NSDictionary *aesDic;

@end

@implementation FriendRequestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self createUIWebViewTest];
    [self.view makeToastActivity:CSToastPositionCenter];
    self.shareView.hidden = YES;

    
}

- (void)createUIWebViewTest {
    self.webView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
//    NSString *str = [NSString stringWithFormat:@"access_token=%@",self.userModel.accessToken];
//    NSDictionary *dic = [CipherManagement encryption:str];
//    NSString *path = [NSString stringWithFormat:@"%@?key=%@&paramd=%@",KLogoutPage,dic[@"key"],dic[@"paramd"]];
 

    NSURL *remoteURL = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL];
    [self.webView loadRequest:request];
    self.webView.scalesPageToFit = YES;
}


- (IBAction)didClickShareView:(id)sender {
    self.shareView.hidden = YES;
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
             self.aesDic = JsonHelperDictionaryFromString(str);
//             NSString *inviteCode = aesDic[@"inviteCode"];
//             NSString *link = aesDic[@"link"];
             self.shareView.hidden = NO;
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

//微信
- (IBAction)didClickWechat:(id)sender {
    NSString *inviteCode = self.aesDic[@"inviteCode"];
    NSString *link = self.aesDic[@"link"];
    
    BOOL isSuccessful = [[WXApiManager sharedManager] sendLinkContent:link Title:inviteCode Description:@"" AtScene:WXSceneSession];
    if (!isSuccessful) {
        NSLog(@"朋友圈微信没有安装");
    }
}
//朋友圈
- (IBAction)didClickCircleFriends:(id)sender {
    NSString *inviteCode = self.aesDic[@"inviteCode"];
    NSString *link = self.aesDic[@"link"];
    BOOL isSuccessful = [[WXApiManager sharedManager] sendLinkContent:link Title:inviteCode Description:@"" AtScene:WXSceneTimeline];
    if (!isSuccessful) {
        NSLog(@"朋友圈微信没有安装");
    }
}
- (IBAction)didClickQQ:(id)sender {
    NSString *inviteCode = self.aesDic[@"inviteCode"];
    NSString *link = self.aesDic[@"link"];
//    link = @"https://apps.apple.com/cn/app/id1453347489";
    [[ShareApiManager sharedManager] qqSendLinkContent:link Title:@"玛雅天气" Description:inviteCode];
    
}
- (IBAction)didClickWeibo:(id)sender {
    NSString *inviteCode = self.aesDic[@"inviteCode"];
    NSString *link = self.aesDic[@"link"];
//    link = @"https://apps.apple.com/cn/app/id1453347489";
    [[ShareApiManager sharedManager] wbSendLinkContent:link Title:@"玛雅天气" Description:inviteCode];
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
