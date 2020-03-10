//
//  VIPMemberOneCell.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "VIPMemberOneCell.h"
#import "UIImageView+WebCache.h"
#import "NSDate+Decomposer.h"
#import "NSString+Extension.h"

@implementation VIPMemberOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(UserModel *)model{
    _model = model;
    
    self.vipDay = [NSDate daysFromDate:[NSDate date] toDate:[NSDate stringConversionDate:model.removeAdDay]];
    NSString *strDay = [NSDate strDaysFromDate:[NSDate date] toDate:[NSDate stringConversionDate:model.removeAdDay]];
    if (self.vipDay > 0) {
        self.vipDayLabel.text = [NSString stringWithFormat:@"会员%@后到期",strDay];
        self.ViphangImageView.hidden = NO;
    }else{
        self.vipDayLabel.text = @"专享无广告纯净版";
        self.ViphangImageView.hidden = YES;
    }
    
    NSString *imageStr = [NSString isBlankString:model.iconUrl] ? @"account_head_portrait5":model.iconUrl;
    UIImage *image = [UIImage imageNamed:imageStr];
    if (image) {
        self.headerImageView.image = image; 
    }else{
        [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:imageStr]];
    }
    self.nameLabel.text = model.nickname.length >0? model.nickname:model.memberName;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
