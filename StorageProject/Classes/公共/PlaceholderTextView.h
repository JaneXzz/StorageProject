//
//  PlaceholderTextView.h
//  豆豆计算器
//
//  Created by 1 on 2019/7/10.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PlaceholderTextView : UITextView

@property (nonatomic, strong) UILabel * placeHolderLabel;

@property (nonatomic, copy) NSString * placeholder;

@property (nonatomic, strong) UIColor * placeholderColor;

- (void)textChanged:(NSNotification * )notification;

@end

NS_ASSUME_NONNULL_END
