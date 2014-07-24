//
//  NotificationViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationManager.h"

@interface NotificationViewController ()

@end

@implementation NotificationViewController
-(IBAction)makeOneNotificationAction:(id)sender{
    UIButton* btn = sender;
    NSString* alertBody = [NSString stringWithFormat:@"notification%d",[[UIApplication sharedApplication] scheduledLocalNotifications].count+1];
//    UILocalNotification* noti =
    [[NotificationManager sharedInstance] scheduleLocalNotificationWithAlertBody:alertBody fireDelaySecondsSinceNow:5];
    alertBody = [NSString stringWithFormat:@"notification%d",[[UIApplication sharedApplication] scheduledLocalNotifications].count+1];
    [[NotificationManager sharedInstance] scheduleLocalNotificationWithAlertBody:alertBody fireDelaySecondsSinceNow:10];
    [btn setTitle:alertBody forState:UIControlStateNormal];
}
-(IBAction)cancelAllNotificationAction:(id)sender{
    [[NotificationManager sharedInstance] cancelAllLocalNotifications];
}

#pragma mark- Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
