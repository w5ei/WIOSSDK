//
//  LoadMoreControl.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-6-30.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import "LoadMoreControl.h"
static const float VIEW_HEIGHT = 44;
static const float ANIMATION_DURATION = 0.35;
static char mKVOContext;
static NSString * const Text_TapToLoadMore = @"加载更多";
@implementation LoadMoreControl{
    UIScrollView *_parentView;
    UIActivityIndicatorView *_progressView;
    UIButton *_loadMoreBtn;
}
-(void)dealloc{
    [self removeObservers];
}
-(void)removeObservers{
    [self.superview removeObserver:self forKeyPath:@"contentSize" context:&mKVOContext];
    [self.superview removeObserver:self forKeyPath:@"contentOffSet" context:&mKVOContext];
}
-(void)appendToScrollView:(UIScrollView *)parentView{
    _parentView = parentView;
    
    CGRect frame = parentView.bounds;
    frame.size = parentView.contentSize;
    frame.origin.y =
    frame.size.height
    -VIEW_HEIGHT;
    frame.size.height = VIEW_HEIGHT;
    self.frame = frame;
    if (self.superview) {
        [self removeObservers];
        [self removeFromSuperview];
    }else{
        [parentView addObserver:self forKeyPath:@"contentSize" options:NSKeyValueObservingOptionNew context:&mKVOContext];
        [parentView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:&mKVOContext];
    }
    
    if (_progressView == nil) {
        _progressView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        _loadMoreBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loadMoreBtn setTitle:Text_TapToLoadMore forState:UIControlStateNormal];
        [_loadMoreBtn setTitleColor:[UIColor colorWithRed:127/255.0 green:119/255.0 blue:106/255.0 alpha:1] forState:UIControlStateNormal];
        _loadMoreBtn.frame = self.bounds;
        [self addSubview:_loadMoreBtn];
        [_loadMoreBtn addTarget:self action:@selector(tapAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_progressView];
        _progressView.center = _loadMoreBtn.center;
        [_progressView setHidesWhenStopped:YES];
    }
    [_parentView addSubview:self];
    self.hidden = YES;
}

-(void)setState:(LoadMoreControlState)state{
    if (state == _state) {
        return;
    }
    //如果是无数据状态，先设置并显示自己
    if (_state == LoadMoreControlStateNoData) {
        self.hidden = NO;
        UIEdgeInsets inset = [_parentView contentInset];
        inset.bottom += VIEW_HEIGHT;
        
        // Offset changes when changing inset. Store value before changing inset
        // in order to set offset back to previous value.
        CGPoint offset = [_parentView contentOffset];
        
        // Cancel dragging.
        [_parentView setScrollEnabled:NO];
        [_parentView setScrollEnabled:YES];
        
        // Tweak content inset and adjust offset to look like before.
        [_parentView setContentInset:inset];
        [_parentView setContentOffset:offset];
    }
    _state = state;
    if (_state == LoadMoreControlStateLoading) {
        //        CGRect frame = [self frame];
        //        frame.origin.y = VIEW_HEIGHT + CGRectGetHeight(_parentView.frame);
        //        [self setFrame:frame];
        _loadMoreBtn.hidden = YES;
        [_progressView startAnimating];
//        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
//            [_parentView setContentOffset:CGPointMake(0, _parentView.contentSize.height)];
//            [[self layer] setAffineTransform:CGAffineTransformIdentity];
//        }];
    }
    if (_state == LoadMoreControlStateNormal) {
        _loadMoreBtn.hidden = NO;
        [_progressView stopAnimating];
        
//        [self updatePosition];
    }
    if (_state == LoadMoreControlStateNoData) {
//        _loadMoreBtn.hidden = YES;
        [_progressView stopAnimating];
        UIEdgeInsets inset = [_parentView contentInset];
        inset.bottom -= VIEW_HEIGHT;
        
//        CGRect frame = [self frame];
//        frame.origin.y = -VIEW_HEIGHT;
//        [self setFrame:frame];
        self.hidden = YES;
        
        [UIView animateWithDuration:ANIMATION_DURATION
                         animations:^{
                             [_parentView setContentInset:inset];
                         }
                         completion:^(BOOL finished){
                             [_progressView stopAnimating];
                         }];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if (context == &mKVOContext) {
        if ([keyPath isEqual:@"contentSize"]) {
            [self updatePositions];
        }
        if ([keyPath isEqual:@"contentOffset"]) {
            UIScrollView *scrollView = _parentView;
            float offsetY = scrollView.contentOffset.y+scrollView.frame.size.height;
            float contentSizeH = scrollView.contentSize.height+scrollView.contentInset.bottom+scrollView.contentInset.top;
            if (abs(offsetY-contentSizeH)<=44) {
                if(self.state!=LoadMoreControlStateNoData)[self tapAction];
            }
        }
    }
}

-(void)updatePositions{
    CGRect frame = _parentView.bounds;
    frame.size.height = VIEW_HEIGHT;
    float contentSizeH = _parentView.contentSize.height;
    float y = contentSizeH;
    frame.origin.y = y;
    
    
    self.frame = frame;
    [self.superview bringSubviewToFront:self];
}
-(void)tapAction{
    [self setState:LoadMoreControlStateLoading];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(didTagForLoadingMore)]) {
        [self.delegate didTagForLoadingMore];
    }
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