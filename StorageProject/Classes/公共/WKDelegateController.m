//
//  WKDelegateController.m
//  豆豆计算器
//
//  Created by 1 on 2019/12/6.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "WKDelegateController.h"

@interface WKDelegateController ()

@end

@implementation WKDelegateController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    if ([self.delegate respondsToSelector:@selector(userContentController:didReceiveScriptMessage:)]) {
        [self.delegate userContentController:userContentController didReceiveScriptMessage:message];
    }
}
 

@end
