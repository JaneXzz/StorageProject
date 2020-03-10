//
//  SignInRemindCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"
#import "KLSwitch.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignInRemindCell : BasicTableViewCell

@property (weak, nonatomic) IBOutlet KLSwitch *switchButton;

//@property (copy,nonatomic) void(^signInRemind)(BOOL isOpen);


@end

NS_ASSUME_NONNULL_END
