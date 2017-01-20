//
//  ViewController.m
//  LC_Calender
//
//  Created by 上海雷默广告有限公司 on 2017/1/20.
//  Copyright © 2017年 liCheng. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    NSCalendar *myCalendar;
    NSRange monthRange;
    NSInteger currentDayIndexOfMonth;
    int firstDayIndexOfWeek;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //初始化日历类，并设置日历类的格式是阳历 若想设置中国日历 设置为NSChineseCalendar
    myCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    //设置每周的第一天从星期几开始  设置为 1 是周日，2是周一
    [myCalendar setFirstWeekday:1];
    //设置每个月或者每年的第一周必须包含的最少天数  设置为1 就是第一周至少要有一天
    [myCalendar setMinimumDaysInFirstWeek:1];
    //设置时区，不设置时区获取月的第一天和星期的第一天的时候可能会提前一天。
//    [myCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:0]];
    [myCalendar setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"0"]];
    //计算绘制日历需要的数据，我传入当前日期  输入月份或年不同的日期就能得到不同的日历。
    [self calendarSetDate:[NSDate date]];
    
    
    for (int i = 0; i < 7; i ++)
    {
        UILabel *label = [[UILabel alloc] init];
        label.frame = CGRectMake(50 + 40 * (i%7), 60, 30, 30);
        if (i == 0)
        {
            label.text = @"日";
        }
        else if (i == 1)
        {
            label.text = @"一";
        }
        else if (i == 2)
        {
            label.text = @"二";
        }
        else if (i == 3)
        {
            label.text = @"三";
        }
        else if (i == 4)
        {
            label.text = @"四";
        }
        else if (i == 5)
        {
            label.text = @"五";
        }
        else if (i == 6)
        {
            label.text = @"六";
        }
        label.backgroundColor = [UIColor blueColor];
        label.textColor = [UIColor whiteColor];
        label.textAlignment = 1;
        [self.view addSubview:label];
    }
    

}

-(void)calendarSetDate:(NSDate *)date
{
    /* 日历类里比较重要的三个方法
     -(NSRange)rangeOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
     该方法计算date所在的larger单位  里有几个  smaller单位。
     例如smaller为NSDayCalendarUnit，larger为NSMonthCalendarUnit则返回的nsrange的length为date所在的月里共有多少天。
     
     -(NSUInteger)ordinalityOfUnit:(NSCalendarUnit)smaller inUnit:(NSCalendarUnit)larger forDate:(NSDate *)date;
     该方法计算date 所在的smaller单位 在 date所在的larger单位 里的位置，即第几位。
     例如smaller为NSDayCalendarUnit，larger为NSMonthCalendarUnit则返回的 nsUInteger为date是date所在的月里的第几天。
     
     -(BOOL)rangeOfUnit:(NSCalendarUnit)unit startDate:(NSDate *)datep interval:(NSTimeInterval )tip forDate:(NSDate *)date;
     若datep 和 tip 可计算，则方法返回YES，否则返回NO。当返回YES时，可从datep里得到date所在的 unit单位 的第一天。unit可以为 NSMonthCalendarUnit NSWeekCalendarUnit 等
     
     */
    
    
    //获取date所在的月的天数，即monthRange的length
//    monthRange = [myCalendar rangeOfUnit:NSDayCalendarUnit
//                                  inUnit:NSMonthCalendarUnit
//                                 forDate:date];
    monthRange = [myCalendar rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    
    
    NSLog(@"monthRange:%ld,%ld",monthRange.location,monthRange.length);
    //获取date在其所在的月份里的位置
//    currentDayIndexOfMonth = [myCalendar ordinalityOfUnit:NSDayCalendarUnit
//                                                   inUnit:NSMonthCalendarUnit
//                                                  forDate:date] ;
    currentDayIndexOfMonth = [myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    NSLog(@"currentIndex:%ld",currentDayIndexOfMonth);
    
    NSTimeInterval interval;
    NSDate *firstDayOfMonth;
    //如果firstDayOfMonth和interval可计算，下边这个方法会返回YES，并且由firstDayOfMonth可得到date所在的设置的时间段（NSMonthCalendarUnit）里的第一天
    if ([myCalendar rangeOfUnit:NSCalendarUnitMonth startDate:&firstDayOfMonth interval:&interval forDate:date]) {
        NSLog(@"%@",firstDayOfMonth);
        NSLog(@"%f",interval);
    }
    //获取date所在月的第一天在其所在周的位置，即第几天。
    firstDayIndexOfWeek = [myCalendar ordinalityOfUnit:NSDayCalendarUnit
                                                inUnit:NSWeekCalendarUnit
                                               forDate:firstDayOfMonth];
//    firstDayIndexOfWeek = (int)[myCalendar ordinalityOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitWeekday forDate:firstDayOfMonth];
    NSLog(@"---------------------------%d", firstDayIndexOfWeek);
    //画按钮
    [self drawBtn];
    
}


-(void)drawBtn
{
    //为了方便计算按钮的frame，我的i没从0开始
    for (int i = firstDayIndexOfWeek - 1 ; i < monthRange.length + firstDayIndexOfWeek -1 ; i ++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.frame = CGRectMake(50 + 40 * (i%7), 100 + 40*(i/7), 30, 30);
        btn.tag = i + 2 - firstDayIndexOfWeek;
        btn.backgroundColor = [UIColor redColor];
        [btn setTitle:[NSString stringWithFormat:@"%d",i + 2 - firstDayIndexOfWeek ]
             forState:UIControlStateNormal];
        
        [btn addTarget:self
                action:@selector(nslogBtnTag:)
      forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:btn];
        
    }
}


-(void)nslogBtnTag:(UIButton *)btn
{
    NSLog(@"%ld",btn.tag);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
