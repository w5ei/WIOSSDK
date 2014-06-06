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
-(void)lifeManager:(LifeManager*)lifeManger timerIsWorking:(int)lifePlusLeftTimeSeconds{
    _label.text = [NSString stringWithFormat:@"%02d:%02d",lifePlusLeftTimeSeconds/60%60,lifePlusLeftTimeSeconds%60];
    _label3.text = [NSString stringWithFormat:@"%02d:%02d:%02d",lifeManger.totalLeftTimeSeconds/60/60%60,lifeManger.totalLeftTimeSeconds/60%60,lifeManger.lifePlusLeftTimeSeconds%60];
}
-(void)lifeManager:(LifeManager*)lifeManger lifeChanged:(int)lifeCount{
    _label2.text = [NSString stringWithFormat:@"%d",lifeCount];
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
