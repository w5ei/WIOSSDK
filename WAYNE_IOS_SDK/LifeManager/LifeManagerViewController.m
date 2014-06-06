//
//  LifeManagerViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-25.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "LifeManagerViewController.h"

@interface LifeManagerViewController (){
    LifeManager* _lm;
}

@end

@implementation LifeManagerViewController
-(void)dealloc{
    [_lm stop];
}
-(void)lifeManagerTimerIsWorking:(int)lifePlusLeftTimeSeconds{
    NSLog(@">>>>%@",_lm);
}
-(void)lifeManagerLifeChanged:(int)lifeCount{
    NSLog(@"^^^^^^^^^^^^^^^^^^^^^NEW COUNT:%d",lifeCount);
}
-(IBAction)lifePlusAction:(id)sender{
    [_lm lifePlusOne];
}
-(IBAction)lifeMinusAction:(id)sender{
    [_lm lifeMinusOne];
}

#pragma mark- Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _lm = [[LifeManager alloc]init];
    _lm.delegate = self;
    [_lm start];
    NSLog(@">>>>>>>*****%@",_lm);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
