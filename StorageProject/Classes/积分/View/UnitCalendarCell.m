//
//  UnitCalendarCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/26.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "UnitCalendarCell.h"
#import "LoginPublic.h"

@implementation UnitCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    self.backgroundColor = BARandomColor;
}

-(void)setCurrentType:(SignInType)currentType{
    self.bgColorView.layer.masksToBounds = YES;
    self.bgColorView.layer.borderWidth = 1;
    self.bgColorView.layer.borderColor = [UIColor clearColor].CGColor;
    switch (currentType) {
        case SignInTypePast:
        {
            self.bgColorView.backgroundColor = RGB0X(0xececec);
            self.dateNumLabel.textColor = RGB0X(0xa7a7a7);
        }
            break;
            
        case SignInTypePresent:
        {
            self.bgColorView.backgroundColor = RGB0X(0x6c4fff);
            self.dateNumLabel.textColor = RGB0X(0xffffff);
        }
            break;
            
        case SignInTypeFuture:
        {
            self.bgColorView.backgroundColor = [UIColor whiteColor];
            self.bgColorView.layer.borderColor = RGB0X(0xefefef).CGColor;
            self.dateNumLabel.textColor = RGB0X(0xa7a7a7);
        }
            break;
            
        case SignInTypeAlready:
        {
            self.bgColorView.backgroundColor = RGB0X(0x6a91fb);
            self.dateNumLabel.textColor = RGB0X(0xffffff);
        }
            break;
            
        default:
            break;
    }
}



@end
