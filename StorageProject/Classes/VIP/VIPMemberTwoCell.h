//
//  VIPMemberTwoCell.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "MemberShipCardModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol VIPMemberPayDelegate <NSObject>

@required
//付钱
-(void)clickPayVIP:(MemberShipCardModel *)model;


@end

@interface VIPMemberTwoCell : BasicTableViewCell

@property (weak, nonatomic) NSArray *cardArray;

@property (weak, nonatomic) IBOutlet UIButton *monthCardButton;
@property (weak, nonatomic) IBOutlet UIButton *seasonCardButton;
@property (weak, nonatomic) IBOutlet UIButton *yearCardButton;
@property (weak, nonatomic) IBOutlet UIButton *openVIPButton;

@property (weak, nonatomic) IBOutlet UIImageView *monthImageView;
@property (weak, nonatomic) IBOutlet UIImageView *seasonImageView;
@property (weak, nonatomic) IBOutlet UIImageView *yearImageView;
@property (strong, nonatomic) NSString *value;
@property (nonatomic, weak) id<VIPMemberPayDelegate> delegate;

@property (nonatomic, strong) MemberShipCardModel *model;


@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, assign) NSInteger currentInteger;
@property (nonatomic, strong) UICollectionViewFlowLayout *layout;


@end

NS_ASSUME_NONNULL_END
