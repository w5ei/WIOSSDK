//
//  TimeUtil.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-24.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "TimeUtil.h"

@implementation TimeUtil
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
