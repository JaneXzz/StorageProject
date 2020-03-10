//
//  IntegralFourCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface IntegralFourCell : BasicTableViewCell
//签到按钮

@property (weak, nonatomic) IBOutlet UIView *semicircleView;
@property (weak, nonatomic) IBOutlet UILabel *integralLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *instructionsLabel;

@property (nonatomic, assign) BOOL isSign;

@property (weak, nonatomic) IBOutlet UIImageView *wireframeBgImageView;
@property (weak, nonatomic) IBOutlet UILabel *signInLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstraint;


@end

NS_ASSUME_NONNULL_END
