//
//  AdvancedSettingsVC.m
//  豆豆计算器
//
//  Created by 1 on 2019/11/19.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "AdvancedSettingsVC.h"
#import "InformationCell.h"
#import "LogoutPageVC.h"
#import "LoginPublic.h"

@interface AdvancedSettingsVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation AdvancedSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self hiddenNavgation:YES];
    self.constraint.constant = NAVGATION_STATUS_BAR_HEIGHT;
    [self.tableView registerNib:[InformationCell nib] forCellReuseIdentifier:[InformationCell cellReuseIdentifier]];
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = RGB0X(0xf7f7f7);
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    InformationCell *cell = [tableView dequeueReusableCellWithIdentifier:[InformationCell cellReuseIdentifier]];
    cell.titleLabel.text = @"账号注销";
    cell.describeNameLabel.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 51;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *bgView = [[UIView alloc] init];
    bgView.backgroundColor = RGB0X(0xf7f7f7);
    return bgView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    LogoutPageVC *VC = [LogoutPageVC loadViewFromXibOrNot];
    [self.navigationController pushViewController:VC animated:YES];
}

- (IBAction)didClickGoback:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
 }

 
-(BOOL)prefersStatusBarHidden {
    return NO;
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}

@end
