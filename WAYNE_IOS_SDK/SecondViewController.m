//
//  SecondViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-22.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "SecondViewController.h"
#import "AppDelegate.h"
#import "MobClick.h"
@interface SecondViewController ()

@end

@implementation SecondViewController

static NSUInteger i = 0;
-(IBAction)shareToFB:(id)sender{
    i++;
    [MobClick event:@"e_num" label:[NSString stringWithFormat:@"%d",i]];
    return;
    UIImage *shareImage = [UIImage imageNamed:@"Icon.png"];          //分享内嵌图片
    
    //如果得到分享完成回调，需要传递delegate参数
    [UMSocialSnsService presentSnsIconSheetView:self appKey:UmengAppKey shareText:nil shareImage:shareImage shareToSnsNames:[UMSocialSnsPlatformManager sharedInstance].allSnsValuesArray delegate:self];
}
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response{
    if (response.responseCode==UMSResponseCodeCancel) {
        return;
    }
    NSString* title = @"Success";
    NSString* msg = nil;
    if (response.responseCode==UMSResponseCodeSuccess) {
        return;
    }else{
        title = @"Error";
        msg = response.message;
    }
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Second", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
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
    // Dispose of any resources that can be recreated.
}

@end
