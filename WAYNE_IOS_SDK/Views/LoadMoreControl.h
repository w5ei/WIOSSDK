//
//  LoadMoreControl.h
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-6-30.
//  Copyright (c) 2014年 wayne All rights reserved.
//
@protocol LoadMoreControlDelegate <NSObject>
-(void)didTagForLoadingMore;
@end
#import <UIKit/UIKit.h>
typedef enum {
    LoadMoreControlStateNoData,
    LoadMoreControlStateNormal,
    LoadMoreControlStateLoading
} LoadMoreControlState;
@interface LoadMoreControl : UIView
@property(nonatomic,assign)id<LoadMoreControlDelegate>delegate;
@property (nonatomic, assign) LoadMoreControlState state;
//-----
/**添加到ScrollView中，但此时不会显示，当设置shouldLoad为YES时会显示*/
-(void)appendToScrollView:(UIScrollView*)parentView;
@end