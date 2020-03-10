//
//  IntegralRecordVC.h
//  玛雅天气
//
//  Created by Jane on 2020/3/3.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasisViewController.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntegralRecordVC : BasisViewController

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *constraint;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) UserModel *userModel;

@end

NS_ASSUME_NONNULL_END
