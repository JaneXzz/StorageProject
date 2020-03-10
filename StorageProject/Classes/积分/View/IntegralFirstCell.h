//
//  IntegralFirstCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IntegralCellDelegate <NSObject>

@required
//账户明细
- (void)accountDetails;

// 兑换现金
- (void)redeemedCash;

@end


@interface IntegralFirstCell : BasicTableViewCell

@property (nonatomic, weak) id<IntegralCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UILabel *doudouCoin;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *numberView;

@property (weak, nonatomic) IBOutlet UILabel *accountNameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;


@end

NS_ASSUME_NONNULL_END
