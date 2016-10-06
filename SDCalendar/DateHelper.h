//
//  DateHelper.h
//  LoanCalendar
//
//  Created by Stark Digital Media Services Pvt Ltd on 23/11/15.
//  Copyright © 2015 Stark Digital Media Services Pvt Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateHelper : NSObject

- (NSCalendar *)calendar;
- (NSDateFormatter *)createDateFormatter;

- (NSDate *)addToDate:(NSDate *)date months:(NSInteger)months;
- (NSDate *)addToDate:(NSDate *)date weeks:(NSInteger)weeks;
- (NSDate *)addToDate:(NSDate *)date days:(NSInteger)days;

-(NSInteger)firstWeekdayOfMonthIndex:(NSDate*)date;
-(NSInteger)lastDayIntegerOfMonth:(NSDate *)date;

// Must be less or equal to 6
- (NSUInteger)numberOfWeeks:(NSDate *)date;

- (NSDate *)firstDayOfMonth:(NSDate *)date;
- (NSDate *)firstWeekDayOfMonth:(NSDate *)date;
- (NSDate *)firstWeekDayOfWeek:(NSDate *)date;

- (BOOL)date:(NSDate *)dateA isTheSameMonthThan:(NSDate *)dateB;
- (BOOL)date:(NSDate *)dateA isTheSameWeekThan:(NSDate *)dateB;
- (BOOL)date:(NSDate *)dateA isTheSameDayThan:(NSDate *)dateB;

- (BOOL)date:(NSDate *)dateA isEqualOrBefore:(NSDate *)dateB;
- (BOOL)date:(NSDate *)dateA isEqualOrAfter:(NSDate *)dateB;
- (BOOL)date:(NSDate *)date isEqualOrAfter:(NSDate *)startDate andEqualOrBefore:(NSDate *)endDate;

@end
