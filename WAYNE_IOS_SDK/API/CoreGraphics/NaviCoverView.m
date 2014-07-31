//
//  NaviCoverView.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-7-22.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "NaviCoverView.h"

@implementation NaviCoverView{
    CGColorSpaceRef		_colorSpace;
	CGRect				_clearRect;
    CGPoint             _position;
    UIImageView *_tagIV;
}
- (void)dealloc {
	CGColorSpaceRelease(_colorSpace);
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _colorSpace = CGColorSpaceCreateDeviceRGB();
        [self test];
    }
    return self;
}
-(void)test{
    _clearRect = CGRectMake(150, 300,60, 60);
    CGPoint pos = _clearRect.origin;
//    CGPoint center = CGPointMake(pos.x+_clearSize.width/2, pos.y+_clearSize.height/2);
    _tagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detalle"]];
    
    _tagIV.center = CGPointMake(pos.x + _clearRect.size.width+_tagIV.frame.size.width/2, pos.y+_clearRect.size.height/2);
    
    [UIView animateWithDuration:0.65 delay:0.15 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
        _tagIV.transform = CGAffineTransformTranslate(_tagIV.transform, 15, 0);
        //                _tagIV.transform = CGAffineTransformScale(_tagIV.transform, 0.9, 0.9);
        _tagIV.transform = CGAffineTransformMakeScale(0.95, 0.95);
    } completion:^(BOOL finished) {
        
    }];
    [self addSubview:_tagIV];
}
-(void)setCenterForHandImageView:(CGPoint)pos upsideDown:(BOOL)upsideDown{
    if (_tagIV) {
        [_tagIV.layer removeAllAnimations];
        [_tagIV removeFromSuperview];
        _tagIV = nil;
    }
    if (_tagIV==nil) {
        _tagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detalle"]];
        _tagIV.contentMode = UIViewContentModeCenter;
        [self addSubview:_tagIV];
        if (upsideDown) {
            _tagIV.transform = CGAffineTransformRotate(_tagIV.transform, M_PI);
        }
        CGAffineTransform transform = CGAffineTransformScale(_tagIV.transform, 0.95, 0.95);
        [UIView animateWithDuration:0.65 delay:0.15 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
            
            _tagIV.transform = CGAffineTransformMake(transform.a,transform.b,transform.c,transform.d, transform.tx, transform.ty+(upsideDown?5:-5));
            
        } completion:^(BOOL finished) {}];
    }
    _tagIV.center = pos;
}
//clear a rect ,allways for clear all the view
// if for clear like rubber use: CGContextSetBlendMode(ctx,kCGBlendModeClear);before drawing
+(void)clearRect:(CGRect)rect context:(CGContextRef)ctx{
    CGContextClearRect(ctx,rect);
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    //set fill color
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    //fill the whole rect
    CGContextFillRect(ctx, rect);
    //draw fill rect
    CGContextFillRect(ctx, CGRectMake(5, 5, rect.size.width-10, rect.size.height-10));
    
    //set stroke color
    CGContextSetStrokeColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    //draw stroke rect
    CGContextStrokeRectWithWidth(ctx, CGRectMake(90, 20, 50, 50), 10);
    
    //clear rect
    CGContextClearRect(ctx,CGRectMake(20, 20, 50, 50));
    
    //draw fill ellipse
    CGContextFillEllipseInRect(ctx, CGRectMake(20, 120, 50, 50));
    
    //using clear blend mode
    CGContextSetBlendMode(ctx,kCGBlendModeClear);
    
    //draw fill ellipse in rect
    CGContextFillEllipseInRect(ctx, _clearRect);
    
    //draw stroke ellipse in rect
    CGContextSetLineWidth(ctx, 15);
    CGContextStrokeEllipseInRect(ctx, CGRectMake(20, 180, 50, 50));
    
    //draw line with cap round
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 10);
    CGPoint point = CGPointMake(140, 220);
    CGContextMoveToPoint(ctx, point.x, point.y);
    point.x += 100;
    point.y += 20;
    CGContextAddLineToPoint(ctx, point.x, point.y);
    
    
    CGContextStrokePath(ctx);
}
@end
