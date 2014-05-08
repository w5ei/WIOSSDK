//
//  FacebookViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-19.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "FacebookViewController.h"
#import "FBManager.h"

@interface FacebookViewController (){
    __weak IBOutlet UIView *_ppv;
    __weak IBOutlet UITextView *resultTF;
    FBProfilePictureView* ppv;
}

@end

@implementation FacebookViewController

-(IBAction)loginAction:(id)sender{
    if ([[FBManager sharedInstance] session].isOpen) {
        [[FBManager sharedInstance]logout];
        return;
    }
    [[FBManager sharedInstance] loginWithCompletionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        resultTF.text = [NSString stringWithFormat:@"status:%d\nerror:%@",status,error];
    }];
}
-(IBAction)shareAction:(id)sender{
    [[FBManager sharedInstance]feedWithText:[NSString stringWithFormat:@"%f",[[NSDate date]timeIntervalSinceNow]]andImage:[UIImage imageNamed:@"Icon.png"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"shareAction: %@---%@",result,error);
        resultTF.text = [NSString stringWithFormat:@"result:%@\nerror:%@",result,error];
    }];
//    [[FBManager sharedInstance]feedImage:[UIImage imageNamed:@"Icon.png"] completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
//        
//    }];
}
-(IBAction)requestMeAction:(id)sender{
    [[FBManager sharedInstance]requestForMeWithCompletionHandeler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *me, NSError *error) {
        NSLog(@"Me: %@",me);
        [[FBManager sharedInstance]setMe:me];
        ppv.profileID = me.id;
        resultTF.text = [NSString stringWithFormat:@"result:%@\nerror:%@",me,error];
    }];
}
-(IBAction)requestFriendsAction:(id)sender{
    [[FBManager sharedInstance]requestForFriendsWithCompletionHandeler:^(FBRequestConnection *connection, NSArray<FBGraphUser> *friends, NSError *error) {
        NSLog(@"Friends: %@",friends);
        resultTF.text = [NSString stringWithFormat:@"result:%@\nerror:%@",friends,error];
    }];
}
-(IBAction)requestScoresAction:(id)sender{
    [[FBManager sharedInstance]requestForScoresWithCompletionHandeler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"Scores: %@",result);
        resultTF.text = [NSString stringWithFormat:@"result:%@\nerror:%@",result,error];
    }];
}
static NSUInteger score = 100;
-(IBAction)scorePlusPlusAction:(id)sender{
    [[FBManager sharedInstance]setMyScore:score++ completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        NSLog(@"scorePlusPlusActionResult: %@",result);
        resultTF.text = [NSString stringWithFormat:@"result:%@\nerror:%@",result,error];
    }];
}-(UIAlertView*)alert:(NSString*)title{
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
    return alert;
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
    ppv = [[FBProfilePictureView alloc]initWithFrame:_ppv.bounds];
    [_ppv addSubview:ppv];
    
    
    
    [self.view addSubview:_ppv];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
