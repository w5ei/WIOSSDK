//
//  AnimationUtil.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-31.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "AnimationUtil.h"

@implementation AnimationUtil
-(void)doScaleUpDownAnimationForView:(UIView*)view{
    //如果需要签到做动画
    //否则移除动画
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
        if (YES) {
            [self doScaleUpDownAnimationForView:view];
        }
    }];
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:1.0];
    animation.toValue = [NSNumber numberWithFloat:1.1];
    animation.duration = 0.25;
    animation.autoreverses = YES;
    animation.repeatCount = 2;
    animation.beginTime = CACurrentMediaTime()+1.55;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    [view.layer addAnimation:animation forKey:nil];
    [CATransaction commit];
}
-(void)doSomkeAnimationForView:(UIImageView*)view{
    static NSMutableArray* _deleteAnimationImages;
    if (_deleteAnimationImages==nil) {
        _deleteAnimationImages = [NSMutableArray arrayWithCapacity:8];
        for (NSUInteger i=1; i<=8; i++) {
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"humo_%d.png",i]];
            [_deleteAnimationImages addObject:image];
        }
    }
    view.animationImages = _deleteAnimationImages;
    view.animationRepeatCount = 1;
    [view startAnimating];
}
-(CABasicAnimation *)rotation:(float)duration degree:(float)degree direction:(int)direction repeatCount:(int)repeatCount
{
    CATransform3D rotationTransform  = CATransform3DMakeRotation(degree, 0, 0,direction);
    CABasicAnimation* animation;
    animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    
    animation.toValue = [NSValue valueWithCATransform3D:rotationTransform];
    animation.duration = duration;
    animation.autoreverses = NO;
    animation.cumulative = YES;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    animation.repeatCount = repeatCount;
    animation.delegate = self;
    
    return animation;
}
-(CABasicAnimation *)scaleTo:(float)toValue formValue:(float)formValue duration:(float)duration repeatTimes:(float)repeatTimes
{
    CABasicAnimation *animation=[CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = [NSNumber numberWithFloat:formValue];
    animation.toValue = [NSNumber numberWithFloat:toValue];
    animation.duration = duration;
    animation.autoreverses = NO;
    animation.repeatCount = repeatTimes;
    animation.removedOnCompletion = YES;
    animation.fillMode = kCAFillModeForwards;
    return animation;
}
-(void)doRemoveAnimationForView:(UIView*)view{
    
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
    }];
    
    view.userInteractionEnabled = NO;
    [view.superview bringSubviewToFront:view];
    
    double duration = 0.55;
    
    
    CABasicAnimation* fadeAnim = [CABasicAnimation animationWithKeyPath:@"opacity"];
    fadeAnim.fromValue = [NSNumber numberWithFloat:1.0];
    fadeAnim.toValue = [NSNumber numberWithFloat:0.9];
    fadeAnim.duration = duration;
    [view.layer addAnimation:fadeAnim forKey:@"opacity"];
    
    // Change the actual data value in the layer to the final value.
    view.layer.opacity = 0.0;
    
    
    [view.layer addAnimation:[self rotation:duration/2 degree:M_PI direction:1 repeatCount:2] forKey:@"roateAnim"];
    
    
    [view.layer addAnimation:[self scaleTo:1.20 formValue:1.0 duration:0.15 repeatTimes:1] forKey:@"scaleAnim"];
    
    
    CGMutablePathRef thePath = CGPathCreateMutable();
    
    CGPathMoveToPoint(thePath,NULL,view.center.x,view.center.y);
    
    CGPathAddCurveToPoint(thePath,NULL,
                          view.center.x+30,view.center.y-80,
                          view.center.x+50,view.center.y+30,
                          view.center.x+80,view.center.y+1000);
    
    //    CGPathAddCurveToPoint(thePath,NULL,
    //                          view.center.x,view.center.y+150,
    //                          view.center.x+250,view.center.y-280,
    //                          view.center.x+500,view.center.y);
    
    
    CAKeyframeAnimation * upDownAnimation=[CAKeyframeAnimation animationWithKeyPath:@"position"];
    upDownAnimation.path=thePath;
    upDownAnimation.duration=duration;
    [view.layer addAnimation:upDownAnimation forKey:nil];
    
    CFRelease(thePath);
    
    [CATransaction commit];
}

@end
