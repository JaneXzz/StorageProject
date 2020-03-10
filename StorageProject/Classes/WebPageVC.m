//
//  WebPageVC.m
//  玛雅天气
//
//  Created by 1 on 2019/12/27.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "WebPageVC.h"
#import "LoginPublic.h"
#import "UIView+Toast.h"
#import <WebKit/WebKit.h>
#import "WKDelegateController.h"

@interface WebPageVC ()<WKUIDelegate,WKNavigationDelegate,WKScriptMessageHandler,WKDelegate>{
    WKUserContentController *userContentController;
    WKWebView *webView;
}

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WebPageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self createUIWebView];
    [self.view makeToastActivity:CSToastPositionCenter];
    webView.backgroundColor = [UIColor whiteColor];
}

- (void)createUIWebView {
    NSURL *remoteURL = [NSURL URLWithString:self.urlStr];
    NSURLRequest *request =[NSURLRequest requestWithURL:remoteURL
        cachePolicy:NSURLRequestReturnCacheDataElseLoad
    timeoutInterval:20];
    
    WKWebViewConfiguration * configuration = [[WKWebViewConfiguration alloc]init];
    userContentController =[[WKUserContentController alloc]init];
    configuration.userContentController = userContentController;
    webView = [[WKWebView alloc]initWithFrame:CGRectMake(0, NAVGATION_STATUS_BAR_HEIGHT, SCREENWIDTH, SCREENHEIGHT-NAVGATION_STATUS_BAR_HEIGHT) configuration:configuration];
    //注册方法
    WKDelegateController * delegateController = [[WKDelegateController alloc]init];
    delegateController.delegate = self;
    [userContentController addScriptMessageHandler:delegateController  name:@"WKWebView"];
    [self.view addSubview:webView];
    webView.UIDelegate = self;
    webView.navigationDelegate = self;
    [webView loadRequest:request];
}

- (void)dealloc{
    [userContentController removeScriptMessageHandlerForName:@"WKWebView"];
    [webView removeFromSuperview];
    webView = nil;
}
#pragma mark - WKScriptMessageHandler
- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    NSLog(@"name:%@\\\\n body:%@\\\\n frameInfo:%@\\\\n",message.name,message.body,message.frameInfo);
}

// 页面加载完成之后调用
- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation{
    [self.view hideToastActivity];
    self.titleLabel.text = webView.title;
}

- (void)webView:(WKWebView *)webView didFailNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error{
    self.titleLabel.text = webView.title;
    if (error.code == NSURLErrorCancelled) {
        return;
    }
    [self.view hideToastActivity];
    [[UIApplication sharedApplication].keyWindow makeToast:error.localizedDescription duration:2 position:CSToastPositionCenter];
    [self didClickGoback:nil];
}

 - (IBAction)didClickGoback:(id)sender {
     if (webView.canGoBack==YES) {
         [webView goBack];
     }else{
         [self.navigationController popViewControllerAnimated:YES];
     }
 }
 
-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
