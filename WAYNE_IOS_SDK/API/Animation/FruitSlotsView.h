//
//  FruitSlotsView.h
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-8-4.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//
@class FruitSlotsView;
@protocol FruitSlotsViewDataSource <NSObject>
-(UIView *)fruitSlotsViewCellAtIndex:(int)index;//返回块视图
-(int)fruitSlotsViewRowCount;//返回行数
-(int)fruitSlotsViewColumnCount;//返回列数
-(int)fruitSlotsViewScoreValueAtIndex:(int)index;//返回块分数
@end
@protocol FruitSlotsViewDelegate <NSObject>
-(void)fruitSlots:(FruitSlotsView *)fruitView arrivalAtCell:(UIView *)cell finished:(BOOL)finished;
@end
typedef enum {
    FruitSlotsStateNormal,
    FruitSlotsStateMovingSpeedUp,
    FruitSlotsStateMovingSpeedConstant,
    FruitSlotsStateMovingSpeedDown,
    FruitSlotsStateFinished
}FruitSlotsState;
#import <UIKit/UIKit.h>

@interface FruitSlotsView : UIView{
    FruitSlotsState _state;
    NSMutableArray *_cells;
}
@property(nonatomic,assign) IBOutlet id<FruitSlotsViewDataSource>dataSource;
@property(nonatomic,assign) IBOutlet id<FruitSlotsViewDelegate>delegate;
@property(nonatomic,assign,readonly) int targetIndex;
//-----
-(void)startAnimatingWithTargetIndex:(int)targetIndex;
-(void)endAnimating;
-(void)reloadData;
@end
