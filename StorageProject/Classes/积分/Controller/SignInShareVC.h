//
//  SignInShareVC.h
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "BasisViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SignInShareVC : BasisViewController

@property (weak, nonatomic) IBOutlet UILabel *conSignInLabel;

@property (weak, nonatomic) IBOutlet UILabel *totalSignInLabel;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIImageView *headImageView;

@property (weak, nonatomic) IBOutlet UIImageView *QrCodeImageView;

@property (strong, nonatomic) NSDictionary *dic;

@end

NS_ASSUME_NONNULL_END
