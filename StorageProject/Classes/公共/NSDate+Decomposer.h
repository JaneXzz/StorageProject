//
//  ScheduleModel.h
//  Calendar
//
//  Created by Jane on 2018/4/17.
//  Copyright © 2018年 Jane. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Decomposer)


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
 *  将string 转换为NSDate
 */
+(NSDate *)stringConversionDate:(NSString *)dateStr;


+(int)compareOneDay:(NSDate *)currentDay withAnotherDay:(NSDate *)BaseDay;

/**
*  开始到截止的日期
*/
+(NSInteger)daysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;

+(NSString *)strDaysFromDate:(NSDate *)startDate toDate:(NSDate *)endDate;



@end
