//
//  ProgressView.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-21.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "CoverProgressView.h"
#import "ImageUtil.h"
@implementation CoverProgressView{
    UIImageView* _progressIV;
    UIImageView* _coverIV;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}
-(void)setProgress:(float)progress{
    if (progress==_progress) {
        return;
    }
    if (progress>1) {
        progress = 1;
    }
    if (progress<0) {
        progress = 0;
    }
    [self updateViewWithProgress:progress];
    _progress = progress;
}
-(void)setProgressImage:(UIImage *)progressImage{
    if (progressImage==nil) {
        return;
    }
    _progressImage = progressImage;
    [self updateViewWithProgress:_progress];
}
-(void)setCoverImage:(UIImage *)coverImage{
    if (coverImage==nil) {
        return;
    }
    _coverImage = coverImage;
    [self updateViewWithProgress:_progress];
}
-(UIImageView *)progressImageView{
    [self updateViewWithProgress:_progress];
    return _progressIV;
}
-(void)setProgress:(float)progress progressColor:(CoverProgressColor)color{
    _progress = progress;
    self.color = color;
    [self updateViewWithProgress:self.progress];
}
-(void)setColor:(CoverProgressColor)color{
    if (color==_color) {
        return;
    }
    [self setupPorgressIV];
    
    _color = color;
    
    NSMutableArray* ais = [NSMutableArray array];
    NSString* colorName = @"cyan";
    switch (_color) {
        case CoverProgressColorDefault:
        case CoverProgressColorCyan:
            break;
        case CoverProgressColorBlue:
            colorName = @"blue";
            break;
        case CoverProgressColorGreen:
            colorName = @"green";
            break;
        case CoverProgressColorYellow:
            colorName = @"yellow";
            break;
        case CoverProgressColorMagenta:
            colorName = @"magenta";
            break;
    }
    for (NSUInteger i=0; i<34; i++) {
        UIImage* image =
        [UIImage imageNamed:[NSString stringWithFormat:@"levelbar-%@_%02d.png",colorName,i]];
        [ais addObject:image];
    }
    _progressIV.animationImages = ais;
    [_progressIV startAnimating];
    
}
-(void)setupPorgressIV{
    if (_progressIV==nil) {
        //self.frame.size = (130,42);
        CGFloat pW = 93;
        CGFloat pH = 26;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            pW*=2;
            pH*=2;
        }
        CGRect frame = CGRectMake(self.frame.size.width/2-pW/2, self.frame.size.height/2-pH/2, pW, pH);
        _progressIV = [[UIImageView alloc]initWithFrame:frame];
        
        [self addSubview:_progressIV];
        [self setProgressAnimated:NO];
        
        
    }else if (_progressImage&&_progressIV.image!=_progressImage) {
        _progressIV.image = _progressImage;
    }
}
-(void)updateViewWithProgress:(float)progress{
    [self setupPorgressIV];
    
    if (_coverIV==nil) {
        _coverIV = [[UIImageView alloc]initWithFrame:self.bounds];
        [self addSubview:_coverIV];
        _coverIV.image = [UIImage imageNamed:@"top-levelbar-mask-noglow.png"];
//        _coverIV.alpha = 0.5;
    }else if (_coverImage&&_coverIV.image!=_coverImage) {
        _coverIV.image = _coverImage;
    }
    
    if (progress!=_progress) {
        _progress = progress;
        [self setProgressAnimated:YES];
    }
}
-(void)setProgressAnimated:(BOOL)animated{
    CGFloat margin = self.frame.size.width/2-_progressIV.frame.size.width/2;
    CGRect frame = _progressIV.frame;
    frame.origin.x = margin+(-frame.size.width)+frame.size.width*_progress;
    [UIView animateWithDuration:animated?1.2:0 delay:0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
        _progressIV.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
}
+(CoverProgressColor)colorOfDifficultyLevel:(NSString*)difficultyLevelName{
    CoverProgressColor color = CoverProgressColorGreen;
//    if ([difficultyLevelName isEqualToString:@"小菜鸟"]) {
//    }
    if ([difficultyLevelName isEqualToString:@"初学者"]) {
        color = CoverProgressColorCyan;//cyan
    }
    if ([difficultyLevelName isEqualToString:@"入门级"]) {
        color = CoverProgressColorBlue;//blue
    }
    if ([difficultyLevelName isEqualToString:@"专家级"]) {
        color = CoverProgressColorYellow;//yellow
    }
    if ([difficultyLevelName isEqualToString:@"大师级"]) {
        color = CoverProgressColorMagenta;//red
    }
    return color;
}
@end
