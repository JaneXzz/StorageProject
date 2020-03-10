//
//  VIPMemberOneCell.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface VIPMemberOneCell : BasicTableViewCell

@property (nonatomic, strong) UserModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *vipDayLabel;
@property (weak, nonatomic) IBOutlet UIImageView *ViphangImageView;

@property (nonatomic, assign) NSInteger vipDay;


@end

NS_ASSUME_NONNULL_END
