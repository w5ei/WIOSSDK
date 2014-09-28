//
//  TabManager.h
//  YaoPrize
//
//  Created by Wayne on 14-6-17.
//  Copyright (c) 2014年 YaoJi. All rights reserved.
//
@protocol TabManagerDelegate <NSObject>

-(void)didChangeSelectedIndex:(int)currentIndex;

@end
#import <Foundation/Foundation.h>

@interface TabManager : NSObject
@property(nonatomic,assign)id<TabManagerDelegate>delegate;
//-----
-(void)addTabItem:(UIButton*)itemView;
//-----
-(int)currentIndex;
-(void)selectIndex:(int)index;
@end
