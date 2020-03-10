//
//  HeaderCell.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "HeaderCell.h"

@implementation HeaderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (IBAction)didClickImageViewButton:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(changePicture:)]) {
        [self.delegate changePicture:self.imageName];
    }
}

@end
