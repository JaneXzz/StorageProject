//
//  IntegralFirstCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/19.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "IntegralFirstCell.h"
#import "LoginPublic.h"

@implementation IntegralFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    UIBezierPath *maskPath = [UIBezierPath
                              bezierPathWithRoundedRect:self.numberView.bounds
                              byRoundingCorners:UIRectCornerTopLeft|UIRectCornerTopRight |UIRectCornerBottomRight
                              cornerRadii:CGSizeMake(13, 13)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.numberView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.numberView.layer.mask = maskLayer;
    self.backgroundColor = [UIColor clearColor];
}

 

- (IBAction)didClickAccountDetails:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(accountDetails)]) {
         [self.delegate accountDetails];
     }
    
}
- (IBAction)didClickRedeemedCash:(id)sender {
    if ([self.delegate respondsToSelector:@selector(redeemedCash)]) {
        [self.delegate redeemedCash];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
