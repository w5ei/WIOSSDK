//
//  DateUtil.m
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-6-10.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "DateEx.h"
//@"2019-10-15T09:46:16+08:00"  (19)+08:00
static NSString * const FormatString = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
//@"2019-10-15T09:46:16.000"  (19).xxx
static NSString * const FormatStringPoint = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
//@"2019-10-15T09:46:16"  (19)
static NSString * const FormatString19 = @"yyyy-MM-dd'T'HH:mm:ss";
@implementation NSDate(WEX)

-(NSString*)iso8601Format{
//    NSLog(@"------%@",[NSLocale availableLocaleIdentifiers]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:FormatString];
    NSString *iso8601String = [dateFormatter stringFromDate:self];
    return iso8601String;
}
+(id)dateWithISO8601String:(NSString*)str{
    if (str==nil||str.length<19) {
        return [NSDate date];
    }
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"];
    [dateFormatter setLocale:locale];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    NSString * formatString;
    if (str.length==19) {
        formatString = FormatString19;
    }else{
        NSString *str20 = [str substringWithRange:NSMakeRange(19, 1)];
        if ([str20 isEqual:@"+"]) {
            formatString = FormatString;
        }else{
            formatString = FormatStringPoint;
        }
    }
    [dateFormatter setDateFormat:formatString];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}
-(NSDate*)todayEndTime{
    NSCalendar * calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay                |NSCalendarUnitHour|NSCalendarUnitMinute|NSCalendarUnitSecond fromDate:self];
    [comps setHour:23];
    [comps setMinute:59];
    [comps setSecond:59];
    NSDate *date = [calendar dateFromComponents:comps];
    return date;
}
@end
