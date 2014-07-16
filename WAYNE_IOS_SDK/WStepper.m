//
//  WStepper.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-7-15.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "WStepper.h"
#define TimeInterval 0.1f
@implementation WStepper{
    BOOL _isMinusTouchDown;
    BOOL _isPlusTouchDown;
    double _holdSeconds;
    NSTimer *_timer;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
-(void)setupView{
    _stepValue = 1;
    _maximumValue = 99;
    CGRect frame = self.bounds;
    frame.size.width/=3;
    
    _minusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _minusButton.frame = frame;
    [self addSubview:_minusButton];
    [_minusButton addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
    [_minusButton addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [_minusButton addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpOutside];
    
    frame.origin.x = frame.size.width;
    _valueLabel = [[UILabel alloc]initWithFrame:frame];
    _valueLabel.textAlignment = NSTextAlignmentCenter;
    _valueLabel.backgroundColor = [UIColor clearColor];
    _valueLabel.font = [UIFont boldSystemFontOfSize:16];
    _valueLabel.textColor = [UIColor colorWithRed:54/255.0f green:52/255.0f blue:53/255.0f alpha:1];
    [self addSubview: _valueLabel];
    
    frame.origin.x = frame.size.width*2;
    _plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _plusButton.frame = frame;
    [self addSubview:_plusButton];
    [_plusButton addTarget:self action:@selector(touchDownAction:) forControlEvents:UIControlEventTouchDown];
    [_plusButton addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpInside];
    [_plusButton addTarget:self action:@selector(touchUpAction:) forControlEvents:UIControlEventTouchUpOutside];
    
    [self updateView];
}
-(void)updateView{
    _valueLabel.text = [NSString stringWithFormat:@"%d",(int)_value];
}
-(void)setValue:(double)value{
    if (value>_maximumValue||value<_minimumValue) {
        return;
    }
    _value = value;
}
-(void)setMaximumValue:(double)maximumValue{
    if (maximumValue>_minimumValue) {
        _maximumValue = maximumValue;
    }
}
-(void)setStepValue:(double)stepValue{
    double maxStepValue = _maximumValue-_minimumValue;
    if (stepValue>maxStepValue) {
        _stepValue = maxStepValue;
    }else{
        _stepValue = stepValue;
    }
}
-(void)timeGoesBy{
    if (_holdSeconds<=3) {
        _holdSeconds+=TimeInterval;
        int holdSec = (int)(_holdSeconds*10);
        if (holdSec%10==0) {
            if (_isPlusTouchDown) {
                self.value += 1;
                [self updateView];
            }
            if (_isMinusTouchDown){
                self.value -= 1;
                [self updateView];
            }
        }
    }else{
        if (_isPlusTouchDown) {
            self.value += 1;
            [self updateView];
        }
        if (_isMinusTouchDown) {
            self.value -= 1;
            [self updateView];
        }
    }
}
-(void)touchDownAction:(UIButton*)sender{
    _holdSeconds = 0;
    if (sender == _minusButton) {
        _isMinusTouchDown = YES;
    }else{
        _isPlusTouchDown = YES;
    }
    if (_timer==nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:TimeInterval target:self selector:@selector(timeGoesBy) userInfo:nil repeats:YES];
    }
}
-(void)touchUpAction:(UIButton*)sender{
    if (_isPlusTouchDown) {
        self.value += 1;
        [self updateView];
    }
    if (_isMinusTouchDown) {
        self.value -= 1;
        [self updateView];
    }
    _isMinusTouchDown = NO;
    _isPlusTouchDown = NO;
    _holdSeconds = 0;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
