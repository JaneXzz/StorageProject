//
//  SignInShareVC.m
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "SignInShareVC.h"
#import "DBServiceUser.h"
#import "DBServiceIntegral.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "NSString+Extension.h"

#import "WXApiManager.h"
#import "ShareApiManager.h"
#import "LoginPublic.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"


@interface SignInShareVC ()

@property (strong, nonatomic) UserModel *userModel;

@property (nonatomic, strong) UIImage *shareImage;

@end

@implementation SignInShareVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.userModel = [[DBServiceUser shareInstance] getUserAlldata];    
    
    self.nameLabel.text = [NSString stringWithFormat:@"%@",self.userModel.nickname];
    self.totalSignInLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"totalSignIn"]];
    self.conSignInLabel.text = [NSString stringWithFormat:@"%@",self.dic[@"conSignIn"]];

    
    NSString *imageStr = [NSString isBlankString:self.userModel.iconUrl]?@"account_head_portrait5":self.userModel.iconUrl;
    UIImage *image = [UIImage imageNamed:imageStr];
    if (image) {
        self.headImageView.image = image;
    }else{
        [self.headImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }

    UIImage *qrcodeImg = [self createNonInterpolatedUIImageFormCIImage:[self createQRForString:@"https://apps.apple.com/cn/app/id1453347489"] withSize:100.0f];
    self.QrCodeImageView.image = qrcodeImg;
    
    
    [self creatImage];
}

-(void)creatImage{
    //开启一个图片的上下文
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(SCREENWIDTH, 550), NO, 0);
    //拿到我们开启的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //把需要截屏View的layer渲染到上下文中
    [self.view.layer renderInContext:ctx];
    //从上下文中拿出图片
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    //因为上下文是我们自己开启的，所以用完之后要关闭掉
    UIGraphicsEndImageContext();
    
    self.shareImage = [self ct_imageFromImage:img inRect:CGRectMake(0, 80, SCREENWIDTH, 550-80)];

//    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
//    NSString *picPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@. jpg",@"签到分享"]];
//    NSData *imgData = UIImageJPEGRepresentation(img,0.5);
//    [imgData writeToFile:picPath atomically:YES];
}


-(UIImage *)ct_imageFromImage:(UIImage *)image inRect:(CGRect)rect{
    
    //把像 素rect 转化为 点rect（如无转化则按原图像素取部分图片）
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat x= rect.origin.x*scale,y=rect.origin.y*scale,w=rect.size.width*scale,h=rect.size.height*scale;
    CGRect dianRect = CGRectMake(x, y, w, h);

    //截取部分图片并生成新图片
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, dianRect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return newImage;
}

//朋友圈
- (IBAction)didClickCircleButton:(id)sender {
    BOOL isSuccessful = [[WXApiManager sharedManager] sendImageContent:self.shareImage AtScene:WXSceneTimeline];
    if (!isSuccessful) {
        NSLog(@"朋友圈微信没有安装");
    }
}
//微信
- (IBAction)didClickWeChatButton:(id)sender {
    BOOL isSuccessful = [[WXApiManager sharedManager] sendImageContent:self.shareImage AtScene:WXSceneSession];
    if (!isSuccessful) {
        NSLog(@"朋友圈微信没有安装");
    }
}
//QQ
- (IBAction)didClickQQButton:(id)sender {
    [[ShareApiManager sharedManager] QQShare:self.shareImage];
}
//微博
- (IBAction)didClickWeiboButton:(id)sender {
    [[ShareApiManager sharedManager] sendImageContent:self.shareImage];
 }



/*  ============================================================  */
#pragma mark - InterpolatedUIImage
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    // Cleanup
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

#pragma mark - QRCodeGenerator
- (CIImage *)createQRForString:(NSString *)qrString {
    
    NSData *stringData = [qrString dataUsingEncoding:NSUTF8StringEncoding];
    
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];

    return qrFilter.outputImage;
}

#pragma mark - imageToTransparent
void ProviderReleaseData1 (void *info, const void *data, size_t size){
    free((void*)data);
}
- (UIImage*)imageBlackToTransparent:(UIImage*)image withRed:(CGFloat)red andGreen:(CGFloat)green andBlue:(CGFloat)blue{
    const int imageWidth = image.size.width;
    const int imageHeight = image.size.height;
    size_t      bytesPerRow = imageWidth * 4;
    uint32_t* rgbImageBuf = (uint32_t*)malloc(bytesPerRow * imageHeight);
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(rgbImageBuf, imageWidth, imageHeight, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaNoneSkipLast);
    CGContextDrawImage(context, CGRectMake(0, 0, imageWidth, imageHeight), image.CGImage);
    
    int pixelNum = imageWidth * imageHeight;
    uint32_t* pCurPtr = rgbImageBuf;
    for (int i = 0; i < pixelNum; i++, pCurPtr++){
        if ((*pCurPtr & 0xFFFFFF00) < 0x99999900){
            
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[3] = red; //0~255
            ptr[2] = green;
            ptr[1] = blue;
        }else{
            uint8_t* ptr = (uint8_t*)pCurPtr;
            ptr[0] = 0;
        }
    }
    
    CGDataProviderRef dataProvider = CGDataProviderCreateWithData(NULL, rgbImageBuf, bytesPerRow * imageHeight, ProviderReleaseData1);
    CGImageRef imageRef = CGImageCreate(imageWidth, imageHeight, 8, 32, bytesPerRow, colorSpace, kCGImageAlphaLast | kCGBitmapByteOrder32Little, dataProvider, NULL, true, kCGRenderingIntentDefault);
    CGDataProviderRelease(dataProvider);
    UIImage* resultUIImage = [UIImage imageWithCGImage:imageRef];
    
    CGImageRelease(imageRef);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return resultUIImage;
}



@end
