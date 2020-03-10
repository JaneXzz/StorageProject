//
//  AccountDetailsCell.h
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccountDetailsCell : BasicTableViewCell
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *createTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *scoreNumLabel;

@end

NS_ASSUME_NONNULL_END
