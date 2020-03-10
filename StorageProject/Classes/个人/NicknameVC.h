//
//  NicknameVC.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/12.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasisViewController.h"

NS_ASSUME_NONNULL_BEGIN

typedef void (^RefreshCallBlock)(void);

@interface NicknameVC : BasisViewController

@property (nonatomic, strong) RefreshCallBlock refreshBlock;

@end

NS_ASSUME_NONNULL_END
