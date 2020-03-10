//
//  SignInRemindCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "SignInRemindCell.h"
#import "LoginPublic.h"

@implementation SignInRemindCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    
    [self.switchButton setOnTintColor:UIColorFromRGBA(0x6a91fb,1)];
    self.switchButton.contrastColor = UIColorFromRGBA(0xa7a7a7,1);
    BOOL isOpen = [[NSUserDefaults standardUserDefaults] boolForKey:@"Remind"];
    [self.switchButton setOn:isOpen animated:NO];
    
}
 

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
