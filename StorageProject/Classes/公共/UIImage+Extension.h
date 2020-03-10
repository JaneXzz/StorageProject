//
//  UIImage+Extension.h
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AVURLAsset;

@interface UIImage (Extension)

+ (UIImage *)resizeImage:(NSString *)imageName;
//将颜色转变为图片
+ (UIImage*)createImageWithColor:(UIColor*)color;

+(UIImage*)imageChangeColor:(UIColor*)color;

+(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size;
@end
