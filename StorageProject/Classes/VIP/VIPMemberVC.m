//
//  VIPMemberVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "VIPMemberVC.h"
#import "VIPMemberOneCell.h"
#import "VIPMemberTwoCell.h"
#import "DBServiceUser.h"
#import "UserManager.h"

#import "LoginPublic.h"
#import "PayModel.h"

#import "IAPManager.h"
#import "LSProgressHUD.h"
#import "UIView+Toast.h"
#import "NSDictionary+Extension.h"
#import "UIImageView+WebCache.h"

@interface VIPMemberVC ()<VIPMemberPayDelegate,IApRequestResultsDelegate>

@property (weak, nonatomic) IBOutlet UIView *popUpView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;

@property (nonatomic, strong) UserModel *userModel;
@property (nonatomic, strong) MemberShipCardModel *cardModel;

@property (nonatomic, strong) NSMutableArray *cardArrayM;
@property (nonatomic, assign) NSInteger vipDay;
@property (nonatomic, assign) NSInteger card;
@property (nonatomic, strong) NSString *orderId;

@property (nonatomic, assign) BOOL isSuccess;

@end

@implementation VIPMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hiddenNavgation:YES];
    self.view.backgroundColor = [UIColor whiteColor];
    [IAPManager shared].delegate = self;
    [[IAPManager shared] startManager];

    [self.tableView registerNib:[VIPMemberOneCell nib] forCellReuseIdentifier:[VIPMemberOneCell cellReuseIdentifier]];
    [self.tableView registerNib:[VIPMemberTwoCell nib] forCellReuseIdentifier:[VIPMemberTwoCell cellReuseIdentifier]];
    
    self.popUpView.hidden = YES;
    self.popUpView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    [self.view addSubview:self.popUpView];
        
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.alwaysBounceVertical=NO;
    self.tableView.bounces=NO;
    self.tableView.backgroundColor = [UIColor whiteColor];
        
    if (@available(iOS 11.0,*)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }else{
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
   
    [self updateData];
    [self commodityInfomation];
    self.isSuccess = NO;
}

#pragma mark ---- 获得商品
-(void)commodityInfomation{
    if (self.userModel.accessToken) {
        VSWeakSelf(self)
        [self.view makeToastActivity:CSToastPositionCenter];
        [UserManager getCommodityInfomation:self.userModel.accessToken payMode:2 completionHandler:^(id  _Nullable responseObject) {
            [weakself.view hideToastActivity];
            NSArray *array = (NSArray *)responseObject[@"data"];
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                MemberShipCardModel *cardModel = [[MemberShipCardModel alloc] init];
                cardModel.bizType = dic[@"bizType"];
                cardModel.commodityId = dic[@"commodityId"];
                cardModel.commodityType = dic[@"commodityType"];
                cardModel.extras = dic[@"extras"];
                cardModel.orderNum = dic[@"orderNum"];
                cardModel.pclassification = dic[@"pclassification"];
                cardModel.picture = dic[@"picture"];
                cardModel.price = [NSString stringWithFormat:@"%@",dic[@"price"]];
                cardModel.sclassification = dic[@"sclassification"];
                cardModel.title = dic[@"title"];
                cardModel.feedBackUrl = dic[@"extras"][@"feedBackUrl"];
                NSArray *tempArray = dic[@"iPayObjs"];
                if (tempArray) {
                    if (tempArray.count > 0) {
                        cardModel.productId = dic[@"iPayObjs"][0][@"productId"];
                        cardModel.productName = dic[@"iPayObjs"][0][@"productName"];
                        cardModel.iaptype = dic[@"iPayObjs"][0][@"iaptype"];
                    }
                }
                
                [weakself.cardArrayM addObject:cardModel];
            }
            if (weakself.cardArrayM.count > 0) {
                self.cardModel = weakself.cardArrayM[0];
            }
            [weakself.tableView reloadData];
        } failure:^(NSString * _Nullable errorMessage) {
            [weakself.view hideToastActivity];
            if ([errorMessage containsString:@"token非法或者失效"]) {
                [[DBServiceUser shareInstance] clearUserTable];
                [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:nil];
            }else{
                [self.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
            }
         }];
    }else{
    }
}


#pragma mark ---- 点击购买类型

-(void)orderPayment:(PayType)type model:(MemberShipCardModel *)model productId:(NSString *)productId{
    VSWeakSelf(self)
    [LSProgressHUD showToView:self.view message:@"苹果内置"];
    [UserManager getOrderProduct:self.userModel.accessToken commodityId:model.commodityId commodityType:model.commodityType amount:model.price payType:[NSString stringWithFormat:@"%lu",(unsigned long)type] productId:productId  iaptype:model.iaptype completionHandler:^(id  _Nullable responseObject) {
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        weakself.orderId = dic[@"orderId"];
        [[IAPManager shared] requestProductWithId:productId];

    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        [LSProgressHUD hideForView:self.view];
        [self.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
    }];
}

#pragma mark IApRequestResultsDelegate

#pragma mark --- 购买成功
- (void)successfulPurchase:(NSData *)data{
    if (_isSuccess == YES) {
        NSLog(@"购买成功");
         // 获取验证文件url
         NSURL *pathUrl = [[NSBundle mainBundle] appStoreReceiptURL];
         // 文件不存在 return
         if (![[NSFileManager defaultManager] fileExistsAtPath:pathUrl.path]) return;
         // 把文件转成数据流
         NSData *receiptData = [NSData dataWithContentsOfURL:pathUrl];
         // 把数据流转成 ns64 字符串
         NSString *baseString = [receiptData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
         VSWeakSelf(self)
        //苹果验证
        [UserManager getNotifyPay:weakself.userModel.accessToken orderId:self.orderId receipt:[weakself encodeString:baseString]  completionHandler:^(id  _Nullable responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [LSProgressHUD hideForView:weakself.view];
                weakself.popUpView.hidden = NO;
                [weakself.vipImageView sd_setImageWithURL:[NSURL URLWithString:weakself.cardModel.feedBackUrl]];
                [NSTimer scheduledTimerWithTimeInterval:2 target:weakself selector:@selector(updateData) userInfo:nil repeats:NO];
                weakself.refreshBlock();
            });
        } failure:^(NSString * _Nullable errorMessage) {
            [LSProgressHUD hideForView:weakself.view];
            [weakself.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }];
    }
}

- (void)filedWithErrorCode:(NSInteger)errorCode andError:(NSString *)error {
    NSLog(@"当前的 errorCode = %ld",(long)errorCode);
//    [self.view hideToastActivity];
    [LSProgressHUD hideForView:self.view];
    switch (errorCode) {
        case IAP_FILEDCOED_APPLECODE:{
            [self.view makeToast:@"用户禁止应用内付费购买" duration:KDuration position:CSToastPositionCenter];
        }
            break;

        case IAP_FILEDCOED_NORIGHT:{
            [self.view makeToast:@"用户禁止应用内付费购买" duration:KDuration position:CSToastPositionCenter];
        }
            break;

        case IAP_FILEDCOED_EMPTYGOODS:{
            [self.view makeToast:@"无法获取产品信息，请重试" duration:KDuration position:CSToastPositionCenter];
        }
            break;

        case IAP_FILEDCOED_CANNOTGETINFORMATION:{
            [self.view makeToast:@"无法获取产品信息，请重试" duration:KDuration position:CSToastPositionCenter];

        }
            break;

        case IAP_FILEDCOED_BUYFILED:{
            [self.view makeToast:@"购买失败，请重试" duration:KDuration position:CSToastPositionCenter];
        }
            break;

        case IAP_FILEDCOED_USERCANCEL:{
            [self.view makeToast:@"用户取消交易" duration:KDuration position:CSToastPositionCenter];
        }
            break;
            
        default:
            break;
    }
}


-(NSString*)encodeString:(NSString*)unencodedString{
    NSString *encodedString = (NSString *) CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                    (CFStringRef)unencodedString,
                     NULL,
                     (CFStringRef)@"!*'();:@&=+$,/?%#[]",
                     kCFStringEncodingUTF8));
    return encodedString;
}


-(NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

#pragma mark ---- 更新用户信息
-(void)updateData{
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];
    [UserManager getMemberInfo:self.userModel.accessToken appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        NSDictionary *dic = [NSDictionary changeType:responseObject];
        UserModel *model = [[UserModel alloc] initWithDictionary:dic];
        model.accessToken = weakself.userModel.accessToken;
        [[DBService shareInstance] updateUserModel:model];
        weakself.userModel = [[DBServiceUser shareInstance] getUserAlldata];
        [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
        if ([errorMessage containsString:@"token非法或者失效"]) {
            [[DBServiceUser shareInstance] clearUserTable];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isLogin"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [weakself.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"UserNotification" object:nil userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LogonFailure" object:nil userInfo:nil];
        }else{
            [self.view makeToast:errorMessage duration:KDuration position:CSToastPositionCenter];
        }
    }];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 348;
    }else {
        return 310;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.001;
    }
    return 9;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    return bgView;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        VIPMemberOneCell *cell = [tableView dequeueReusableCellWithIdentifier:[VIPMemberOneCell cellReuseIdentifier]];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.model = self.userModel;
        return cell;
    }else{
        VIPMemberTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:[VIPMemberTwoCell cellReuseIdentifier]];
        cell.model = self.cardModel;
        cell.cardArray = self.cardArrayM;
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
}

#pragma mark ----购买 vip
- (void)clickPayVIP:(MemberShipCardModel *)model{
    self.isSuccess = YES;
    self.cardModel = model;
    NSString *productId = model.productId;
    if (productId.length > 0) {
        [self orderPayment:ApplePay model:model productId:productId];
    }else{
        [self.view makeToast:@"productId为空" duration:KDuration position:CSToastPositionCenter];
    }
}
 
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (IBAction)topGesture:(UITapGestureRecognizer *)sender {
    self.popUpView.hidden = YES;
}

-(NSMutableArray *)cardArrayM{
    if (!_cardArrayM) {
        _cardArrayM = [NSMutableArray array];
    }
    return _cardArrayM;
}

-(UserModel *)userModel{
    if (!_userModel) {
         _userModel = [[DBServiceUser shareInstance] getUserAlldata];
    }
     return _userModel;
}

-(BOOL)prefersStatusBarHidden {
    return NO;
}

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (IBAction)didClickGoback:(id)sender {
    if (_isLogin == YES) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc{
     [[IAPManager shared] stopManager];
}

@end
