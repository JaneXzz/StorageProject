//
//  ShareApiManager.h
//  玛雅天气
//
//  Created by 1 on 2019/4/10.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WBHttpRequest.h"

NS_ASSUME_NONNULL_BEGIN

@interface ShareApiManager : NSObject <WBHttpRequestDelegate>
/**
 *  严格单例，唯一获得实例的方法.
 *
 *  @return 实例对象.
 */
+ (instancetype)sharedManager;

- (void)sendImageContent:(UIImage *)image;
-(void)QQShare:(UIImage *)image;

/** 发送链接到 QQ
 * @param urlString 链接的Url
 *
 * @param title 链接的Title
 *
 * @param desc 链接的描述
 */

-(void)qqSendLinkContent:(NSString *)urlString
                 Title:(NSString *)title
           Description:(NSString *)desc;



/** 发送链接到 微博
 * @param urlString 链接的Url
 *
 * @param title 链接的Title
 *
 * @param desc 链接的描述
 */

-(void)wbSendLinkContent:(NSString *)urlString
                 Title:(NSString *)title
           Description:(NSString *)desc;

@end

NS_ASSUME_NONNULL_END
