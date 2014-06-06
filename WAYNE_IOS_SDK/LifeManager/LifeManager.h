//
//  LifeManager.h
//  Version 1.0
//
//  Created by green wayne on 13-10-23.
//  Copyright (c) 2013年 cubic. All rights reserved.
//
@class LifeManager;
@protocol LifeManagerDelegate <NSObject>
@optional
-(void)lifeManager:(LifeManager*)lifeManger timerIsWorking:(int)lifePlusLeftTimeSeconds;
-(void)lifeManager:(LifeManager*)lifeManger lifeChanged:(int)lifeCount;
@end
#import <Foundation/Foundation.h>
@interface LifeManager : NSObject
@property(nonatomic,assign)id<LifeManagerDelegate>delegate;
@property(nonatomic,readonly)int lifeCount;
@property(nonatomic,readonly)int lifePlusLeftTimeSeconds;//增加一条生命剩余秒数
@property(nonatomic,readonly)int totalLeftTimeSeconds;
//-----
//+(id)sharedInstance;
+(id)lifeManager;
+(int)lifeCount;
+(BOOL)isLifeFull;
+(BOOL)isLifeFull:(int)lifeCount;

//调用这个方法会启动一个计时器并通过倒计时来动态减少回复生命时间
-(void)start;
//如果不调用这个方法更新后时间不会固化到本地
-(void)stop;
-(BOOL)isLifeFull;
-(void)lifeMinusOne;
-(void)lifePlusOne;

@end
