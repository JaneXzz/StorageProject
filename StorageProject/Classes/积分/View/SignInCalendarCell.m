//
//  SignInCalendarCell.m
//  玛雅天气
//
//  Created by Jane on 2020/2/25.
//  Copyright © 2020 Jane. All rights reserved.
//

#import "SignInCalendarCell.h"
#import "UnitCalendarCell.h"
#import "NSDate+Extension.h"
#import "TimeTools.h"
#import "LoginPublic.h"
#import "UIImageView+WebCache.h"


@interface SignInCalendarCell ()

@property(nonatomic, assign) NSInteger itemWidth;
@property(nonatomic, assign) NSInteger itemHeight;


@property(nonatomic, strong) NSString *yearStr;
@property(nonatomic, strong) NSString *monthStr;
@property(nonatomic, strong) NSArray* chineseData;

@property (nonatomic, assign) NSInteger itemNum;
@property (nonatomic, assign) NSInteger firstWeekDay;
@property (nonatomic, assign) NSInteger weekNum;
@property (nonatomic, assign) NSInteger lastMonthNum;
@property (nonatomic, strong) NSString *lastMonth;
@property (nonatomic, strong) NSString *nextMonth;
@property (nonatomic, strong) NSString *lastYear;
@property (nonatomic, strong) NSString *nextYear;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, assign) NSInteger todayIndex;

@property (nonatomic, strong) NSMutableArray *dayArray;

@property (nonatomic, strong) NSMutableArray *imageArray;


@end

@implementation SignInCalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.backgroundColor = [UIColor clearColor];
    [self.collectionView registerNib:
    [UINib nibWithNibName:NSStringFromClass([UnitCalendarCell class]) bundle:[NSBundle bundleForClass:[UnitCalendarCell class]]]
          forCellWithReuseIdentifier:@"cell"];
    
    NSString* todayStr = [TimeTools timestamp:[NSDate date].timeIntervalSince1970 changeToTimeType:@"yyyy-MM"];
    NSArray* todayArray = [self getDataFromDate:[NSDate dateWithTimeIntervalSince1970:[TimeTools getTimestampFromTime:todayStr dateType:@"yyyy-MM"]]];
    self.array = todayArray;
    self.itemNum = [self.array[0] integerValue];
    self.weekNum = [self.array[1] integerValue];
    self.firstWeekDay = [self.array[2] integerValue];
    self.yearStr = self.array[3];
    self.monthStr = self.array[4];
    NSInteger lastyear = [self.yearStr integerValue];
    NSInteger lastMonth = [self.monthStr integerValue]-1;
    NSDate *lastDate = [NSDate stringConversionDate:[NSString stringWithFormat:@"%ld-%ld",lastyear,lastMonth] andDateFormatStr:@"yyyy-MM"];
    self.lastMonthNum = [TimeTools getMonthDayNumFromDate:lastDate];
    
    UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    self.collectionView.collectionViewLayout = flowLayout;

    self.todayIndex = [TimeTools getDayWithDate:[NSDate date]];
    self.todayIndex += ([todayArray[2] integerValue] - 2);
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.weekNum*7;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    CGFloat itemWith = (CGRectGetWidth(self.collectionView.frame)-35)/7.0;
    CGFloat itemHeight = (CGRectGetHeight(self.collectionView.frame))/([self.array[1] integerValue]);
    return CGSizeMake(itemWith,itemHeight);
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UnitCalendarCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.dateNumLabel.hidden = NO;
    if (indexPath.item < self.firstWeekDay-1) {
        cell.hidden = YES;
    }else if(indexPath.item-self.firstWeekDay+2 <= self.itemNum){
        cell.hidden = NO;
        NSInteger dayNum = indexPath.item-self.firstWeekDay+2;
        cell.dateNumLabel.text = [@(dayNum) stringValue];

        if(self.todayIndex > indexPath.item){
            cell.currentType = 0;
        }else if (self.todayIndex < indexPath.item){
            cell.currentType = 2;
        }
        
        if (self.signInArray.count > 0) {
            [self createSignIn:cell indexPath:indexPath.item];
        }
        
        if (self.todayIndex == indexPath.item) {
            cell.currentType = 1;
        }
        
    }else{
        cell.hidden = YES;
    }
    

    return cell;
}


-(void)createSignIn:(UnitCalendarCell *)cell  indexPath:(NSInteger)item{
     
    for (NSDictionary *dic in self.signInArray) {
        BOOL isSigned = [dic[@"signed"] boolValue];
        NSString *tempUrl = dic[@"icon"];
        NSString *timeStr = dic[@"day"];
        NSDate *date = [TimeTools stringConversionDate:timeStr];
        NSInteger selectIndex = [TimeTools getDayWithDate:date];
        selectIndex += [self.array[2] integerValue] -2;
        if (tempUrl.length > 0) {
            [cell.bgImageView sd_setImageWithURL:[NSURL URLWithString:tempUrl]];
            cell.bgColorView.backgroundColor = RGB0X(0xfff8d8);
            cell.dateNumLabel.hidden = YES;
        }
        if (isSigned) {
            if (selectIndex == item) {
                cell.currentType = 3;
            }
        }
    }
    
}

- (void)setSignInArray:(NSArray *)signInArray{
    _signInArray =signInArray;
    if (signInArray.count  > 0) {
        [self.collectionView reloadData];
    }
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}


/**  获取一个月的日历信息 */
-(NSArray*)getDataFromDate:(NSDate*)date{
    NSInteger dayNum = [TimeTools getMonthDayNumFromDate:date];
    NSInteger weekNum = [TimeTools getMonthWeekNumFromDate:date];
    NSInteger weekday = [TimeTools getWeekdayFromDate:date];
    //         总天数，     总周数，   第一天的星期数, 农历信息,当前年,当前月
    return @[@(dayNum), @(weekNum), @(weekday),@(date.year),@(date.month)];
}

#pragma mark --- 签到规则
 
- (IBAction)didClickSignInRules:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(signInRules)]) {
        [self.delegate signInRules];
    }
}

- (NSMutableArray *)dayArray{
    if (!_dayArray) {
        _dayArray = [NSMutableArray array];
    }
    return _dayArray;
}

@end
