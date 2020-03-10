//
//  BasicTableViewCell.m
//  豆豆计算器
//
//  Created by 1 on 2019/5/22.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "BasicTableViewCell.h"

@implementation BasicTableViewCell

+ (UINib *)nib
{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle bundleForClass:[self class]]];
}

+ (NSString *)cellReuseIdentifier
{
    return NSStringFromClass([self class]);
}

@end
