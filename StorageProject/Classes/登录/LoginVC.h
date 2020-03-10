//
//  LoginVC.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/8.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasisViewController.h"
#import "UserModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^loginCallBlock)(UserModel *model);


@interface LoginVC : BasisViewController

@property (nonatomic, strong) loginCallBlock myBlock;

@property (nonatomic, assign) BOOL isVip;


@end

NS_ASSUME_NONNULL_END
