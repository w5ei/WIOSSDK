//
//  LifeManagerViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-25.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "LifeManagerViewController.h"
#import "WStepper.h"
@interface LifeManagerViewController (){
    LifeManager* _lm;
    WLifeManager* _wlm;
    UIPanGestureRecognizer *_panGestureRecognizer;
    
}

@end

@implementation LifeManagerViewController
-(void)dealloc{
    if(_lm)[_lm stop];
    if(_wlm)[_wlm stop];
}


-(void)lifeManager:(LifeManager*)lifeManger timerIsWorking:(int)lifePlusLeftTimeSeconds{
    _label.text = [NSString stringWithFormat:@"%02d:%02d",lifePlusLeftTimeSeconds/60%60,lifePlusLeftTimeSeconds%60];
    _label3.text = [NSString stringWithFormat:@"%02d:%02d:%02d",lifeManger.totalLeftTimeSeconds/60/60%60,lifeManger.totalLeftTimeSeconds/60%60,lifeManger.lifePlusLeftTimeSeconds%60];
}
-(void)lifeManager:(LifeManager*)lifeManger lifeChanged:(int)lifeCount{
    _label2.text = [NSString stringWithFormat:@"%d",lifeCount];
}


-(void)wLifeManager:(WLifeManager*)lifeManger timerIsWorking:(int)lifePlusLeftTimeSeconds{
    long totalLeftTimeSeconds = lifeManger.totalLeftTimeSeconds;
    _label.text = [NSString stringWithFormat:@"%02d:%02d",lifePlusLeftTimeSeconds/60%60,lifePlusLeftTimeSeconds%60];
    _label3.text = [NSString stringWithFormat:@"%02ld:%02ld:%02ld",totalLeftTimeSeconds/60/60%60,totalLeftTimeSeconds/60%60,totalLeftTimeSeconds%60];
}
-(void)wLifeManager:(WLifeManager*)lifeManger lifeChanged:(int)lifeCount{
    _label2.text = [NSString stringWithFormat:@"%d",lifeCount];
}


-(IBAction)lifePlusAction:(id)sender{
    if(_lm)[_lm lifePlusOne];
    if(_wlm)[_wlm lifePlusOne];
}
-(IBAction)lifeMinusAction:(id)sender{
    if(_lm)[_lm lifeMinusOne];
    if(_wlm)[_wlm lifeMinusOne];
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
//    _lm = [[LifeManager alloc]init];
//    _lm.delegate = self;
//    [_lm start];
//    NSLog(@">>>>>>>*****%@",_lm);
    _wlm = [WLifeManager instance];
    _wlm.delegate = self;
    if (_wlm.maxLifeCount==0) {
        [_wlm startWithMaxLifeCount:5 lifePlusTimeInterval:20 lifeCount:5 lifePlueLeftTimeSeconds:0];
    }else{
        [_wlm start];
    }
    
    WStepper *stepper = [[WStepper alloc]initWithFrame:CGRectMake(0, 400, 320, 50)];
    stepper.backgroundColor = [UIColor redColor];
    stepper.minusButton.backgroundColor = [UIColor greenColor];
    stepper.plusButton.backgroundColor = [UIColor blueColor];
    [self.view addSubview:stepper];
    
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(pan:)];
    _panGestureRecognizer.delegate = self;
}
-(void)pan:(UIPanGestureRecognizer* )gr{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
