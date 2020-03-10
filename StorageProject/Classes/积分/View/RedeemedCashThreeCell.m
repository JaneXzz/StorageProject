//
//  RedeemedCashThreeCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/20.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "RedeemedCashThreeCell.h"
#import "LoginPublic.h"
#import "ConversionCell.h"

@implementation RedeemedCashThreeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.integer = 0;
    [self makeCollection];
}

-(void)setArray:(NSArray *)array{
    _array = array;
    if (array.count > 0) {
        [self.collectionView reloadData];
    }
}

-(void)makeCollection {
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.layout = [[UICollectionViewFlowLayout alloc] init];
    self.layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.layout.minimumLineSpacing = 10;
    self.layout.minimumInteritemSpacing = 0;
    self.layout.itemSize = CGSizeMake((SCREENWIDTH-10-30)/3, 80);
    
    self.collectionView.collectionViewLayout = self.layout;
    self.collectionView.backgroundColor = [UIColor whiteColor];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ConversionCell" bundle:nil] forCellWithReuseIdentifier:@"ConversionCell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.array.count;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    static NSString * CellIdentifier = @"ConversionCell";
    ConversionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    NSDictionary *tempDic = self.array[indexPath.row];
    cell.titleLabel.text = [NSString stringWithFormat:@"%@",tempDic[@"title"]];
    cell.priceLabel.text = [NSString stringWithFormat:@"售价:%@%@",tempDic[@"price"],self.unitStr];
    if (indexPath.row == self.integer) {
        cell.isClick = YES;
    }else{
        cell.isClick = NO;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    self.integer = indexPath.row;
    [self.collectionView reloadData];
}

#pragma mark --- 微信提现
- (IBAction)didClickWeChatWithdrawal:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(weChatWithdrawal:)]) {
        [self.delegate weChatWithdrawal:self.integer];
    }

}

#pragma mark --- 支付宝提现
- (IBAction)didClickAlipayWithdrawal:(id)sender {
    if ([self.delegate respondsToSelector:@selector(alipayWithdrawal:)]) {
        [self.delegate alipayWithdrawal:self.integer];
    }
}

@end
