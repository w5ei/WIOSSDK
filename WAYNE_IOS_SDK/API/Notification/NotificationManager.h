//
//  NotificationManager.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-28.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NotificationManager : NSObject
+(id)sharedInstance;
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody fireDelaySecondsSinceNow:(NSTimeInterval)sec;
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody fireDate:(NSDate*)fireDate;
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody fireDateYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day hour:(NSInteger)hour minute:(NSInteger)minute second:(NSInteger)second;
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName fireDelaySecondsSinceNow:(NSTimeInterval)sec;
-(UILocalNotification*)scheduleLocalNotificationWithAlertBody:(NSString*)alertBody soundName:(NSString*)soundName fireDate:(NSDate*)fireDate;
-(void)cancelAllLocalNotifications;
@end
