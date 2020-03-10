//
//  InformationHeaderCell.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface InformationHeaderCell : BasicTableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@end

NS_ASSUME_NONNULL_END
