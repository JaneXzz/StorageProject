//
//  UIImage+Extension.m
//  XZ_WeChat
//
//  Created by 郭现壮 on 16/9/27.
//  Copyright © 2016年 gxz. All rights reserved.
//

#import "UIImage+Extension.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (Extension)



+ (UIImage *)resizeImage:(NSString *)imageName
{
    UIImage *image = [UIImage imageNamed:imageName];
    CGFloat imageW = image.size.width *0.5;
    CGFloat imageH = image.size.height *0.5;
    CGFloat left;
    CGFloat right;
    left = imageW;
    right = imageW;
    return [image resizableImageWithCapInsets:UIEdgeInsetsMake(imageH+5, left, imageH, right) resizingMode:UIImageResizingModeTile];
}

+ (UIImage*)createImageWithColor:(UIColor*)color{
    
    CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context= UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage*theImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
    
}
//+(UIImage *)imageWithColor:(UIColor *)color {
//    
//     CGRect rect = CGRectMake(0.0f,0.0f,1.0f,1.0f);
//     UIGraphicsBeginImageContext(rect.size);
//     CGContextRef context =UIGraphicsGetCurrentContext();
//     CGContextSetFillColorWithColor(context, [color CGColor]);
//     CGContextFillRect(context, rect);
//     UIImage *image =UIGraphicsGetImageFromCurrentImageContext();
//     UIGraphicsEndImageContext();
//    return image;
//}
//绘图
-(UIImage*)imageChangeColor:(UIColor*)color
{
    //获取画布
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    //画笔沾取颜色
    [color setFill];
    
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    //绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeOverlay alpha:1.0f];
    //再绘制一次
    [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    //获取图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


+(UIImage *)scaleToSize:(UIImage *)image size:(CGSize)size {
    UIGraphicsBeginImageContextWithOptions(size, NO, [[UIScreen mainScreen] scale]);
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // 从当前context中创建一个改变大小后的图片
    UIImage * scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    // 返回新的改变大小后的图片
    return scaledImage;
}

@end
