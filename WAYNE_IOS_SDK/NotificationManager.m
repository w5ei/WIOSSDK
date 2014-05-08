//
//  NotificationManager.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-28.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "NotificationManager.h"

@implementation NotificationManager
-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
+(id)sharedInstance
{
    static dispatch_once_t pred;
    static id sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}
- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(appActivated:)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(appBackgrounded:)
                                                     name: UIApplicationDidEnterBackgroundNotification
                                                   object: nil];
    }
    return self;
}
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody fireDateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    [comps setYear:year];
    [comps setMonth:month];
    [comps setDay:day];
    [comps setHour:hour];
    [comps setMinute:minute];
    [comps setSecond:second];
    NSDate *fireDate = [calendar dateFromComponents:comps];
    if ([[NSDate date]timeIntervalSinceDate:fireDate]<=0) {
        return [self scheduleLocalNotificationWithAlertBody:alertBody soundName:nil fireDate:fireDate];
    }
//    NSLog(@"#$$###################%f",[[NSDate date]timeIntervalSinceDate:fireDate]);
    return nil;
}
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody fireDate:(NSDate*)fireDate{
    return [self scheduleLocalNotificationWithAlertBody:alertBody soundName:nil fireDate:fireDate];
}
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody fireDelaySecondsSinceNow:(NSTimeInterval)sec{
    return [self scheduleLocalNotificationWithAlertBody:alertBody soundName:nil fireDelaySecondsSinceNow:sec];
}
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString *)alertBody soundName:(NSString *)soundName fireDate:(NSDate *)fireDate{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
    if (localNotification == nil)
        return nil;
    localNotification.fireDate = fireDate;
    localNotification.timeZone = [NSTimeZone defaultTimeZone];
    
    localNotification.alertBody = alertBody;
    //    localNotif.alertAction = @"OK";
    //    localNotif.hasAction = NO;
    
    localNotification.soundName = soundName?soundName:UILocalNotificationDefaultSoundName;
    
    localNotification.applicationIconBadgeNumber = 1;
//    [[UIApplication sharedApplication]scheduledLocalNotifications].count+1;
    
    NSDictionary *infoDict = [NSDictionary dictionaryWithObject:alertBody forKey:@"k_tagText"];
    localNotification.userInfo = infoDict;
    
    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
    return localNotification;
}
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName fireDelaySecondsSinceNow:(NSTimeInterval)sec{
    return [self scheduleLocalNotificationWithAlertBody:alertBody soundName:soundName fireDate:[NSDate dateWithTimeIntervalSinceNow:sec]];
}
-(void)cancelAllLocalNotifications{
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication]cancelAllLocalNotifications];
}

- (void)appActivated:(NSNotification *)noti{
    [self cancelAllLocalNotifications];
}
- (void)appBackgrounded:(NSNotification *)noti{
}
@end
