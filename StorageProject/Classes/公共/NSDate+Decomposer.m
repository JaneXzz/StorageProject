//
//  ScheduleModel.h
//  Calendar
//
//  Created by Jane on 2018/4/17.
//  Copyright © 2018年 Jane. All rights reserved.
//

#import "NSDate+Decomposer.h"

@implementation NSDate (Decomposer)

#pragma mark Public Method

+ (NSInteger)totalDaysOfMonth:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSRange range = [calendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}

+ (NSInteger)firstWeekDayOfMonth:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 1; // 定位到当月第一天
    NSDate *firstDay = [calendar dateFromComponents:components];
    
    // 默认一周第一天序号为 1 ，而日历中约定为 0 ，故需要减一
    NSInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDay] - 1;
    return firstWeekday;
}

+ (NSInteger)dateDay:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitDay date:date];
    return components.day;
}

+ (NSInteger)dateMonth:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitMonth date:date];
    return components.month;
}

+ (NSInteger)dateYear:(NSDate*)date {
    NSDateComponents *components = [self currentDateComponents:NSCalendarUnitYear date:date];
    return components.year;
}


+ (NSDate *)lastMonthDate:(NSDate*)date {
    NSDateComponents *components = [self nearByDateComponents:date]; // 定位到当月中间日子
    if (components.month == 1) {
        components.month = 12;
        components.year -= 1;
    } else {
        components.month -= 1;
    }
    NSDate *lastDate = [[NSCalendar currentCalendar] dateFromComponents:components];

    return lastDate;
}

+ (NSDate *)nextMonthDate:(NSDate*)date {
    NSDateComponents *components = [self nearByDateComponents:date]; // 定位到当月中间日子
    if (components.month == 12) {
        components.month = 1;
        components.year += 1;
    } else {
        components.month += 1;
    }
    NSDate *nextDate = [[NSCalendar currentCalendar] dateFromComponents:components];
    
    return nextDate;
}


#pragma mark Private Method

+ (NSDateComponents*)currentDateComponents:(NSCalendarUnit)calendarUnit date:(NSDate*)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar components:calendarUnit fromDate:date];
}
+ (NSDateComponents *)nearByDateComponents:(NSDate *)date{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    components.day = 15; // 定位到当月中间日子
    return components;
}
//string转换为date
+(NSDate *)stringConversionDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:dateStr];
}

+(int)compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd-MM-yyyy-HHmmss"];
    NSString *currentDayStr = [dateFormatter stringFromDate:currentDay];
    NSString *BaseDayStr = [dateFormatter stringFromDate:BaseDay];
    NSDate *dateA = [dateFormatter dateFromString:currentDayStr];
    NSDate *dateB = [dateFormatter dateFromString:BaseDayStr];
    NSComparisonResult result = [dateA compare:dateB];
    //    NSLog(@"date1 : %@, date2 : %@", currentDay, BaseDay);
    if (result == NSOrderedDescending) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result == NSOrderedAscending){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
//    int minute = ((int)time)%(3600*24)/3600/60;
    if (days <= 0) {
        if (hours > 0) {
            return hours;
        }
        return 0;
    }else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%i天%i小时",days,hours]);
        return days;
    }
}

+(NSString *)strDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate{
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    // 话说在真机上需要设置区域，才能正确获取本地日期，天朝代码:zh_CN
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    //得到相差秒数
    NSTimeInterval time = [endDate timeIntervalSinceDate:startDate];
    int days = ((int)time)/(3600*24);
    int hours = ((int)time)%(3600*24)/3600;
//    int minute = ((int)time)%(3600*24)/3600/60;
    if (days < 1) {
        return [[NSString alloc] initWithFormat:@"%i小时",hours];
    }else{
        return [[NSString alloc] initWithFormat:@"%i天",days];
    }
 
}


@end
