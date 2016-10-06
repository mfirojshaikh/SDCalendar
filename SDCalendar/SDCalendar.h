//
//  ViewController.h
//  LoanInfo
//
//  Created by Amit Mohol on 11/19/15.
//  Copyright © 2015 Stark Digital. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DateHelper.h"

@interface SDCalendar : UIViewController
{
    int y_position,x_position;
    NSInteger year;
    NSDate *current_date;
    UILabel *monthYear,*titleLabel;
}
@property (strong, nonatomic) DateHelper *objDateHelper;
@property (strong, nonatomic) NSCalendar *calendar;
@property (weak, nonatomic) IBOutlet UIButton *btnDailyView;
@property (strong, nonatomic) NSMutableArray *arrayofEventDate;

@property (strong, nonatomic) UIView *viewTitleBar;
@property (strong,nonatomic) UIView * viewWeekDay;
@property (strong, nonatomic) UIView *viewCalendarContainer;

- (int)getWeekDayFromDate : (NSDate *)date;
@end

