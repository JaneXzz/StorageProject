//
//  IntegralFourCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "IntegralFourCell.h"
#import "LoginPublic.h"

@implementation IntegralFourCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.signButton.layer.masksToBounds = YES;
//    self.signButton.layer.cornerRadius = 15;
//    self.signButton.layer.borderWidth = 1;
//    self.signButton.layer.borderColor = [UIColor blueColor].CGColor;
//    [self.signButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.semicircleView.bounds byRoundingCorners:UIRectCornerTopRight | UIRectCornerBottomRight cornerRadii:CGSizeMake(10, 10)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.semicircleView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.semicircleView.layer.mask = maskLayer;
    self.clipsToBounds = YES;

}


-(void)setIsSign:(BOOL)isSign{
    _isSign = isSign;
    if (isSign == YES) {
        self.wireframeBgImageView.image = [UIImage imageNamed:@"wireframe_select"];
        self.signInLabel.textColor = [UIColor grayColor];
     }else{
         self.wireframeBgImageView.image = [UIImage imageNamed:@"wireframe_normal"];
         self.signInLabel.textColor = RGB0X(0x6c4fff);
     }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
