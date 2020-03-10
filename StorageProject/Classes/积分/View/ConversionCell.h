//
//  ConversionCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ConversionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIImageView *selectImageView;

@property (nonatomic, assign) BOOL isClick;

@end

NS_ASSUME_NONNULL_END
