//
//  BasisViewController.h
//  PersonalCenter
//
//  Created by Jane on 2020/3/9.
//  Copyright © 2020 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasisViewController : UIViewController
/** 从同名的xib中加载 */
+ (instancetype)loadViewFromXibOrNot;

/** 返回前一个视图控制器 */
- (void)backPreviousVC;

/** 系统生成的返回按钮点击响应方法 */
- (void)backButtonPressed:(id)sender;

/** 把自己从navgation中移除 */
- (void)popMeWhenDismissed;

/** 设置title 传入多语言key */
- (void)setupNavgationItemTitleWithLocalizad:(NSString *)string;
/** 设置title 颜色 */
- (void)setupNavgationItemTitleWithLocalizad:(NSString *)string itemcolor:(UIColor *)color;

/** 是否隐藏*/
-(void)hiddenNavgation:(BOOL)isHidden;

/**
 创建一个 left DE UIBarButtonItem
 
 @param name imageName name规则 name_normal name_pressed
 @return UIBarButtonItem
 */
- (UIBarButtonItem *)barButtonItemWithImageName:(NSString *)name target:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
