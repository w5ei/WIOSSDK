//
//  FruitSlotsViewController.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-8-4.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "FruitSlotsViewController.h"

@interface FruitSlotsViewController (){
    FruitSlotsView *_fsv;
}
@end

@implementation FruitSlotsViewController

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
    _fsv = [[FruitSlotsView alloc]initWithFrame:CGRectMake(0, 80, 320, 320)];
    _fsv.dataSource = self;
    _fsv.delegate = self;
    [self.view addSubview:_fsv];
}
-(IBAction)startAction:(id)sender{
    [_fsv startAnimatingWithTargetIndex:15];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)fruitSlots:(FruitSlotsView *)fruitView arrivalAtCell:(UIView *)cell finished:(BOOL)finished{
    NSLog(@"%@",finished?@"YES":@"NO");
    [UIView animateWithDuration:0.35 animations:^{
        cell.alpha = 0;
    } completion:^(BOOL finished) {
        cell.alpha = 1;
    }];
}
-(UIView *)fruitSlotsViewCellAtIndex:(int)index{
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor redColor];
    label.text = [NSString stringWithFormat:@"%d",index];
    return label;
}
-(int)fruitSlotsViewColumnCount{
    return 5;
}
-(int)fruitSlotsViewRowCount{
    return 5;
}
-(int)fruitSlotsViewScoreValueAtIndex:(int)index{
    return 1;
}
@end
