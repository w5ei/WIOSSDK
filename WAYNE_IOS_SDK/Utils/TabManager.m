//
//  TabManager.m
//  YaoPrize
//
//  Created by Wayne on 14-6-17.
//  Copyright (c) 2014年 YaoJi. All rights reserved.
//

#import "TabManager.h"

@implementation TabManager{
    NSMutableArray *_tabItemViews;
    int _currentIndex;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _tabItemViews = [NSMutableArray array];
    }
    return self;
}
-(void)addTabItem:(UIButton*)itemView{
    [_tabItemViews addObject:itemView];
    [itemView addTarget:self action:@selector(switchItem:) forControlEvents:UIControlEventTouchUpInside];
}
-(BOOL)setCurrentIndex:(int)index{
    if (_currentIndex!=index) {
        _currentIndex = index;
        return YES;
    }
    return NO;
}
-(int)currentIndex{
    return _currentIndex;
}
-(void)selectIndex:(int)index{
    if (index+1>_tabItemViews.count) {
        return;
    }
    [self switchItem:[_tabItemViews objectAtIndex:index]];
}
-(void)switchItem:(id)sender{
    if (_tabItemViews.count==0) {
        return;
    }
    int newIndex = [_tabItemViews indexOfObject:sender];
    if ([self setCurrentIndex:newIndex]) {
        [sender setSelected:YES];
        for (UIButton *itemBtn in _tabItemViews) {
            if (sender!=itemBtn) {
                [itemBtn setSelected:NO];
            }
        }
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(didChangeSelectedIndex:)]) {
            [self.delegate didChangeSelectedIndex:newIndex];
        }
    }
}
@end
