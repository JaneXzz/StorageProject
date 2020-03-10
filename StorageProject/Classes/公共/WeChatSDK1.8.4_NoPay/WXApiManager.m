//Tencent is pleased to support the open source community by making WeDemo available.
//Copyright (C) 2016 THL A29 Limited, a Tencent company. All rights reserved.
//Licensed under the MIT License (the "License"); you may not use this file except in compliance with the License. You may obtain a copy of the License at
//http://opensource.org/licenses/MIT
//Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" basis, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the specific language governing permissions and limitations under the License.

#import "WXApiManager.h"
#import "RandomKey.h"

static NSString* const kWXNotInstallErrorTitle = @"您还没有安装微信，不能使用微信分享功能";

@interface WXApiManager ()

@property (nonatomic, strong) NSString *authState;

@end

@implementation WXApiManager

#pragma mark - Life Cycle
+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WXApiManager *instance = nil;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] initInPrivate];
    });
    return instance;
}

- (instancetype)initInPrivate {
    self = [super init];
    if (self) {
        _delegate = nil;
    }
    return self;
}

- (instancetype)init {
    return nil;
}

- (instancetype)copy {
    return nil;
}

#pragma mark - Public Methods
//发送微信验证请求.
- (void)sendAuthRequestWithController:(UIViewController*)viewController
                             delegate:(id<WXAuthDelegate>)delegate {
    SendAuthReq* req = [[SendAuthReq alloc] init];
    req.scope = @"snsapi_userinfo";
    self.authState = req.state = [NSString randomKey];
    self.delegate = delegate;
//    [WXApi sendAuthReq:req viewController:viewController delegate:self];
    [WXApi sendAuthReq:req viewController:viewController delegate:delegate completion:nil];
}
//发送链接到微信
- (BOOL)sendLinkContent:(NSString *)urlString
                  Title:(NSString *)title
            Description:(NSString *)description
                AtScene:(enum WXScene)scene {
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = urlString;

    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = description;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    message.mediaObject = ext;
    message.thumbData = UIImagePNGRepresentation([UIImage imageNamed:@"wxLogoGreen"]);

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
//    BOOL isSuccess = [WXApi sendReq:req];
    __block BOOL isSuccess = NO;
    [WXApi sendReq:req completion:^(BOOL success) {
        isSuccess = success;
    }];
    return isSuccess;
}
//sendFileData
- (BOOL)sendFileData:(NSData *)fileData
       fileExtension:(NSString *)extension
               Title:(NSString *)title
         Description:(NSString *)description
          ThumbImage:(UIImage *)thumbImage
             AtScene:(enum WXScene)scene {
 

    WXFileObject *ext = [WXFileObject object];
    ext.fileExtension = extension;
    ext.fileData = fileData;

    WXMediaMessage *message = [WXMediaMessage message];
    message.mediaObject = ext;
    message.title = title;
    message.description = description;
    [message setThumbImage:thumbImage];

    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.message = message;
    req.bText = NO;
    req.scene = scene;
//    [WXApi sendReq:req]
    __block BOOL isSuccess = NO;
    [WXApi sendReq:req completion:^(BOOL success) {
        isSuccess = success;
    }];
    return isSuccess;
}

- (BOOL)sendImageContent:(UIImage *)image
                 AtScene:(enum WXScene)scene {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        //原图
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        //缩略图
        UIImage *thumbImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];
        
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = imageData; // 原图小于10MB
        
        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = ext;
        [message setThumbImage:thumbImage];// 缩略图 小于32KB
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.scene = scene;
        req.message = message;
        __block BOOL isSuccess = NO;
        [WXApi sendReq:req completion:^(BOOL success) {
            isSuccess = success;
        }];
        return isSuccess;
    }else {
        // 提示用户安装微信
        NSLog(@"请安装微信");
        return NO;
    }
}

- (void)WXSendImage:(UIImage *)image withShareScene:(enum WXScene)scene {
    if ([WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi]) {
        //原图
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        //缩略图
        UIImage *thumbImage = [UIImage imageWithData:UIImageJPEGRepresentation(image, 0.5)];

        WXImageObject *ext = [WXImageObject object];
        ext.imageData = imageData; // 原图小于10MB

        WXMediaMessage *message = [WXMediaMessage message];
        message.mediaObject = ext;
        [message setThumbImage:thumbImage];// 缩略图 小于32KB

        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.scene = scene;
        req.message = message;
        [WXApi sendReq:req completion:^(BOOL success) {}];
    }else {
        // 提示用户安装微信
    }
}

#pragma mark - WXApiDelegate
-(void)onReq:(BaseReq*)req {
    // just leave it here, WeChat will not call our app
}

-(void)onResp:(BaseResp*)resp {    
    if([resp isKindOfClass:[SendAuthResp class]]) {
        SendAuthResp* authResp = (SendAuthResp*)resp;
        /* Prevent Cross Site Request Forgery */
        if (![authResp.state isEqualToString:self.authState]) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)])
                [self.delegate wxAuthDenied];
            return;
        }
        
        switch (resp.errCode) {
            case WXSuccess:
                NSLog(@"RESP:code:%@,state:%@\n", authResp.code, authResp.state);
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthSucceed:)])
                    [self.delegate wxAuthSucceed:authResp.code];
                break;
            case WXErrCodeAuthDeny:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthDenied)])
                    [self.delegate wxAuthDenied];
                break;
            case WXErrCodeUserCancel:
                if (self.delegate && [self.delegate respondsToSelector:@selector(wxAuthCancel)])
                    [self.delegate wxAuthCancel];
            default:
                break;
        }
    }
}


//玛雅天气 小程序
- (BOOL)sendProgramObjectWeather{
    WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
    wxMiniObject.webpageUrl = @"http://www.qq.com";// 兼容低版本的网页链接
    wxMiniObject.userName = @"gh_8f1397873373";// 小程序原始id
    
    wxMiniObject.miniProgramType = WXMiniProgramTypePreview;
    wxMiniObject.hdImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"icon_logo"], 0.5);
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"小程序分享";// 小程序消息title
    message.description = @"desc";
    message.mediaObject = wxMiniObject;
    [message setThumbImage:[UIImage imageNamed:@"icon_logo"]];
    // 小程序消息封面图片，小于128k
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneSession;
     
    __block BOOL isSuccess = NO;
    [WXApi sendReq:req completion:^(BOOL success) {
        isSuccess = success;
    }];
    return isSuccess;
}
//玛雅日历
- (BOOL)sendProgramObjectCalendar{
    WXMiniProgramObject *wxMiniObject = [WXMiniProgramObject object];
    wxMiniObject.webpageUrl = @"http://www.qq.com";// 兼容低版本的网页链接
    wxMiniObject.userName = @"gh_8f1397873373";// 小程序原始id
    
    wxMiniObject.miniProgramType = WXMiniProgramTypePreview;
    wxMiniObject.hdImageData = UIImageJPEGRepresentation([UIImage imageNamed:@"page_cloudyen"], 0.5);
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = @"小程序分享";// 小程序消息title
    message.description = @"desc";
    message.mediaObject = wxMiniObject;
    [message setThumbImage:[UIImage imageNamed:@"page_cloudy"]];
    // 小程序消息封面图片，小于128k
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.message = message;
    req.bText = NO;
    req.scene = WXSceneSession;
    __block BOOL isSuccess = NO;
    [WXApi sendReq:req completion:^(BOOL success) {
        isSuccess = success;
    }];
    return isSuccess;
}


@end
