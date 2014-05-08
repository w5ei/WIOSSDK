//
//  NumberView.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-26.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "NumberView.h"

@implementation NumberView{
//    UILabel* _numberLabel;
    UIImageView* _backgroundIV;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
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
    if (_numberLabel==nil) {
        _numberLabel = [[UILabel alloc]initWithFrame:self.bounds];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.backgroundColor = [UIColor clearColor];
        _numberLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
        _numberLabel.minimumScaleFactor = 0.1;
        _numberLabel.adjustsFontSizeToFitWidth = YES;
        [self addSubview:_numberLabel];
    }
}
-(void)setNumber:(NSInteger)num{
    if (_numberLabel==nil) {
        [self setupView];
    }
    _numberLabel.text = [NSString stringWithFormat:@"%d",num];
    if (_backgroundIV&&_numberLabel.text.length>1) {
        CGRect frame = _backgroundIV.frame;
        frame.size.width = [_numberLabel.text sizeWithFont:_numberLabel.font].width+frame.size.height/1.5;
        _backgroundIV.frame = frame;
        _backgroundIV.center = CGPointMake(self.frame.size.width-_backgroundIV.frame.size.width/2, self.frame.size.height/2);
        CGPoint center = _numberLabel.center;
        center.x = _backgroundIV.center.x;
        _numberLabel.frame = frame;
        _numberLabel.center = center;
    }
}
-(void)setBackgroundImage:(UIImage*)img marginTop:(CGFloat)top marginLeft:(CGFloat)left{
    if (_numberLabel==nil) {
        [self setupView];
    }
    _backgroundIV = [[UIImageView alloc]initWithImage:[img stretchableImageWithLeftCapWidth:img.size.width/2 topCapHeight:img.size.height/2]];
    _backgroundIV.center = _numberLabel.center;
//    _backgroundIV.contentMode = UIViewContentModeScaleAspectFit;
    CGRect frame = self.bounds;
    _backgroundIV.frame = frame;
    frame.origin.x-=left;
    frame.origin.y-=top;
    _numberLabel.frame = frame;
    [self insertSubview:_backgroundIV belowSubview:_numberLabel];
}

@end
