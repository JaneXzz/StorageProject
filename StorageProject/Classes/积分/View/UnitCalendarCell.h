//
//  UnitCalendarCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/26.
//  Copyright © 2020 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, SignInType) {
    SignInTypePast = 0,   //过去
    SignInTypePresent = 1, //现在
    SignInTypeFuture = 2, //未来
    SignInTypeAlready = 3, //已签到
};


@interface UnitCalendarCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *dateNumLabel;

@property (weak, nonatomic) IBOutlet UIView *bgColorView;

@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;

@property (nonatomic, strong) NSString *urlStr;

@property (nonatomic, assign) SignInType currentType;

@property(nonatomic, assign)NSInteger todayIndex;

@end

NS_ASSUME_NONNULL_END
