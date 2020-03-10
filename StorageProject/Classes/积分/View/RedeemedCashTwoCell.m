//
//  RedeemedCashTwoCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "RedeemedCashTwoCell.h"
#import "LoginPublic.h"

@implementation RedeemedCashTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [self gradientView:self.lineView];
    
}

-(void)gradientView:(UIView *)view{
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = view.bounds;
    gradientLayer.colors = @[(__bridge id)RGB0X(0x996df5).CGColor,
                             (__bridge id)RGB0X(0x3e9dff).CGColor];
    gradientLayer.startPoint = (CGPoint){.0};
    gradientLayer.endPoint = (CGPoint){1.0};
    [view.layer addSublayer:gradientLayer];
    
    CALayer *maskLayer = [CALayer layer];
    maskLayer.frame = (CGRect){.0, .0,  gradientLayer.bounds.size.width, gradientLayer.bounds.size.height};
    maskLayer.backgroundColor = [UIColor whiteColor].CGColor;
    gradientLayer.mask = maskLayer;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
