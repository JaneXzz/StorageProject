//
//  VIPPriceCell.m
//  豆豆计算器
//
//  Created by 1 on 2020/1/9.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "VIPPriceCell.h"
#import "LoginPublic.h"

@implementation VIPPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.vipImageView.layer.masksToBounds = YES;
    self.vipImageView.layer.cornerRadius = 5;
    self.vipImageView.layer.borderWidth = 1;
    self.vipImageView.layer.borderColor = RGB0X(0xd9af68).CGColor;
    self.vipImageButton.layer.masksToBounds = YES;
    self.vipImageButton.layer.cornerRadius = 5;
    self.vipImageButton.layer.borderWidth = 1;
    self.vipImageButton.layer.borderColor = RGB0X(0xd8d8d8).CGColor;
    
    
    
}



@end
