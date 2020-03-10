//
//  FeedbackVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/7/10.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "FeedbackVC.h"
#import "LoginPublic.h"
#import "PlaceholderTextView.h"
//#import "DataManager.h"
#import "UIView+Toast.h"
#import "TencentOpenAPI/QQApiInterface.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import "UITextField+extension.h"
#import "FeedbackManager.h"


@interface FeedbackVC ()<UITextViewDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet PlaceholderTextView *textView;
@property (weak, nonatomic) IBOutlet UILabel *wordCountLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *communicationGroupButton;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (strong, nonatomic) NSString *qqgroupNum;
@property (strong, nonatomic) NSString *qqkey;


@end

@implementation FeedbackVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hiddenNavgation:YES];
    [self setNeedsStatusBarAppearanceUpdate];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.textField.delegate = self;
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    self.textView.layer.cornerRadius = 4.0f;
    [self.textField placeholderColor:KPlaceholderColor];
    
    self.textField.layer.masksToBounds = YES;
    self.textField.layer.cornerRadius = 5;
    self.textField.layer.borderWidth = 0.5;
    self.textField.layer.borderColor = [UIColor grayColor].CGColor;
    

    self.textView.layer.borderColor = [UIColor grayColor].CGColor;
    self.textView.editable = YES;
    self.textView.delegate = self;
    self.textView.textAlignment = NSTextAlignmentLeft;
    self.textView.layer.borderWidth = 0.5;
    self.textView.textContainerInset =  UIEdgeInsetsMake(10, 5, 10, 5);
    self.textView.placeholderColor = RGB0X(0xA9A9A9);
    self.textView.placeholder = @"亲爱的用户：\n        您好！\n        感谢您对我们团队的支持。如果您在正常使用的过程中，遇到了问题，或者对产品有任何建议，都可以在这里写下来发给我们，我们期待您的反馈。";
    VSWeakSelf(self)
    [FeedbackManager getGroupCompletionHandler:^(id  _Nullable responseObject) {
        weakself.qqgroupNum = responseObject[@"qqgroupNum"];
        weakself.qqkey = responseObject[@"qqkey"];
    } failure:^(NSString * _Nullable errorMessage) {
        NSLog(@"err = %@",errorMessage);
    }];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat rects = -(self.view.frame.size.height-(textField.frame.origin.y + textField.frame.size.height + 216));
    if (rects <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = rects;
            self.view.frame = frame;
        }];
    }
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    return YES;
}

#pragma mark  ---- 点击return回收键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark  -----  textView的字数限制
- (void)textViewDidChange:(UITextView *)textView
{
    [self wordLimit:textView];
}

#pragma mark  -----  超过300字不能输入
-(void)wordLimit:(UITextView *)textView{
    if (textView.text.length < 300) {
        NSLog(@"%ld",textView.text.length);
        self.textView.editable = YES;
    } else{
        self.textView.text = [self.textView.text substringToIndex:300];
    }
    NSInteger wordCount = textView.text.length;
    self.wordCountLabel.text = [NSString stringWithFormat:@"%ld/300",(long)wordCount];
}


#pragma mark --- 提交
- (IBAction)sendFeedBack:(UIButton *)sender {
    if (self.textView.text.length == 0) {
        UIAlertController *alertLength = [UIAlertController alertControllerWithTitle:@"提示" message:@"你输入的信息为空，请重新输入" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *suer = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertLength addAction:suer];
        [self presentViewController:alertLength animated:YES completion:nil];
    }else{
        [self.textView resignFirstResponder];
        [self.textField resignFirstResponder];
        [self.view makeToastActivity:CSToastPositionCenter];
        VSWeakSelf(self)
        [FeedbackManager uploadFeedback:self.textView.text contact:self.textField.text completionHandler:^(id  _Nullable responseObject) {
            weakself.textView.text = @"";
            [weakself textViewDidChange:self.textView];
            [weakself.textView textChanged:nil];
            weakself.textField.text = @"";
            [weakself.view hideToastActivity];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"意见反馈" message:@"亲你的意见我们已经收到，我们会尽快处理" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *album = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }];
             [alertController addAction:album];
             [weakself presentViewController:alertController animated:YES completion:nil];
        } failure:^(NSString * _Nullable errorMessage) {
            [weakself.view hideToastActivity];
            [weakself.view makeToast:errorMessage duration:2 position:CSToastPositionCenter];
        }];
    }
}

#pragma mark --- 在线客服

- (IBAction)onlineCustomerService:(UIButton *)sender {
   
    if ([QQApiInterface isQQInstalled]) {
        NSString *qq=[NSString stringWithFormat:@"mqq://im/chat?chat_type=wpa&uin=%@&version=1&src_type=web",@"3026839624"];
        NSURL *url = [NSURL URLWithString:qq];
        if([[UIApplication sharedApplication] canOpenURL:url]){
             //设备系统为IOS 10.0或者以上的
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:url];
            }
         }
    }else{
        [self.view makeToast:@"没有安装QQ" duration:2 position:CSToastPositionCenter];
    }
}

#pragma mark  --- QQ交流群
- (IBAction)QQCommunicationGroupOf:(UIButton *)sender {
    //判断是否为安装QQ
    if ([QQApiInterface isQQInstalled]) {
        if (self.qqgroupNum.length > 0 && self.qqkey.length > 0) {
             [self joinGroup:self.qqgroupNum key:self.qqkey];
        }else{
            NSString *groupUin = @"696959549";
            NSString *key = @"2a5c4834a0d6eba456cc7bfc21da700e5360b2162e761782ca95de7cfa500305";
            [self joinGroup:groupUin key:key];
        }
    }else{
         [self.view makeToast:@"没有安装QQ" duration:2 position:CSToastPositionCenter];
    }
}

- (BOOL)joinGroup:(NSString *)groupUin key:(NSString *)key{
    NSString *urlStr = [NSString stringWithFormat:@"mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%@&key=%@&card_type=group&source=external", groupUin,key];
    NSURL *url = [NSURL URLWithString:urlStr];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        //设备系统为IOS 10.0或者以上的
        if (@available(iOS 10.0, *)) {
            [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
        } else {
            // Fallback on earlier versions
            [[UIApplication sharedApplication] openURL:url];
        }
        return YES;
    }
    else return NO;
}

#pragma mark  ---- 返回
- (IBAction)didClickGoback:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  ---- 回收键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [_textView resignFirstResponder];
    [_textField resignFirstResponder];
}

#pragma mark  ---- 状态栏
-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}


#pragma mark   ---  检测是否为邮箱
-(BOOL)validateIsValidMailbox:(NSString *)targetString{
    NSString *regex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self regexPatternResultWithRegex:regex TargetString:targetString];
}

#pragma mark   ---  检测是否为QQ
-(BOOL)validateIsValidQQ:(NSString *)targetString{
    NSString *regex = @"^[1-9]*[1-9][0-9]*$";
    return [self regexPatternResultWithRegex:regex TargetString:targetString];
}

#pragma mark   ---  最终正则匹配结果
-(BOOL)regexPatternResultWithRegex:(NSString *)regex TargetString:(NSString *)targetString{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [predicate evaluateWithObject:targetString];
}

@end
