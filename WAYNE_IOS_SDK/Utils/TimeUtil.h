//
//  TimeUtil.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-24.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeUtil : NSObject
+ (unsigned long long)timeIntervalSince1970;
@end
@interface NSDate (WEX)
- (unsigned long long)millisecondSince1970;
- (BOOL)isToday;
- (NSDate *)todayBeginTime;
- (NSDate *)todayEndTime;
@end