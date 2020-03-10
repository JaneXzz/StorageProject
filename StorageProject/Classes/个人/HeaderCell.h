//
//  HeaderCell.h
//  豆豆计算器
//
//  Created by 1 on 2019/10/14.
//  Copyright © 2019 Jane. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@protocol HeaderCellDelegate <NSObject>

@required
//点击头像
- (void)changePicture:(NSString *)currentImageName;
@end

@interface HeaderCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIButton *imageViewButton;

@property (strong, nonatomic)NSString *imageName;

@property (nonatomic, weak) id<HeaderCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
