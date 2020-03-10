//
//  ScheduleModel.h
//  Calendar
//
//  Created by Jane on 2018/4/17.
//  Copyright © 2018年 Jane. All rights reserved.
//

#import "NSDate+Decomposer.h"

#define D_MINUTE    60
#define D_HOUR        3600
#define D_DAY        86400
#define D_WEEK        604800
#define D_YEAR        31556926

static const unsigned componentFlags = (NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekOfMonth |  NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal);


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
#pragma mark - Decomposing Dates

- (NSInteger) nearestHour
{
    NSTimeInterval aTimeInterval = [[NSDate date] timeIntervalSinceReferenceDate] + D_MINUTE * 30;
    NSDate *newDate = [NSDate dateWithTimeIntervalSinceReferenceDate:aTimeInterval];
    NSDateComponents *components = [[NSDate currentCalendar] components:NSCalendarUnitHour fromDate:newDate];
    return components.hour;
}

- (NSInteger) hour
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.hour;
}

- (NSInteger) minute
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.minute;
}

- (NSInteger) seconds
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.second;
}

- (NSInteger) day
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.day;
}

- (NSInteger) month
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.month;
}

- (NSInteger) week
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekOfMonth;
}

- (NSInteger) weekday
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekday;
}

- (NSInteger) nthWeekday // e.g. 2nd Tuesday of the month is 2
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.weekdayOrdinal;
}

- (NSInteger) year
{
    NSDateComponents *components = [[NSDate currentCalendar] components:componentFlags fromDate:self];
    return components.year;
}

+ (NSCalendar *) currentCalendar
{
    static NSCalendar *sharedCalendar = nil;
    if (!sharedCalendar)
        sharedCalendar = [NSCalendar autoupdatingCurrentCalendar];
    return sharedCalendar;
}

+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
    [dateFormatter setDateFormat:format];
    NSDate *date = [dateFormatter dateFromString:datestr];
#if ! __has_feature(objc_arc)
    [dateFormatter release];
#endif
    return date;
}
-(NSDate *)dateWithFormatter:(NSString *)formatter {
    NSDateFormatter *fmt = [[NSDateFormatter alloc] init];
    fmt.dateFormat = formatter;
    NSString *selfStr = [fmt stringFromDate:self];
    return [fmt dateFromString:selfStr];
}
- (NSString *)stringWithFormat:(NSString *) format
{
    NSDateFormatter *formatter = [NSDateFormatter new];
    //    formatter.locale = [NSLocale currentLocale]; // Necessary?
    formatter.dateFormat = format;
    return [formatter stringFromDate:self];
}

+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month
{
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setMonth:month];
    NSCalendar *calender = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *mDate = [calender dateByAddingComponents:comps toDate:date options:0];
    return mDate;
}

//date转换为string
+(NSString *)dateConversionString:(NSDate *)date{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString* result=[dateFormatter stringFromDate:date];
    return result;
}

//string转换为date
+(NSDate *)stringConversionDate:(NSString *)dateStr{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    dateFormatter.dateFormat=@"yyyy-MM-dd HH:mm:ss";
    return [dateFormatter dateFromString:dateStr];
}
/**
 *  获得时分秒
 */
+(NSString *)dateWithHHmmss{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    NSTimeZone *tz = [NSTimeZone defaultTimeZone];
    [dateFormatter setTimeZone:tz];
    [dateFormatter setDateFormat:@"HH:mm:ss"];
    NSString* result=[dateFormatter stringFromDate:[NSDate date]];
    return result;
}

//将时间的字符串转换为时间戳
+(NSInteger)getCurrentTimestamp:(NSString *)dateStr{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate stringConversionDate:dateStr];
    NSTimeInterval a = [dat timeIntervalSince1970];
    NSInteger time = round(a);
    return time;
}
//获取系统当前的时间戳
+ (NSInteger)NSIntegerGetCurrentTimestamp{
    //获取系统当前的时间戳
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSInteger time = round(a);
    return time;
}

//将时间戳转换为字符串
+(NSString *)timestampChangesToStandarTime:(uint64_t)timestamp{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:timestamp];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate{

   NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
   NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitDay)
                                                       fromDate:startDate
                                                         toDate:endDate
                                                        options:0];
   NSInteger days = labs([components day]);
   NSInteger hours = labs([components hour]);
   NSInteger minute = labs([components minute]);

    if (days <= 0) {
        if (hours >= 0) {
            if (minute >= 0) {
                return minute;
            }
            return hours;
        }
        return 0;
    }else {
        NSLog(@"%@",[[NSString alloc] initWithFormat:@"%li天%li小时",(long)days,(long)hours]);
        return days;
    }
}

+(NSString *)strDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate{

    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *components = [gregorianCalendar components:(NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitDay)
                                                        fromDate:startDate
                                                          toDate:endDate
                                                         options:0];
    NSInteger days = labs([components day]);
    NSInteger hours = labs([components hour]);
    NSInteger minute = labs([components minute]);
 
    if (days < 1) {
        if (hours < 1) {
            return [[NSString alloc] initWithFormat:@"%li分钟",(long)minute];
        }
        return [[NSString alloc] initWithFormat:@"%li小时",(long)hours];
    }else{
        return [[NSString alloc] initWithFormat:@"%li天",(long)days];
    }
}

+ (NSString *)chindDateFormate:(NSDate *)update{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *destDateString = [dateFormatter stringFromDate:update];
    return destDateString;
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



@end
