//
//  DateUtil.m
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-6-10.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "DateEx.h"
//@"2019-10-15T09:46:16+08:00"
static NSString * const FormatString = @"yyyy-MM-dd'T'HH:mm:ssZZZZZ";
//@"2019-10-15T09:46:16.000"
static NSString * const FormatString2 = @"yyyy-MM-dd'T'HH:mm:ss.SSS";
@implementation NSDate(WEX)

-(NSString*)iso8601Format{
//    NSLog(@"------%@",[NSLocale availableLocaleIdentifiers]);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:@"zh_Hans_CN"];
    [dateFormatter setLocale:locale];
    [dateFormatter setDateFormat:FormatString2];
    NSString *iso8601String = [dateFormatter stringFromDate:self];
    return iso8601String;
}
+(id)dateWithISO8601String:(NSString*)str{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    NSLocale *locale = [[NSLocale alloc]initWithLocaleIdentifier:@"zh_Hans_CN"];
    [dateFormatter setLocale:locale];
//    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0]];
    [dateFormatter setDateFormat:FormatString2];
    NSDate *date = [dateFormatter dateFromString:str];
    return date;
}
@end
