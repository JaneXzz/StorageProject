//
//  ConversionCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "ConversionCell.h"

@implementation ConversionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIsClick:(BOOL)isClick{
    _isClick = isClick;
    if (isClick == YES) {
        self.selectImageView.image = [UIImage imageNamed:@"withdrawal_amount_select"];
    }else{
        self.selectImageView.image = [UIImage imageNamed:@"withdrawal_amount_normal"];
    }
}
@end
