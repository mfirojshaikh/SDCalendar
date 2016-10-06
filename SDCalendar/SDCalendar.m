//  ViewController.m
//  LoanInfo
//
//  Created by Amit Mohol on 11/19/15.
//  Copyright © 2015 Stark Digital. All rights reserved.
#import "SDCalendar.h"
#import "Constant.h"
@interface SDCalendar ()

@end

@implementation SDCalendar

#pragma mark -View delegate methods
@synthesize viewWeekDay;
@synthesize objDateHelper;
@synthesize arrayofEventDate;
@synthesize viewCalendarContainer;

int weekStartDay;
NSInteger  numberOfDaysInMonth;
CGFloat requiredDaybtnHeight = 0.0;
UISwipeGestureRecognizer *swipe_left,*swipe_right;
UIColor *indicatorColor;


- (BOOL)prefersStatusBarHidden
    {
        return YES;
    }
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = YES;
    
    //initiaqlize all required componant
    
    [self initBasicComponant];
    indicatorColor = [UIColor redColor];
    [self initUIComponant];
    [self setBackgroundColorOfMonthView:[UIColor lightGrayColor]];
    //write your won code for create UI below calendar
    
}

- (void) viewDidAppear:(BOOL)animated{

    [self initMonthView:current_date];
    
}

// initialize basic componant

- (void) initBasicComponant
    {
        _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
        current_date=[NSDate date];
        objDateHelper=[[DateHelper alloc] init];
    }

// initialize calnedar UI

- (void)initUIComponant
    {
        _btnDailyView.layer.zPosition=1;
        //get all events from selected month
        [self getEventOfSelectedMonth];
        _viewTitleBar = [[UIView alloc] initWithFrame:CGRectMake( 0, 0, SCREEN_WIDTH, 60 * y_ratio)];
        [self.view addSubview:_viewTitleBar];
        [self.view bringSubviewToFront:_btnDailyView];
    
        monthYear = [[UILabel alloc]init];
        titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, IS_IPAD ? 20 * y_ratio : 17 * y_ratio, 150, IS_IPAD ? 12 * x_ratio : 27)];
        monthYear.frame = CGRectMake(self.view.frame.size.width - 210, IS_IPAD ? 20 * y_ratio : 17 * y_ratio, 200, IS_IPAD ? 12 * x_ratio : 27);
        monthYear.textAlignment = NSTextAlignmentRight;
        titleLabel.textAlignment = NSTextAlignmentLeft;
        titleLabel.text = @"SDCalendar";
        monthYear.font = [UIFont fontWithName:@"Helvetica-Bold" size:IS_IPAD ? 15 * x_ratio : 20 * x_ratio];
        monthYear.textColor = THEME_COLOR;
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:IS_IPAD ? 15 * x_ratio : 20 * x_ratio];
        titleLabel.textColor = THEME_COLOR;
        
        //changing dates format
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat: @"MMMM - yyyy" ];
        NSString *dateText = [[NSString alloc] initWithString:[dateFormatter stringFromDate:current_date]];
        monthYear.text=[NSString stringWithFormat:@"%@",dateText];
    

        //initial y position-Buttons
        viewWeekDay = [[UIView alloc]initWithFrame:CGRectMake(0,-1, SCREEN_WIDTH, 40)];
        viewCalendarContainer = [[UIView alloc]initWithFrame:CGRectMake(0, _viewTitleBar.frame.size.height, SCREEN_WIDTH, viewWeekDay.frame.size.height+viewWeekDay.frame.origin.y +(SCREEN_WIDTH/7)*5)];
    
        [self.viewTitleBar addSubview:monthYear];
        [self.viewTitleBar addSubview:titleLabel];
        
        [self initMonthView:current_date];
        swipe_right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeRight:)];
        swipe_left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
        
        // you can use UISwipeGestureRecognizerDirectionDown for swip_right and UISwipeGestureRecognizerDirectionUp for swip_left
        // instead of right and left
        
        [swipe_right setDirection:(UISwipeGestureRecognizerDirectionRight)];
        [swipe_left setDirection:(UISwipeGestureRecognizerDirectionLeft)];
        [self.viewCalendarContainer addGestureRecognizer:swipe_right];
        [self.viewCalendarContainer addGestureRecognizer:swipe_left];
        viewWeekDay.layer.borderColor = THEME_COLOR.CGColor;
        [viewWeekDay setBackgroundColor:THEME_COLOR];
        viewWeekDay.layer.borderWidth = 0.0f;
        [self.viewCalendarContainer addSubview:viewWeekDay];
        NSMutableArray *arrayDays = IS_IPAD? [[NSMutableArray alloc]initWithObjects:@"Sun",@"Mon",@"Tue",@"Wed",@"Thu",@"Fri",@"Sat", nil]: [[NSMutableArray alloc]initWithObjects:@"S",@"M",@"T",@"W",@"T",@"F",@"S", nil];
    
        float x_position_days = 0;
        for(int i = 0; i < 7; i++)
        {
            UILabel *lblTitle = [[UILabel alloc]init];
            lblTitle.frame = CGRectMake(x_position_days, 5,SCREEN_WIDTH/7, 35);
            lblTitle.text = [arrayDays objectAtIndex:i];
            lblTitle.textColor = [UIColor whiteColor];
            lblTitle.font = [UIFont fontWithName:@"Helvetica-Light" size:20];
            lblTitle.textAlignment = NSTextAlignmentCenter;
            x_position_days += SCREEN_WIDTH / 7;
            [viewWeekDay addSubview:lblTitle];
        }
}

#pragma mark- Guesture handling

// left Gesture Recognizer

- (void) swipeLeft:(UISwipeGestureRecognizer *)recognizer {
    

      if([recognizer direction] == UISwipeGestureRecognizerDirectionUp || [recognizer direction] ==UISwipeGestureRecognizerDirectionLeft){
          // Get todays date to set the monthly subscription expiration date
         [self takeCurlyEffectWithDirection:UIViewAnimationOptionTransitionCurlUp];

          NSDateComponents *dateComponents = [NSDateComponents new];
          dateComponents.month = 1;
          NSDate *currentDatePlus1Month = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:current_date options:0];
          current_date = currentDatePlus1Month;
          [self initMonthView:current_date];
          
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          [dateFormatter setDateFormat: @"MMMM - yyyy"];
          NSString *dateText = [[NSString alloc] initWithString:[dateFormatter stringFromDate:current_date]];
          monthYear.text = [NSString stringWithFormat:@"%@",dateText];
      }
    else{
          //Swipe from left to right
         }
    
 }

// Right GestureRecognizer

- (void)swipeRight:(UISwipeGestureRecognizer *)recognizer {
    
    if([recognizer direction] == UISwipeGestureRecognizerDirectionLeft){
          //Swipe from right to left
      }else if([recognizer direction] == UISwipeGestureRecognizerDirectionDown || [recognizer direction] == UISwipeGestureRecognizerDirectionRight){
          
          [self takeCurlyEffectWithDirection:UIViewAnimationOptionTransitionCurlDown];
          NSDate *currentDate = current_date;
          NSLog(@"Current Date = %@", currentDate);
          
          NSDateComponents *dateComponents = [NSDateComponents new];
          dateComponents.month = -1;
          NSDate *nextMonth = [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:currentDate options:0];
          NSLog(@"Date = %@", nextMonth);
          current_date = nextMonth;
          [self initMonthView:current_date];
          
          NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
          [dateFormatter setDateFormat: @"MMMM - yyyy"];
          monthYear.text = [NSString stringWithFormat:@"%@",[[NSString alloc] initWithString:[dateFormatter stringFromDate:current_date]]];
       }
    
 }
-(void)takeCurlyEffectWithDirection:(UIViewAnimationOptions)option
{
    [UIView transitionWithView:self.viewCalendarContainer
                      duration:.5
                       options:option
                    animations:^(void){
                        self.viewCalendarContainer.alpha = 0;
    }completion:^(BOOL finished){
                        self.viewCalendarContainer.alpha = 1;}];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -Month View Methods
- (void)initMonthView: (NSDate*)currentDate
    {
        //Initilize all background buttons of month view here
        //Get Week Day from date
 
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:currentDate];
    
        NSInteger month = [components month];
        year = [components year];
        [self getEventOfSelectedMonth];
        NSString *strDate = [NSString stringWithFormat:@"01-%ld-%ld",(long)month,(long)year];
        NSDate *startDate = [self convertStringToDate:strDate];
        weekStartDay = [self getWeekDayFromDate:startDate];
        numberOfDaysInMonth = [objDateHelper lastDayIntegerOfMonth:current_date];
        y_position = viewWeekDay.frame.size.height+viewWeekDay.frame.origin.y;
        requiredDaybtnHeight = (viewCalendarContainer.frame.size.height-y_position)/6;
        long numberOfRows = [self getNumberOfWeekForMonth];
    
        float xPosition = 0.0;
        [self removeOldDayButtons];
        for (int i = 0; i < numberOfRows * 7; i++) {

            UIButton *btnDay =[UIButton buttonWithType:UIButtonTypeCustom];
            btnDay.tag=i;
            btnDay.frame=CGRectMake(((SCREEN_WIDTH / 7) * xPosition++), y_position, SCREEN_WIDTH / 7, requiredDaybtnHeight);
            if(( i + 1 ) % 7 == 0)
            {
                y_position += requiredDaybtnHeight;
                xPosition = 0.0;
            }
            [btnDay setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btnDay setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [btnDay.titleLabel setFont:[UIFont fontWithName:@"Helvetica-Light" size:16]];
            [btnDay addTarget:self action:@selector(showselectedDate:) forControlEvents:UIControlEventTouchUpInside];
            btnDay.layer.borderColor = THEME_COLOR.CGColor;
            IS_IPAD ? (btnDay.layer.borderWidth = .5) : (btnDay.layer.borderWidth = .5);
            [viewCalendarContainer addSubview:btnDay];
            [self.view addSubview:viewCalendarContainer];
        }
    [self genrateMonthView:startDate inView:viewCalendarContainer];
}

- (void)removeOldDayButtons
{
    NSArray *arraySubView = [viewCalendarContainer subviews];
    for (id subView in arraySubView) {
        if ([subView isKindOfClass:[UIButton class]] ) {
            UIButton *btnDay = (UIButton*)subView;
            if ( btnDay.tag >= 0 && btnDay.tag < 42 ) {
                [btnDay removeFromSuperview];
            }
        }
    }
}
- (void)setBackgroundColorOfMonthView:(UIColor*)color
{
    [viewCalendarContainer setBackgroundColor:color];
}

- (void)restoreButtonsFrame
{
    NSArray *arraySubView = [viewCalendarContainer subviews];
    for ( id subView in arraySubView ) {
        if ( [subView isKindOfClass: [UIButton class] ] ) {
            UIButton *btnDay = (UIButton*) subView;
            if ( btnDay.tag >= 0 && btnDay.tag < 42 ) {
                if ( btnDay.frame.size.height > requiredDaybtnHeight ) {
                    [btnDay setFrame:CGRectMake( btnDay.frame.origin.x + 5, btnDay.frame.origin.y + 5, btnDay.frame.size.width-10, btnDay.frame.size.height-10 ) ];
                    [btnDay setBackgroundColor:[UIColor clearColor]];
                    CGFloat width = btnDay.frame.size.width;
                    CGFloat height = btnDay.frame.size.height;
                    UIView *viewIndicator = [btnDay viewWithTag:COLOR_TAG];
                    viewIndicator.frame = CGRectMake((width/5)*2, height-(width/5), width/10, width/10);
                    CGPoint point = CGPointMake(btnDay.frame.size.width/2, viewIndicator.frame.origin.y);
                    viewIndicator.center = point;
                    
                }
                [btnDay setSelected:false];
            }
        }
    }
}
- (int)getWeekDayFromDate:(NSDate *)date
{
    [_calendar setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [_calendar setFirstWeekday:1]; //Sunday
    NSDateComponents* comp = [_calendar components:( NSCalendarUnitWeekOfMonth | NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitWeekdayOrdinal)  fromDate:date];
    return (int)[comp weekday];
}


- (NSDate*)convertStringToDate : (NSString *)strDate
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    [dateFormat setDateFormat:@"dd-MM-yyyy"];
    return [dateFormat dateFromString:strDate];
}
-(void)genrateMonthView:(NSDate*)startDate inView:(UIView*)viewCalBg
{
    int weekStartDay = [self getWeekDayFromDate:startDate];

    //Display Calendar
    
    numberOfDaysInMonth = [objDateHelper lastDayIntegerOfMonth:current_date];
    for ( UIView* subview in viewCalBg.subviews )
    {
        if([subview isKindOfClass:[UIButton class]])
        {
            UIButton *btn = (UIButton *)subview;
            if (weekStartDay <= ( btn.tag + 1) && ( btn.tag + 1 ) <= (numberOfDaysInMonth + weekStartDay - 1)) {
                [btn setTitle:[NSString stringWithFormat:@"%ld",( btn.tag + 1 ) - ( weekStartDay - 1 )] forState:UIControlStateNormal];
                [btn setAutoresizesSubviews:YES];
                for (int i = 0; i < arrayofEventDate.count ; i++) {
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM-yyyy"];
                    NSString *strMonth = [[dateFormatter stringFromDate:current_date] componentsSeparatedByString:@"-"][0];
                    NSString *strYear = [[dateFormatter stringFromDate:current_date] componentsSeparatedByString:@"-"][1];

                    BOOL isMonthEqual = [[arrayofEventDate[i] componentsSeparatedByString:@"-"][1] intValue] == [strMonth intValue];
                    BOOL isYearEqual = [strYear intValue] == [[arrayofEventDate[i] componentsSeparatedByString:@"-"][0] intValue];
                    
                    if ( [[arrayofEventDate[i] componentsSeparatedByString:@"-"][2] intValue] == (btn.tag + 1) - (weekStartDay - 1) && isYearEqual && isMonthEqual) {
                        [self setColorViewToTheButton:btn];
                    }
                }
            }
        }
        }
}
-(void)setColorViewToTheButton:(UIButton*)btn
{
    CGFloat width=btn.frame.size.width;
    CGFloat height=btn.frame.size.height;

            UIView *colorView=[[UIView alloc] initWithFrame:CGRectMake((width/5)*2, height-(height/5), width/10, width/10)];
            colorView.tag=COLOR_TAG;
            colorView.layer.cornerRadius=colorView.frame.size.width/2;
            colorView.backgroundColor = indicatorColor;
            CGPoint point = CGPointMake(btn.frame.size.width/2, colorView.frame.origin.y);
            colorView.center = point;
            [btn addSubview:colorView];
    
//            NSString *colorStr =@"redColor";
//            NSString *selectorString = [colorStr stringByAppendingString:@"Color"];
//            SEL selector = NSSelectorFromString(selectorString);
//            UIColor *color = [UIColor blackColor];
//            if ([UIColor respondsToSelector:selector]) {
//                color = [UIColor performSelector:selector];
//            }
//            colorView.backgroundColor=color;
//            colorView.backgroundColor=[SDCalendar colorwithHexString:colorStr alpha:1];
}
+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

- (void)showselectedDate:(UIButton*)sender
    {
    
        if (((sender.tag + 2) - weekStartDay) <= numberOfDaysInMonth && ((sender.tag + 2) - weekStartDay) > 0) {
            [self restoreButtonsFrame];
            [sender setSelected:true];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"MM-yyyy"];
            NSString *strMonth = [[dateFormatter stringFromDate:current_date] componentsSeparatedByString:@"-"][0];
            NSString *strYear = [[dateFormatter stringFromDate:current_date] componentsSeparatedByString:@"-"][1];
            NSString *dateStr = [NSString stringWithFormat:@"%ld-%@-%@",(sender.tag + 2) - weekStartDay,strMonth,strYear];
            NSLog(@"selected date %@",dateStr);

            [self getEventOfSelectedDate:sender];
        
            sender.backgroundColor = THEME_COLOR;
            [viewCalendarContainer bringSubviewToFront:sender];
            [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.3 initialSpringVelocity:0.6 options:0 animations:^(void){
                sender.frame = CGRectMake(sender.frame.origin.x - 5, sender.frame.origin.y - 5,sender.frame.size.width + 10 , sender.frame.size.height + 10);
                CGFloat width = sender.frame.size.width;
                CGFloat height = sender.frame.size.height;
                NSArray *colorArray = [sender subviews];
                for (id colorView in colorArray) {
                    if ([colorView isKindOfClass:[UIView class]]) {
                        UIView *viewColor = (UIView*) colorView;
                        viewColor.frame=CGRectMake((width/5)*2, height-(width/5), width/10, width/10);
                        CGPoint point = CGPointMake(sender.frame.size.width/2, viewColor.frame.origin.y);
                        viewColor.center = point;
            }
        }
    } completion:^(BOOL completion){
    }];
    }
}
- (NSInteger)getNumberOfWeekForMonth
{
    int numberOfRows = 5;
    if ( (numberOfDaysInMonth + weekStartDay - 1) > 35)
        numberOfRows = 6;
    else if ((numberOfDaysInMonth + weekStartDay - 1) > 28)
        numberOfRows = 5;
    else
        numberOfRows = 4;
    return numberOfRows;
}

#pragma mark - get All Events of current Month
- (void)getEventOfSelectedDate : (UIButton*)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-yyyy"];
    NSString *strMonth = [[dateFormatter stringFromDate:current_date] componentsSeparatedByString:@"-"][0];
    NSString *strYear = [[dateFormatter stringFromDate:current_date] componentsSeparatedByString:@"-"][1];
    NSString *dateStr = [NSString stringWithFormat:@"%@-%@-%ld",strYear,strMonth,(sender.tag + 2) - weekStartDay];
    NSLog(@"selected date %@",dateStr);
}

- (void)getEventOfSelectedMonth
{
    // add dates with yyyy-MM-dd format
    
    arrayofEventDate = [[NSMutableArray alloc] initWithObjects:@"2016-07-08",@"2016-08-17", nil];
}
@end
