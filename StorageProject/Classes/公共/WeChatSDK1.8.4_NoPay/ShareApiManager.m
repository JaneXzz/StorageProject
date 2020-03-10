//
//  ShareApiManager.m
//  玛雅天气
//
//  Created by 1 on 2019/4/10.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "ShareApiManager.h"
#import "WeiboSDK.h"
#import "AppDelegate.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>

@interface ShareApiManager ()<WBMediaTransferProtocol>

@property (nonatomic, strong) WBMessageObject *messageObject;

@end

@implementation ShareApiManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static ShareApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)sendImageContent:(UIImage *)image{
    _messageObject = [self messageToShare:image];
}

-(void)messageShare
{
    AppDelegate *myDelegate =(AppDelegate*)[[UIApplication sharedApplication] delegate];
 
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = @"https://www.sina.com";
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:_messageObject authInfo:authRequest access_token:myDelegate.wbtoken];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    if (![WeiboSDK sendRequest:request]) {}
}

- (WBMessageObject *)messageToShare:(UIImage *)image
{
    WBMessageObject *message = [WBMessageObject message];
    NSArray *imageArray = [NSArray arrayWithObjects:image,nil];
    WBImageObject *imageObject = [WBImageObject object];

    imageObject.delegate = self;
    [imageObject addImages:imageArray];
    message.imageObject = imageObject;
    
    return message;
}

-(void)wbsdk_TransferDidReceiveObject:(id)object
{
    [self messageShare];
}


-(void)wbsdk_TransferDidFailWithErrorCode:(WBSDKMediaTransferErrorCode)errorCode andError:(NSError*)error{
    NSLog(@"error = %@",error.localizedDescription);
}


-(void)QQShare:(UIImage *)image{
 
    NSData *imgData = UIImagePNGRepresentation(image);
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:imgData
                                               previewImageData:imgData title:@"分享" description:@"分享天气"];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    [QQApiInterface sendReq:req];
}



-(void)qqSendLinkContent:(NSString *)urlString
                   Title:(NSString *)title
             Description:(NSString *)desc{
    
    NSURL *url = [NSURL URLWithString:urlString];
 
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:url title:title description:desc previewImageURL:nil];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    [QQApiInterface sendReq:req];
}

-(void)wbSendLinkContent:(NSString *)urlString
                   Title:(NSString *)title
             Description:(NSString *)desc{
    WBMessageObject *message = [WBMessageObject message];
    message.text = [NSString stringWithFormat:@"%@ 点击链接下载APP %@",desc,urlString];
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
    [WeiboSDK sendRequest:request];
    
}

    


@end
