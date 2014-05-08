//
//  LifeManager.h
//  Version 1.0
//
//  Created by green wayne on 13-10-23.
//  Copyright (c) 2013年 cubic. All rights reserved.
//
@protocol LifeManagerDelegate <NSObject>
@optional
-(void)lifeManagerTimerIsWorking:(NSUInteger)lifePlusLeftTimeSeconds;
-(void)lifeManagerLifeChanged:(NSUInteger)lifeCount;
@end
#import <Foundation/Foundation.h>
@interface LifeManager : NSObject
@property(nonatomic,assign)id<LifeManagerDelegate>delegate;
@property(nonatomic,readonly)NSInteger lifeCount;
@property(nonatomic,readonly)NSInteger lifePlusLeftTimeSeconds;//增加一条生命剩余秒数
//-----
//+(id)sharedInstance;
+(id)lifeManager;
+(NSUInteger)lifeCount;
-(BOOL)isLifeFull;
+(BOOL)isLifeFull;
-(void)lifeMinusOne;
-(void)lifePlusOne;
-(void)start;
-(void)stop;
@end
