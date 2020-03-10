//
//  NSString+Extension.h
//  豆豆计算器
//
//  Created by 1 on 2019/7/24.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (Extension)

/**
 取double后两位小数点

 @param doubleValue 输入浮点数
 @return 取小数点后两位
 */
+(NSString *)stringDisposeWithDouble:(double)doubleValue;
+(BOOL)isBlankString:(NSString *)aStr;
+ (NSString *)uuid;
@end

NS_ASSUME_NONNULL_END
