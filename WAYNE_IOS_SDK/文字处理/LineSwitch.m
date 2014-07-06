//
//  LineSwitch.m
//
//  Created by wayne on 14-5-7.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "LineSwitch.h"
static const float LineMoveDistance = 20;
@implementation LineSwitch{
    UIPanGestureRecognizer* _panGesture;
    float originalY;
    BOOL _isResetting;
    BOOL _isSwitching;
}

- (id)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}
-(void)setupView{
    [[NSBundle mainBundle]loadNibNamed:@"LineSwitch" owner:self options:nil];
    self.frame = _mainView.bounds;
    [self addSubview:_mainView];
    
    _panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(respondToPanGesture:)];
    [_line addGestureRecognizer:_panGesture];
    originalY = -LineMoveDistance;
    [_mainView addSubview:_line];
    [self resetLineAnimated:false];
}
/**
 *还原线的位置
 */
-(void)resetLineAnimated:(BOOL)animated{
    [UIView animateWithDuration:animated?0.35:0.0 animations:^{
        _line.frame = CGRectMake(0, -LineMoveDistance, _line.frame.size.width, _line.frame.size.height);
        _isResetting = YES;
    } completion:^(BOOL finished) {
        _isResetting = NO;
    }];
}
-(void)respondToPanGesture:(UIPanGestureRecognizer *)gestureRecognizer {
    UIView *targetView = [gestureRecognizer view];
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        _isSwitching = NO;
    }
    if (_isResetting||_isSwitching) {
        return;
    }
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan || [gestureRecognizer state] == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gestureRecognizer translationInView:[targetView superview]];
        float maxY = originalY+LineMoveDistance;
        if(translation.y>0&&targetView.frame.origin.y<maxY){
            float newY = [targetView center].y + translation.y-targetView.frame.size.height/2;
            if (newY>maxY) {
                newY = maxY;
            }
            [targetView setCenter:CGPointMake([targetView center].x, newY+targetView.frame.size.height/2)];
            if (targetView.frame.origin.y >= originalY+LineMoveDistance) {
                _isOn = !_isOn;
                _isSwitching = YES;
                if (_delegate&&[_delegate respondsToSelector:@selector(YJSwitchDidSwitch:)]) {
                    [_delegate YJSwitchDidSwitch:self];
                }
                [self resetLineAnimated:YES];
            }
        }
    
        [gestureRecognizer setTranslation:CGPointZero inView:[targetView superview]];
    }
    if ([gestureRecognizer state]==UIGestureRecognizerStateEnded||gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        
        [self resetLineAnimated:YES];
        _isSwitching = NO;
    }
}

@end
