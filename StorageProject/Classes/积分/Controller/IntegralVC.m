//
//  IntegralVC.m
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "IntegralVC.h"
#import "LoginPublic.h"
#import "AccountDetailsVC.h"
#import "RedeemedCashVC.h"

#import "IntegralFirstCell.h"
#import "IntegralTwoCell.h"
#import "IntegralThreeCell.h"
#import "IntegralFourCell.h"
#import "WebPageVC.h"
#import "UserManager.h"
#import "UserModel.h"
#import "UIImageView+WebCache.h"
#import "WebPageVC.h"
#import "FriendsShareVC.h"
#import "CipherManagement.h"
#import "DBServiceIntegral.h"
#import "UIView+Toast.h"
#import "FriendRequestVC.h"
#import "NetworkRequests.h"
#import "LogoutPageVC.h"


@interface IntegralVC ()<IntegralCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSDictionary *dic;
@property (strong, nonatomic) NSArray *memberTasksArray;

@property (nonatomic, assign) BOOL isRefresh;

@end

@implementation IntegralVC


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if (_isRefresh == YES) {
        [self updateData];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self hiddenNavgation:YES];
    self.isRefresh = NO;
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self.tableView registerNib:[IntegralFirstCell nib] forCellReuseIdentifier:[IntegralFirstCell cellReuseIdentifier]];
       
    [self.tableView registerNib:[IntegralTwoCell nib] forCellReuseIdentifier:[IntegralTwoCell cellReuseIdentifier]];
    
    [self.tableView registerNib:[IntegralThreeCell nib] forCellReuseIdentifier:[IntegralThreeCell cellReuseIdentifier]];

    [self.tableView registerNib:[IntegralFourCell nib] forCellReuseIdentifier:[IntegralFourCell cellReuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.view.backgroundColor = RGB0X(0xf7f7f7);
//    //下划线位置
//    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
//    //下划线颜色
//    [self.tableView setSeparatorColor:[UIColor clearColor]];
    [self updateData];

}
#pragma mark ---- 更新数据
-(void)updateData{
    VSWeakSelf(self)
    [self.view makeToastActivity:CSToastPositionCenter];

    [UserManager getSignInData:self.userModel.accessToken completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
        NSDictionary *array = (NSDictionary *)responseObject;
        weakself.userModel.integralModel.totalScore = [[NSString stringWithFormat:@"%@",array[@"totalScore"]] integerValue];
        [[DBServiceIntegral shareInstance] updateIntegralModel:weakself.userModel.integralModel];
        [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
    }];
    [self.view makeToastActivity:CSToastPositionCenter];

   [UserManager getMemberTasks:self.userModel.accessToken appId:KAIDX completionHandler:^(id  _Nullable responseObject) {
       [weakself.view hideToastActivity];

       weakself.memberTasksArray = (NSArray *)responseObject;
       [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];

       NSLog(@"getMemberTasks = %@",errorMessage);
   }];
    
}

 
- (NSArray *)memberTasksArray{
    if (!_memberTasksArray) {
        _memberTasksArray = [NSArray array];
    }
    return _memberTasksArray;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        if (self.memberTasksArray.count > 1) {
            return self.memberTasksArray.count;
        }
        return 1;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        IntegralFirstCell *cell = [tableView dequeueReusableCellWithIdentifier:[IntegralFirstCell cellReuseIdentifier]];
        float totalScore = self.userModel.integralModel.totalScore;
        cell.doudouCoin.text = [NSString stringWithFormat:@"%.f",totalScore];
        cell.numberLabel.text = [NSString stringWithFormat:@"约%.2f元",totalScore/self.userModel.integralModel.scoreUnitsPerYuan];
        cell.accountNameLabel.text = [NSString stringWithFormat:@"我的%@",self.userModel.integralModel.scoreUnitName];
        NSString *headerStr;
        if (self.userModel.integralModel.level == 0) {
            headerStr = [NSString stringWithFormat:@"Integral_level%ld",(long)self.userModel.integralModel.level+1];
        }
        cell.headerImageView.image = [UIImage imageNamed:headerStr];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if(indexPath.section == 1) {
        IntegralTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:[IntegralTwoCell cellReuseIdentifier]];
        if (self.memberTasksArray.count > 0) {
            NSString *tempStr = self.memberTasksArray[0][@"imageUrl"];
            [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:tempStr]];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else{
        if (indexPath.row == 0) {
            IntegralThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:[IntegralThreeCell cellReuseIdentifier]];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }else{
            NSDictionary *tempDic = self.memberTasksArray[indexPath.row];
            IntegralFourCell *cell = [tableView dequeueReusableCellWithIdentifier:[IntegralFourCell cellReuseIdentifier]];
            cell.titleLabel.text = tempDic[@"title"];
            cell.instructionsLabel.text = tempDic[@"content"];
            cell.integralLabel.text = [NSString stringWithFormat:@"+%@",tempDic[@"scoreNum"]];
            BOOL isSign = [tempDic[@"done"] boolValue];
            cell.signInLabel.text = tempDic[@"textBtn"];
            cell.isSign = isSign;
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            if (self.memberTasksArray.count == (indexPath.row+1)) {
                cell.bottomConstraint.constant = 0;
            }else{
                cell.bottomConstraint.constant = -10;
            }
            
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        NSDictionary *tempDic = self.memberTasksArray[0];
        NSString *click = tempDic[@"clickUrl"];
        NSString *str = [NSString stringWithFormat:@"access_token=%@&aidx=%@",self.userModel.accessToken,KAIDX];
        NSDictionary *parameters = [CipherManagement encryption:str];
        NSString *clickUrlStr = [NSString stringWithFormat:@"%@?key=%@&paramd=%@",click,parameters[@"key"],parameters[@"paramd"]];
        self.isRefresh = YES;

        FriendRequestVC *vc = [FriendRequestVC loadViewFromXibOrNot];
        vc.urlStr = clickUrlStr;
        [self.navigationController pushViewController:vc animated:YES];
 
    }
    if (indexPath.section == 2 && indexPath.row != 0) {
        NSDictionary *tempDic = self.memberTasksArray[indexPath.row];
        NSString *click = tempDic[@"clickUrl"];
        NSString *buttonName = tempDic[@"textBtn"];
        NSString *taskId = [NSString stringWithFormat:@"%@",tempDic[@"taskId"]];

        if ([click containsString:@"http"]) {
            WebPageVC *vc = [WebPageVC loadViewFromXibOrNot];
            vc.urlStr = tempDic[@"clickUrl"];
            self.isRefresh = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else if([buttonName isEqualToString:@"分享"]){
            FriendsShareVC *VC = [FriendsShareVC loadViewFromXibOrNot];
            self.isRefresh = YES;
            VC.taskIdStr = taskId;
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGPoint offset = self.tableView.contentOffset;
    if (offset.y <= 0) {
        offset.y = 0;
    }
    self.tableView.contentOffset = offset;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 180;
    }else if(indexPath.section == 1){
        return 90;
    }else if (indexPath.section == 2){
        if (indexPath.row == 0) {
            return 65;
        }
        return 70;
    }
    return 50;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB0X(0xf7f7f7);
    return bgView;
}


- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)redeemedCash{
    RedeemedCashVC *VC = [RedeemedCashVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)accountDetails{
    AccountDetailsVC *VC = [AccountDetailsVC loadViewFromXibOrNot];
    VC.userModel = self.userModel;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark --- 积分规则
- (IBAction)didClickIntegralRules:(id)sender {
    WebPageVC *webPage = [WebPageVC loadViewFromXibOrNot];
    webPage.urlStr = @"http://www.doudoubird.com/ddn/scoreRule.html";
    [self.navigationController pushViewController:webPage animated:YES];
}

@end
