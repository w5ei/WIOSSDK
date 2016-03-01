//
//  TimeUtil.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-24.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil
+(unsigned long long)timeIntervalSince1970{
    return (unsigned long long)([NSDate date].timeIntervalSince1970*1000);
}
//static NSString* const kStartWaitingTime = @"kStartWaitingTime";//等待开始时间
static NSString* const kEndWaitingTime = @"kEndWaitingTime";//等待结束时间
#pragma mark- Methods
//-(NSDate*)startWaitingDate{
//    NSDate* startWaitingDate = [[NSUserDefaults standardUserDefaults]valueForKey:kStartWaitingTime];
//    return startWaitingDate;
//}
//-(void)saveStartWaitingDate{
//    NSDate* startWaitingDate = [NSDate date];
//    [[NSUserDefaults standardUserDefaults]setValue:startWaitingDate forKey:kStartWaitingTime];
//}
-(NSDate*)endWaitingDate{
    NSDate* endWaitingTime = [[NSUserDefaults standardUserDefaults]valueForKey:kEndWaitingTime];
    return endWaitingTime;
}
-(void)saveEndWaitingDate{
    NSDate* endWaitingTime = [NSDate dateWithTimeIntervalSinceNow:60];
    [[NSUserDefaults standardUserDefaults]setValue:endWaitingTime forKey:kEndWaitingTime];
}

-(NSTimeInterval)leftWaitingTime{
    NSTimeInterval left = [[self endWaitingDate]timeIntervalSinceNow];
    if (left<=0) {
        left = 0;
    }
    return left;
}
@end
@implementation NSDate(WEX)
-(unsigned long long)millisecondSince1970{
    return (unsigned long long)(self.timeIntervalSince1970*1000);
}
-(BOOL)isToday{
    NSDate *today = [NSDate date];
    if ([self compare:[today todayBeginTime]]==NSOrderedDescending
        &&[self compare:[today todayEndTime]]==NSOrderedAscending) {
        return YES;
    }
    return NO;
}
-(NSDate *)todayEndTime{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay                |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}
-(NSDate *)todayBeginTime{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay                |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    [comps setHour:0];
    [comps setMinute:0];
    [comps setSecond:0];
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}
@end