//
//  RedeemedCashThreeCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@protocol RedeemedCashDelegate <NSObject>

@required

//微信提现
- (void)weChatWithdrawal:(NSInteger)integer;
//支付宝提现
- (void)alipayWithdrawal:(NSInteger)integer;
//交换
//-(void)cashConversionCategory:(NSInteger)integer;

@end


@interface RedeemedCashThreeCell : BasicTableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic, strong) UICollectionViewFlowLayout *layout;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, strong) NSString *unitStr;

@property (nonatomic, weak) id<RedeemedCashDelegate> delegate;


@property (nonatomic, assign) NSInteger integer;

@end

NS_ASSUME_NONNULL_END
