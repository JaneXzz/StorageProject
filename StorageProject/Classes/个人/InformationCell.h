//
//  InformationCell.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface InformationCell : BasicTableViewCell
//标题
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
//描述
@property (weak, nonatomic) IBOutlet UILabel *describeNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *describeName1Label;


@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


@end

NS_ASSUME_NONNULL_END
