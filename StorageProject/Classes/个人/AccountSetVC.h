//
//  AccountSetVC.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasisViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountSetVC : BasisViewController
typedef void (^accountSetCallBlock)(void);
@property (nonatomic, strong) accountSetCallBlock block;
@end

NS_ASSUME_NONNULL_END
