//
//  IntegralRecordVC.m
//  玛雅天气
//
//  Created by Jane on 2020/3/3.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "IntegralRecordVC.h"
#import "LoginPublic.h"
#import "AccountDetailsCell.h"
#import "UserManager.h"
#import "TimeTools.h"
#import "UIView+Toast.h"

@interface IntegralRecordVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSMutableDictionary *recordDicM;

@property (weak, nonatomic) IBOutlet UILabel *noDataLabel;

@end

@implementation IntegralRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self hiddenNavgation:YES];
       self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
       self.array = [NSArray array];
       
    [self.tableView registerNib:[AccountDetailsCell nib] forCellReuseIdentifier:[AccountDetailsCell cellReuseIdentifier]];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view makeToastActivity:CSToastPositionCenter];

    VSWeakSelf(self)
    [UserManager getScoreRecords:self.userModel.accessToken month:@"" startDay:@"" endDay:@"" limit:@"" lastId:@"" consumed:@"" scoreType:@"" scoreTypes:@"Exchange,Withdraw" completionHandler:^(id  _Nullable responseObject) {
        [weakself.view hideToastActivity];
       weakself.recordDicM = [weakself conversionTimeArray:responseObject];
        if (weakself.recordDicM.count > 0) {
            weakself.tableView.hidden = NO;
            weakself.noDataLabel.hidden = YES;
        }else{
            weakself.tableView.hidden = YES;
            weakself.noDataLabel.hidden = NO;
        }
       [weakself.tableView reloadData];
    } failure:^(NSString * _Nullable errorMessage) {
        [weakself.view hideToastActivity];
       NSLog(@"errorMessage = %@",errorMessage);
    }];
    
    
}

-(NSMutableDictionary *)conversionTimeArray:(NSArray *)array{
    NSMutableDictionary *tempDic = [NSMutableDictionary dictionary];
    for (NSDictionary *dic in array) {
        NSString *dateStr = [self convertStrToTime:[NSString stringWithFormat:@"%@",dic[@"createTime"]] formatter:@"YYYY-MM"];
        NSLog(@"dateStr = %@",dateStr);
        if (tempDic[dateStr]) {
            [tempDic[dateStr] addObject:dic];
        }else{
            NSMutableArray *tempArray = [NSMutableArray array];
            [tempArray addObject:dic];
            [tempDic setObject:tempArray forKey:dateStr];
        }
    }
    return tempDic;
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
     return self.recordDicM.allKeys.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSString *tempStr = self.recordDicM.allKeys[section];
    NSDictionary *array = self.recordDicM[tempStr];
    return array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *tempStr = self.recordDicM.allKeys[indexPath.section];
    NSDictionary *tempDic = self.recordDicM[tempStr][indexPath.row];
    
    AccountDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:[AccountDetailsCell cellReuseIdentifier]];
    cell.contentLabel.text = tempDic[@"text"];
    NSString *timeStr = [self convertStrToTime:[NSString stringWithFormat:@"%@",tempDic[@"createTime"]] formatter:@"MM-dd HH:mm"];
    cell.createTimeLabel.text = timeStr;
    if ([tempDic[@"status"] intValue] == 4) {
        cell.scoreNumLabel.text = [NSString stringWithFormat:@"-%@",tempDic[@"scoreNum"]] ;
    }else if ([tempDic[@"status"] intValue] == 2){
        cell.scoreNumLabel.text = [NSString stringWithFormat:@"+%@",tempDic[@"scoreNum"]] ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


//时间戳变为格式时间
- (NSString *)convertStrToTime:(NSString *)timeStr formatter:(NSString *)formatterStr {    //如果服务器返回的是13位字符串，需要除以1000，否则显示不正确(13位其实代表的是毫秒，需要除以1000)
    long long time = [timeStr longLongValue]/1000;
    NSDate *date = [[NSDate alloc] initWithTimeIntervalSince1970:time];
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:formatterStr];
    NSString*timeString=[formatter stringFromDate:date];
    return timeString;
}



- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 75;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB0X(0xf7f7f7);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 100, 20)];
    label.textColor = [UIColor grayColor];
    label.text = @"2020-12";
    [bgView addSubview:label];
    
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
     
}

#pragma mark ---- 明细分类

- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}



@end
