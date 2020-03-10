//
//  RedeemedCashFirstCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RedeemedCashCellDelegate <NSObject>

@required
//兑换规则
- (void)clickChangeRules;
//兑换记录
- (void)clickRecord;

@end


@interface RedeemedCashFirstCell : BasicTableViewCell

@property (nonatomic, weak) id<RedeemedCashCellDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (weak, nonatomic) IBOutlet UILabel *withdrawalInstructionsLabel;

@property (weak, nonatomic) IBOutlet UILabel *beanLabel;

@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *extractLabel;

@end

NS_ASSUME_NONNULL_END
