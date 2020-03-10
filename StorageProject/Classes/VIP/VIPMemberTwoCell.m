//
//  VIPMemberTwoCell.m
//  豆豆计算器
//
//  Created by 1 on 2019/10/11.
//  Copyright © 2019 Jane. All rights reserved.
//

#import "VIPMemberTwoCell.h"
#import "UIImageView+WebCache.h"
#import "MemberShipCardModel.h"
#import "UIButton+WebCache.h"
#import "LoginPublic.h"
#import "VIPPriceCell.h"


@implementation VIPMemberTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.currentInteger = 0;
    [self makeCollection];
 
}

 

-(void)makeCollection{
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = 0;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.itemSize = CGSizeMake((SCREENWIDTH-30)/3, 170);
    
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"VIPPriceCell" bundle:nil] forCellWithReuseIdentifier:@"VIPPriceCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cardArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"VIPPriceCell";
    MemberShipCardModel *cardModel = self.cardArray[indexPath.row];
    VIPPriceCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
//    [cell.vipImageButton sd_setImageWithURL:[NSURL URLWithString:cardModel.picture] forState:UIControlStateNormal];
//    cell.vipImageView.image = cell.vipImageButton.imageView.image;

    [cell.vipImageButton sd_setImageWithURL:[NSURL URLWithString:cardModel.picture] forState:UIControlStateNormal completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.vipImageView.image = image;
    }];
    
    cell.vipImageView.image = cell.vipImageButton.imageView.image;

    cell.vipcardLabel.text = cardModel.title;
    if (self.currentInteger == indexPath.row) {
        cell.vipcardLabel.layer.borderColor = [UIColor orangeColor].CGColor;
        cell.vipcardLabel.textColor = [UIColor orangeColor];
        cell.vipImageView.hidden = NO;
    }else{
        cell.vipcardLabel.layer.borderColor = [UIColor clearColor].CGColor;
        cell.vipcardLabel.textColor = [UIColor blackColor];
        cell.vipImageView.hidden = YES;
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    VIPPriceCell *cell = (VIPPriceCell *)[collectionView cellForItemAtIndexPath:indexPath];
    MemberShipCardModel *cardModel = self.cardArray[indexPath.row];
    self.currentInteger = indexPath.row;
    double price = [cardModel.price doubleValue]/100;
    NSString *priceStr = [NSString stringWithFormat:@"¥ %.2f 立即开通",price];
    [self.openVIPButton setTitle:priceStr forState:UIControlStateNormal];
    self.value = cardModel.price;
    self.model = cardModel;
    [self.collectionView reloadData];
 
}

-(void)setCardArray:(NSArray *)cardArray{
    _cardArray = cardArray;
    if (_cardArray.count > 0) {
        self.contentView.hidden = NO;
        self.layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0);
        if (self.cardArray.count == 1) {
            self.layout.itemSize = CGSizeMake(SCREENWIDTH, 170);
        }else if(self.cardArray.count == 2){
            self.layout.itemSize = CGSizeMake((SCREENWIDTH-90)/2, 170);
            self.layout.sectionInset = UIEdgeInsetsMake(0, 30, 0, 30);
        }else if(self.cardArray.count == 3){
            self.layout.itemSize = CGSizeMake((SCREENWIDTH-30)/3, 170);
         }else{
            self.layout.itemSize = CGSizeMake((SCREENWIDTH-80)/3, 170);
        }
        double price = [self.model.price doubleValue]/100;
        NSString *priceStr = [NSString stringWithFormat:@"¥ %.2f 立即开通",price];
        [self.openVIPButton setTitle:priceStr forState:UIControlStateNormal];
        self.value = self.model.price;
        
        [self.collectionView reloadData];
    } else{
        self.contentView.hidden = YES;
    }
}


- (IBAction)didClickPay:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(clickPayVIP:)]) {
        [self.delegate clickPayVIP:self.model];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
