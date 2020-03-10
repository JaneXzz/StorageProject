//
//  FriendsShareVC.h
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasisViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface FriendsShareVC : BasisViewController


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *QrCodeImageView;

@property (nonatomic, strong) NSString *taskIdStr;

@end

NS_ASSUME_NONNULL_END
