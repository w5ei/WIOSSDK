//
//  ViewGroup.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-10.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "ViewGroup.h"

@implementation ViewGroup{
    NSUInteger _colCount;
    CGFloat _paddingX;
    CGFloat _paddingY;
    CGSize _pieceSize;
}
@synthesize views = _views;
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

-(void)setupViewWithImageNames:(NSArray*)imageNames{
    [self setupViewWithImageNames:imageNames forceSize:NO size:CGSizeZero];
}
-(void)setupViewWithImageNames:(NSArray*)imageNames forceSize:(BOOL)force size:(CGSize)size{
    [self setupViewWithImageNames:imageNames forceSize:force size:size column:0 paddingX:0 paddingY:0];
}
/**
 *TODO: check imageName and it's count
 */
-(void)setupViewWithImageNames:(NSArray*)imageNames forceSize:(BOOL)force size:(CGSize)size column:(NSUInteger)col paddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY{
    NSMutableArray* imageViews = [NSMutableArray arrayWithCapacity:imageNames.count];
    for (NSString* imageName in imageNames) {
        UIImage* image = [UIImage imageNamed:imageName];
        UIImageView* iv = [[UIImageView alloc]initWithImage:image];
        iv.contentMode = UIViewContentModeScaleToFill;
        if (force) {
            iv.frame = CGRectMake(0, 0, size.width, size.height);
        }else{
            size = iv.frame.size;
        }
        [imageViews addObject:iv];
    }
    [self setupViewWithViews:imageViews pieceSize:size column:col paddingX:paddingX paddingY:paddingY];
}
-(void)setupViewWithViews:(NSArray*)views pieceSize:(CGSize)pieceSize column:(NSUInteger)col paddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY{
    NSUInteger viewCount = views.count;
    if (views==NULL||viewCount==0) {
        return;
    }
    //compute the contentSize of self
    if (self.frame.size.height==0||self.frame.size.width==0) {
        if (col==0||col>viewCount) {
            col = viewCount;
        }
        float selfH = (pieceSize.height+paddingY)*ceilf(((float)viewCount/(col==0?viewCount:col)))+paddingY;
        float selfW = (pieceSize.width+paddingX)*(col==0?viewCount:col)+paddingX;
        CGRect frame = self.frame;
        frame.size = CGSizeMake(selfW, selfH);
        self.frame = frame;
    }
    
    for (UIView* child in self.subviews) {
        [child removeFromSuperview];
    }
    
    if (_views==nil) {
        _views = [NSMutableArray array];
    }else
        [_views removeAllObjects];
    [_views addObjectsFromArray:views];
    
    _pieceSize = pieceSize;
    _paddingX = paddingX;
    _paddingY = paddingY;
    _colCount = col;
    
    for (NSUInteger i=0; i<viewCount; i++) {
        UIView* pieceView = [views objectAtIndex:i];
        pieceView.center = CGPointMake(self.frame.size.width/2, self.frame.size.height/2);
//        pieceView.alpha = 0.5;
        [self addSubview:pieceView];
//        [self insertSubview:pieceView atIndex:0];
    }
    [self alginSubviewsAnimated:NO];
}
-(void)alginSubviewsAnimated:(BOOL)animated{
    
    NSUInteger viewCount = _views.count;
    NSUInteger col = _colCount;
    if (col==0||col>viewCount) {
        col = viewCount;
    }
    
    CGFloat pieceWidth = _pieceSize.width;
    CGFloat pieceHeight = _pieceSize.height;
    
    CGFloat x = _paddingX;
    //X algin center
    x += (self.frame.size.width-pieceWidth*col-_paddingX*(col+1))/2;
    CGFloat y = _paddingY;
    
    CGRect frame = CGRectMake(x, y, pieceWidth, pieceHeight);
    
    for (NSUInteger i=0; i<viewCount; i++) {
        UIView* pieceView = [_views objectAtIndex:i];
        if (col!=viewCount&&i!=0&&i%col==0) {
            frame.origin.y+=pieceView.frame.size.height+_paddingY;
            frame.origin.x = x;
        }
        
        if (animated) {
            [UIView animateWithDuration:0.35 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction animations:^{
                pieceView.frame = CGRectMake(
                                             (frame.size.width-pieceView.frame.size.width)/2+frame.origin.x,
                                             frame.origin.y,
                                             (pieceView.frame.size.width),
                                             (pieceView.frame.size.height));
            } completion:^(BOOL finished) {
                
            }];
        }else{
            pieceView.frame = CGRectMake(
                                         (frame.size.width-pieceView.frame.size.width)/2+frame.origin.x,
                                         frame.origin.y,
                                         (pieceView.frame.size.width),
                                         (pieceView.frame.size.height));
        }
        frame.origin.x+=_paddingX+pieceWidth;
    }
}
-(void)setupViewWithViews:(NSArray*)views{
    if (views.count==0) {
        return;
    }
    NSUInteger col = 0;
    CGFloat paddingX = 0;
    CGFloat paddingY = 0;
    CGSize pieceSize = ((UIView*)[views objectAtIndex:0]).frame.size;
    [self setupViewWithViews:views pieceSize:pieceSize column:col paddingX:paddingX paddingY:paddingY];
}
-(void)removeLastView{
    UIView* view = [_views lastObject];
    [view removeFromSuperview];
    [_views removeObject:view];
    [self alginSubviewsAnimated:YES];
}
@end
