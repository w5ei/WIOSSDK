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
	size_t				_radius;
    CGPoint             _position;
    UIImageView *_tagIV;
}
- (void)dealloc {
	CGColorSpaceRelease(_colorSpace);
}
- (id)initWithFrame:(CGRect)frame position:(CGPoint)pos radius:(size_t)radius
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _colorSpace = CGColorSpaceCreateDeviceRGB();
        _radius = radius;
        _position = pos;
//        CGPoint center = CGPointMake(pos.x+_radius, pos.y+_radius);
        _tagIV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"detalle"]];
        
        
        
            _tagIV.center = CGPointMake(pos.x + _radius*2+_tagIV.frame.size.width/2, pos.y+_radius);
            
            [UIView animateWithDuration:0.65 delay:0.15 options:UIViewAnimationOptionRepeat|UIViewAnimationOptionAutoreverse animations:^{
                _tagIV.transform = CGAffineTransformMakeTranslation(30, 0);
            } completion:^(BOOL finished) {
                
            }];
        
        
        
        [self addSubview:_tagIV];
        
        
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(ctx, [UIColor colorWithWhite:0 alpha:0.5].CGColor);
    CGContextFillRect(ctx, rect);
    
    CGBlendMode blendMode = kCGBlendModeClear;
    CGContextSetBlendMode(ctx,blendMode);
    
    CGContextSetStrokeColor(ctx, CGColorGetComponents([UIColor yellowColor].CGColor));
    CGContextSetLineCap(ctx, kCGLineCapRound);
    CGContextSetLineWidth(ctx, 2 * _radius);
    CGPoint point = CGPointMake(_position.x+_radius, _position.y+_radius);
    CGContextMoveToPoint(ctx, point.x, point.y);
    CGContextAddLineToPoint(ctx, point.x, point.y);
    CGContextStrokePath(ctx);
}
@end
