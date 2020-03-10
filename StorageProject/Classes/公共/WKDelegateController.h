//
//  WKDelegateController.h
//  豆豆计算器
//
//  Created by 1 on 2019/12/6.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WKDelegate <NSObject>

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message;

@end


@interface WKDelegateController : UIViewController<WKScriptMessageHandler>

@property (weak , nonatomic) id<WKDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
