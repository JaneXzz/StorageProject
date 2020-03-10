//
//  RedeemedCashFirstCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "RedeemedCashFirstCell.h"

@implementation RedeemedCashFirstCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bgView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerBottomLeft cornerRadii:CGSizeMake(15, 15)];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bgView.bounds;
    maskLayer.path = maskPath.CGPath;
    self.bgView.layer.mask = maskLayer;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)didClickChangeRules:(id)sender {
    NSLog(@"兑换规则");
    if ([self.delegate respondsToSelector:@selector(clickChangeRules)]) {
        [self.delegate clickChangeRules];
    }
    
}
- (IBAction)didClickRecord:(id)sender {
    NSLog(@"兑换记录");
    if ([self.delegate respondsToSelector:@selector(clickRecord)]) {
        [self.delegate clickRecord];
    }
}

@end
