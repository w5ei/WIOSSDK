//
//  ViewGroup.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-10.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewGroup : UIView
@property(nonatomic,strong,readonly)NSMutableArray* views;
-(void)setupViewWithViews:(NSArray*)views;
-(void)setupViewWithViews:(NSArray*)views pieceSize:(CGSize)pieceSize column:(NSUInteger)col paddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY;
-(void)setupViewWithImageNames:(NSArray*)imageNames forceSize:(BOOL)force size:(CGSize)size column:(NSUInteger)col paddingX:(CGFloat)paddingX paddingY:(CGFloat)paddingY;
-(void)setupViewWithImageNames:(NSArray*)imageNames;
-(void)setupViewWithImageNames:(NSArray*)imageNames forceSize:(BOOL)force size:(CGSize)size;
-(void)removeLastView;
@end
