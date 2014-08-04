//
//  FruitSlotsView.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-8-4.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//
#import "FruitSlotsView.h"
#import "CommonEx.h"
#define MOVE_DELAY_DUR_MAX 1.0F
#define MOVE_DELAY_DUR_MIN 0.20F
#define MOVE_ROUNT_MAX 2

#define DECELERATE_STEP_COUNT 7//减速要经过的格子数（最小为3*3：8个格子）
#define MOVE_DELAY_DUR_STEP_VALUE (MOVE_DELAY_DUR_MAX-MOVE_DELAY_DUR_MIN)/DECELERATE_STEP_COUNT
//#define DECELERATE_DUR 3.F //减速用时，同样为加速用时
//#define SPEED_STEP_VALUE (MOVE_DELAY_DUR_MAX-MOVE_DELAY_DUR_MIN)/DECELERATE_DUR
@implementation FruitSlotsView{
    float _cellWidth;
    float _cellHeight;
    float _moveDelayDur;
    int _currentIndex;
    int _decelerateIndex;//开始减速时的索引
    int _moveRound;
    float _decelerateDur;
    BOOL _isStarting;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _cells = [NSMutableArray array];
    }
    return self;
}
-(void)willMoveToSuperview:(UIView *)newSuperview{
    if (_cells.count==0) {
        [self reloadData];
    }
}
-(void)removeFromSuperview{
    [self endAnimating];
    [super removeFromSuperview];
}
-(void)moveToNextCell{
    BOOL finished = NO;
//    NSLog(@"index=%d,targetIndex=%d,decelerateIndex=%d,delayDur=%f,round=%d,state=%d",_currentIndex,_targetIndex,_decelerateIndex,_moveDelayDur,_moveRound,_state);
    if (_currentIndex >= _cells.count-1) {
        _moveRound++;
        if (_moveRound == MOVE_ROUNT_MAX&&_state==FruitSlotsStateMovingSpeedUp) {
            _state = FruitSlotsStateMovingSpeedConstant;
        }
    }
    if (_state == FruitSlotsStateMovingSpeedUp) {
        if (_moveDelayDur > MOVE_DELAY_DUR_MIN) {
            _moveDelayDur -= MOVE_DELAY_DUR_STEP_VALUE;
        }
    }
    if (_state == FruitSlotsStateMovingSpeedConstant) {
        if (_currentIndex == _decelerateIndex) {
            _state = FruitSlotsStateMovingSpeedDown;
        }
    }
    if (_state == FruitSlotsStateMovingSpeedDown) {
        if (_moveDelayDur < MOVE_DELAY_DUR_MAX) {
            _moveDelayDur += MOVE_DELAY_DUR_STEP_VALUE;
        }
        finished = _currentIndex==self.targetIndex;
    }
    if (finished) {
        _state = FruitSlotsStateFinished;
        _isStarting = NO;
        if (self.delegate&&[self.delegate respondsToSelector:@selector(fruitSlots:arrivalAtCell:finished:)]) {
            [self.delegate fruitSlots:self arrivalAtCell:[_cells objectAtIndex:_currentIndex] finished:finished];
        }
    }
    if (_state!=FruitSlotsStateFinished) {
        _currentIndex = [CommonEx indexFromCurrentIndex:_currentIndex stepValue:1 maxIndexValue:_cells.count-1];
        
        if (self.delegate&&[self.delegate respondsToSelector:@selector(fruitSlots:arrivalAtCell:finished:)]) {
            [self.delegate fruitSlots:self arrivalAtCell:[_cells objectAtIndex:_currentIndex] finished:finished];
        }
        
        [self performSelector:@selector(moveToNextCell) withObject:nil afterDelay:_moveDelayDur];
    }
    
}
-(void)startAnimatingWithTargetIndex:(int)targetIndex{
    if (_isStarting) {
        return;
    }
    _isStarting = YES;
    _targetIndex = targetIndex;
    _moveDelayDur = MOVE_DELAY_DUR_MAX;
    _currentIndex = 0;
    _decelerateIndex = [CommonEx indexFromCurrentIndex:targetIndex stepValue:-DECELERATE_STEP_COUNT maxIndexValue:_cells.count-1];
    _moveRound = 0;
    
    _state = FruitSlotsStateMovingSpeedUp;
    [self performSelector:@selector(moveToNextCell) withObject:nil afterDelay:_moveDelayDur];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(fruitSlots:arrivalAtCell:finished:)]) {
        [self.delegate fruitSlots:self arrivalAtCell:[_cells objectAtIndex:_currentIndex] finished:NO];
    }
    //test
//    int nextIndex = 0;
//    for (int i=0; i<40; i++) {
//        nextIndex = [CommonEx indexFromCurrentIndex:nextIndex stepValue:-3 maxIndexValue:_cells.count-1];
//        NSLog(@"=====%d",nextIndex);
//    }
    //end test
}
-(void)endAnimating{
    if (_state==FruitSlotsStateFinished) {
        return;
    }
    _state = FruitSlotsStateFinished;
    _isStarting = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(moveToNextCell) object:nil];
}
-(void)reloadData{
    if (_cells.count>0) {
        for (UIView *cell in _cells) {
            [cell removeFromSuperview];
        }
        [_cells removeAllObjects];
    }
    if (self.dataSource==nil) {
        return;
    }
    CGSize frameSize = self.frame.size;
    int rowCount = [self.dataSource fruitSlotsViewRowCount];
    rowCount = rowCount>=3?rowCount:3;
    int columnCount = [self.dataSource fruitSlotsViewColumnCount];
    columnCount = columnCount>=3?columnCount:3;
    
    _cellWidth = frameSize.width/columnCount;
    _cellHeight = frameSize.height/rowCount;
    
    //top left cell is the 1st cell
    int index = 0;
    CGRect cellFrame = CGRectMake(0, 0, _cellWidth, _cellHeight);
    //top line
    cellFrame.origin = CGPointMake(0, 0);
    for (int i=0; i<columnCount-1; i++) {
        [self addViewWithFrame:cellFrame cellIndex:index];
        cellFrame.origin.x += _cellWidth;
        index++;
    }
    //right line
    cellFrame.origin.x = self.frame.size.width-_cellWidth;
    cellFrame.origin.y = 0;
    for (int i=0; i<rowCount-1; i++) {
        [self addViewWithFrame:cellFrame cellIndex:index];
        cellFrame.origin.y += _cellHeight;
        index++;
    }
    //bottom line
    cellFrame.origin.x = self.frame.size.width-_cellWidth;
    cellFrame.origin.y = self.frame.size.height-_cellHeight;
    for (int i=0; i<columnCount-1; i++) {
        [self addViewWithFrame:cellFrame cellIndex:index];
        cellFrame.origin.x -= _cellWidth;
        index++;
    }
    //left line
    cellFrame.origin.x = 0;
    cellFrame.origin.y = self.frame.size.height-_cellHeight;
    for (int i=0; i<rowCount-1; i++) {
        [self addViewWithFrame:cellFrame cellIndex:index];
        cellFrame.origin.y -= _cellHeight;
        index++;
    }
}
-(void)addViewWithFrame:(CGRect)frame cellIndex:(int)index{
    UIView *wrapView = [[UIView alloc]initWithFrame:frame];
    wrapView.backgroundColor = [UIColor greenColor];
    [_cells addObject:wrapView];
    UIView *cellView = [self.dataSource fruitSlotsViewCellAtIndex:index];
    if (cellView) {
        [wrapView addSubview:cellView];
    }
    [self addSubview:wrapView];
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
