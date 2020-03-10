//
//  ScheduleModel.h
//  Calendar
//
//  Created by Jane on 2018/4/17.
//  Copyright © 2018年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Decomposer)

@property (readonly) NSInteger nearestHour;
@property (readonly) NSInteger hour;
@property (readonly) NSInteger minute;
@property (readonly) NSInteger seconds;
@property (readonly) NSInteger day;
@property (readonly) NSInteger month;
@property (readonly) NSInteger week;
@property (readonly) NSInteger weekday;
@property (readonly) NSInteger nthWeekday; // e.g. 2nd Tuesday of the month == 2
@property (readonly) NSInteger year;
/**
 *  获得当前 NSDate 对象对应的日子
 */
+ (NSInteger)dateDay:(NSDate*)date;

/**
 *  获得当前 NSDate 对象对应的月份
 */
+ (NSInteger)dateMonth:(NSDate*)date;

/**
 *  获得当前 NSDate 对象对应的年份
 */
+ (NSInteger)dateYear:(NSDate*)date;

/**
 *  获得当前 NSDate 对象的上个月的某一天（此处定为15号）的 NSDate 对象
 */
+ (NSDate *)lastMonthDate:(NSDate*)date;

/**
 *  获得当前 NSDate 对象的下个月的某一天（此处定为15号）的 NSDate 对象
 */
+ (NSDate *)nextMonthDate:(NSDate*)date;

/**
 *  获得当前 NSDate 对象对应的月份的总天数
 */
+ (NSInteger)totalDaysOfMonth:(NSDate*)date;

/**
 *  获得当前 NSDate 对象对应月份当月第一天的所属星期
 */
+ (NSInteger)firstWeekDayOfMonth:(NSDate*)date;

/**
 *  根据当前时间的字符串获取相应的 NSDate
 */
+ (NSDate *)date:(NSString *)datestr WithFormat:(NSString *)format;

/**
 *  根据时间的格式获取相应的时间NSDate
 */
- (NSDate *)dateWithFormatter:(NSString *)formatter;
/**
 *  根据时间的格式获取相应的时间字符串
 */
- (NSString *)stringWithFormat:(NSString *) format;

/**
 *  根据时间获取前一个月或者后一个月的时间 -1为前一个月  1为后一个月
 */
+(NSDate *)getPriousorLaterDateFromDate:(NSDate *)date withMonth:(NSInteger)month;

/**
 *  将string 转换为NSDate
 */
+(NSDate *)stringConversionDate:(NSString *)dateStr;
/**
 *  将NSDate 转换为string
 */
+(NSString *)dateConversionString:(NSDate *)date;

/**
 *  获得时分秒
 */
+(NSString *)dateWithHHmmss;

/**
 *  将时间的字符串转换为时间戳
 */
+(NSInteger)getCurrentTimestamp:(NSString *)dateStr;

/**
 *  将时间戳转换为字符串
 */
+(NSString *)timestampChangesToStandarTime:(uint64_t)timestamp;

/**
 *  获取当前时间的时间戳
 */
+ (NSInteger)NSIntegerGetCurrentTimestamp;

/**
*  开始到截止的日期
*/
+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

+(NSString *)strDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

+ (NSString *)chindDateFormate:(NSDate *)date;

+(int)compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay;


@end
