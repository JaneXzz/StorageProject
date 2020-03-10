//
//  SignInCalendarCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN


@protocol SignInCalendarDelegate <NSObject>

@required
//签到规则
- (void)signInRules;

@end

@interface SignInCalendarCell : BasicTableViewCell

@property (nonatomic, weak) id<SignInCalendarDelegate> delegate;

@property (weak, nonatomic) IBOutlet UILabel *conSignInLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalSignInLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalScoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UILabel *signInLabel;

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;


@property (strong, nonatomic) NSArray *signInArray;

@end

NS_ASSUME_NONNULL_END
