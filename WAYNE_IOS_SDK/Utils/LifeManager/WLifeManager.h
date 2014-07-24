//
//  WLifeManager.h
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-6-6.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WLifeManager;
@protocol WLifeManagerDelegate <NSObject>
@optional
-(void)wLifeManager:(WLifeManager*)lifeManager timerIsWorking:(int)lifePlusLeftTimeSeconds;
-(void)wLifeManager:(WLifeManager*)lifeManager lifeChanged:(int)lifeCount;
@end
/**
 * 这个生命管理主要用于服务器的同步显示,并且本地计算基于
 * 所以初始化时就要从服务器上得到，maxLifeCount,lifeCount,lifePlusLeftTimeSeconds
 * 本地保存maxLifeCount并通过 这三个值算出 生命补满一共要多久 用于本地计时
 * e.g.
 * WLifeManager *lm = [WLifeManager instance];
 */
@interface WLifeManager : NSObject
@property(nonatomic,assign)id<WLifeManagerDelegate>delegate;
@property(nonatomic,assign,readonly)int maxLifeCount;//可恢复到的最大生命值
@property(nonatomic,assign,readonly)int lifePlusLeftTimeSeconds;//恢复一条生命剩余秒数
@property(nonatomic,assign,readonly)int lifeCount;//当前生命值，目前不设置上限
@property(nonatomic,assign,readonly)long totalLeftTimeSeconds;//恢复到最大值一共要用的时间
//-----NSDate
//本地方法们
+(id)instance;
/**通过传入的数据来更新本地数据*/
-(void)syncWithMaxLifeCount:(int)maxLifeCount lifePlusTimeInterval:(int)lifePlusTimeInterval lifeCount:(int)lifeCount lifePlueLeftTimeSeconds:(int)lifePlueLeftTimeSeconds;
/**与服务器步：得到服务器端的数据并更新本地数据*/
-(void)syncByServerWithResult:(void (^)(int maxLifeCount,int lifePlusTimeInterval,int lifeCount,int lifePlueLeftTimeSeconds))result;
+(int)lifeCount;
+(BOOL)isLifeFull;
+(BOOL)isLifeFull:(int)lifeCount;
/***/
+(void)lifeMinusOne;
/***/
+(void)lifePlusOne;

//调用这个方法会启动一个计时器并通过倒计时来动态减少回复生命时间
/**启动但使用本地保存的数据,使用前应该确认之前保存过数据*/
-(void)start;
/*启动但使用传入的数据，并更新本地保存的数据*/
-(void)startWithMaxLifeCount:(int)maxLifeCount lifePlusTimeInterval:(int)lifePlusTimeInterval lifeCount:(int)lifeCount lifePlueLeftTimeSeconds:(int)lifePlueLeftTimeSeconds;
//如果不调用这个方法更新后时间不会固化到本地
-(void)stop;
-(BOOL)isLifeFull;
-(void)lifeMinusOne;
-(void)lifePlusOne;
@end
