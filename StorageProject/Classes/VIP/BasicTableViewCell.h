//
//  BasicTableViewCell.h
//  豆豆计算器
//
//  Created by 1 on 2019/5/22.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BasicTableViewCell : UITableViewCell

+ (nonnull UINib *)nib;
+ (nonnull NSString *)cellReuseIdentifier;

@end

NS_ASSUME_NONNULL_END
