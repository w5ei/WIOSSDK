//
//  WLifeManager.m
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-6-6.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "WLifeManager.h"

@implementation WLifeManager{
    NSTimer* _timer;//增加生命计时器
    
    int _maxLifeCount;
    int _lifePlusTimeInterval;
    int _lifeCount;//当前生命数
    int _lifePlusLeftTimeSeconds;
    long _totalLeftTimeSeconds;//离结束一共剩余的时间
}
-(void)dealloc{
    [self stop];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}
-(NSString *)description{
    return [NSString stringWithFormat:@"[LifeCount:%d],[plusOneLeftTime:%d],[totalLeftTime:%ld]",_lifeCount,_lifePlusLeftTimeSeconds,_totalLeftTimeSeconds];
}

+(id)instance
{
    static dispatch_once_t pred;
    static WLifeManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}

- (id)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(appActivated:)
                                                     name: UIApplicationDidBecomeActiveNotification
                                                   object: nil];
        [[NSNotificationCenter defaultCenter] addObserver: self
                                                 selector: @selector(appBackgrounded:)
                                                     name: UIApplicationDidEnterBackgroundNotification
                                                   object: nil];
    }
    return self;
}
- (void)appActivated:(NSNotification *)noti{
    [self resume];
}
- (void)appBackgrounded:(NSNotification *)noti{
    [self pause];
}

-(void)syncWithMaxLifeCount:(int)maxLifeCount lifePlusTimeInterval:(int)lifePlusTimeInterval lifeCount:(int)lifeCount lifePlueLeftTimeSeconds:(int)lifePlueLeftTimeSeconds{
    //保存最大可恢复生命数，和恢复时间间隔
    [WLifeManager persistMaxLifeCount:maxLifeCount];
    [WLifeManager persistLifePlusTimeInterval:lifePlusTimeInterval];
    //如果生命数大于可恢复生命最大值，则不需要恢复生命
    if (lifeCount>=maxLifeCount) {
        _totalLeftTimeSeconds = 0;
        [WLifeManager persistLifeCount:lifeCount];
    }else{
        _totalLeftTimeSeconds = (maxLifeCount-lifeCount)*lifePlusTimeInterval+lifePlueLeftTimeSeconds;
    }
    //保存前面计算得到的总剩余时间
    [WLifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeSeconds];
    
    _maxLifeCount = maxLifeCount;
    _lifePlusTimeInterval = lifePlusTimeInterval;
    _lifeCount = lifeCount;
    _lifePlusLeftTimeSeconds = lifePlueLeftTimeSeconds;
}
-(void)syncByServerWithResult:(void (^)(int maxLifeCount,int lifePlusTimeInterval,int lifeCount,int lifePlueLeftTimeSeconds))result{
    //TODO: 从服务器得到数据 并调用 -(void)syncWithMaxLifeCount:(int)maxLifeCount lifePlusTimeInterval:(int)lifePlusTimeInterval lifeCount:(int)lifeCount lifePlueLeftTimeSeconds:(int)lifePlueLeftTimeSeconds; 方法
    //test
    result(60,30,60,0);
}
-(void)start{
    _maxLifeCount = [WLifeManager readMaxLifeCount];
    _lifePlusTimeInterval = [WLifeManager readLifePlusTimeInterval];
    
    _totalLeftTimeSeconds = [WLifeManager totalLeftTimeSeconds];
    
    if (_totalLeftTimeSeconds>0) {
        _lifeCount = [WLifeManager lifeCountWithTotalLeftTimeSeconds:_totalLeftTimeSeconds];
        
        if (_totalLeftTimeSeconds>_lifePlusTimeInterval) {
            _lifePlusLeftTimeSeconds = _totalLeftTimeSeconds%_lifePlusTimeInterval;
        }else{
            _lifePlusLeftTimeSeconds = _totalLeftTimeSeconds;
        }
    }else{
        _lifeCount = [WLifeManager readLifeCount];
    }
    
    [self startTimer];
}

-(void)startWithMaxLifeCount:(int)maxLifeCount lifePlusTimeInterval:(int)lifePlusTimeInterval lifeCount:(int)lifeCount lifePlueLeftTimeSeconds:(int)lifePlueLeftTimeSeconds{
    
    [self syncWithMaxLifeCount:maxLifeCount lifePlusTimeInterval:lifePlusTimeInterval lifeCount:lifeCount lifePlueLeftTimeSeconds:lifePlueLeftTimeSeconds];
    
    [self startTimer];
}

-(void)startTimer{
    [self updateLifeCount:_lifeCount];
    [self updateLifePlusLeftTimeSeconds:_lifePlusLeftTimeSeconds];
    //无论是否计时都开一个计时器。这样当生命减少时不用做额外设置
    if (_timer) {
        [self pause];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTimeMinus) userInfo:nil repeats:YES];
}
-(void)doTimeMinus{
    
    if (_totalLeftTimeSeconds>0) {
        
        _totalLeftTimeSeconds--;
        _lifePlusLeftTimeSeconds--;
        
        if (_lifePlusLeftTimeSeconds<=0) {
            _lifeCount+=1;
            [self updateLifeCount:_lifeCount];
            
            _lifePlusLeftTimeSeconds = [self isLifeFull]?0:_lifePlusTimeInterval;
        }
        
        [self updateLifePlusLeftTimeSeconds:_lifePlusLeftTimeSeconds];
    }
//    NSLog(@"#####%@",self);
}
-(void)resume{
    if(_timer==nil)[self start];
}

-(void)pause{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [WLifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeSeconds];
}
-(void)stop{
    self.delegate = nil;
    [self pause];
}
-(int)lifePlusLeftTimeSeconds{
    return _lifePlusLeftTimeSeconds;
}
#pragma mark-  Life and time reset
-(void)lifeMinusOne{
    if (_lifeCount==0) {
        return;
    }
    
    if (_lifeCount>_maxLifeCount) {
        _lifeCount-=1;
        [self updateLifeCount:_lifeCount];
        [WLifeManager persistLifeCount:_lifeCount];
    }else{
        
        if ([self isLifeFull]) {
            _lifePlusLeftTimeSeconds = _lifePlusTimeInterval;
        }else{
            
        }
        _lifeCount-=1;
        [self updateLifeCount:_lifeCount];
        
        _totalLeftTimeSeconds += _lifePlusTimeInterval;
        [WLifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeSeconds];
        [self updateLifePlusLeftTimeSeconds:_lifePlusLeftTimeSeconds];
    }
    
    NSLog(@"#####%@",self);
}
+(void)lifeMinusOne{
    int lifeCount = [self readLifeCount];
    if (lifeCount<=0) {
        return;
    }
    lifeCount-=1;
    int maxLifeCont = [self readMaxLifeCount];
    if (lifeCount<maxLifeCont) {
        int lifePlusTimeInterval = [self readLifePlusTimeInterval];
        long totalLifeTimeInterval = [self totalLeftTimeSeconds];
        totalLifeTimeInterval+=lifePlusTimeInterval;
        [self persistFinishDateWithTimeIntervalSinceNow:totalLifeTimeInterval];
    }else{
        [self persistLifeCount:lifeCount];
    }
}
-(void)lifePlusOne{
    if ([self isLifeFull]) {
        _lifeCount+=1;
        [WLifeManager persistLifeCount:_lifeCount];
        [self updateLifeCount:_lifeCount];
    }else{
        
        _lifeCount+=1;
        [self updateLifeCount:_lifeCount];
        
        _totalLeftTimeSeconds-= _lifePlusTimeInterval;
        [WLifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeSeconds];
        //增加一次生命，并重新设置停止记时时间（把之前的时间改变为LIVF_PLUS_SECONDS之前）
        if ([self isLifeFull]) {
            _totalLeftTimeSeconds = 0;
            _lifePlusLeftTimeSeconds = 0;
            [WLifeManager persistLifeCount:_maxLifeCount];
            [self updateLifePlusLeftTimeSeconds:_lifePlusLeftTimeSeconds];
        }
        
    }
}
+(void)lifePlusOne{
    int lifePlusTimeInterval = [self readLifePlusTimeInterval];
    long totalLifeTimeInterval = [self totalLeftTimeSeconds];
    if (totalLifeTimeInterval>=0) {
        totalLifeTimeInterval-=lifePlusTimeInterval;
        [self persistFinishDateWithTimeIntervalSinceNow:totalLifeTimeInterval];
    }else{
        [WLifeManager persistLifeCount:[WLifeManager readLifeCount]+1];
    }
    
}

-(void)updateLifePlusLeftTimeSeconds:(int)lifePlusLeftTimeSeconds{
    if (_delegate&&[_delegate respondsToSelector:@selector(wLifeManager:timerIsWorking:)]) {
        [_delegate wLifeManager:self timerIsWorking:lifePlusLeftTimeSeconds];
    }
}
-(void)updateLifeCount:(int)count{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(wLifeManager:lifeChanged:)]) {
        [self.delegate wLifeManager:self lifeChanged:count];
    }
}

-(BOOL)isLifeFull{
    return _lifeCount >= _maxLifeCount;
}
-(int)lifeCount{
    if (_timer) {
        return _lifeCount;
    }
    return [WLifeManager lifeCount];
}
-(long)totalLeftTimeSeconds{
    return _totalLeftTimeSeconds;
}
-(int)maxLifeCount{
    if (_maxLifeCount==0) {
        return [WLifeManager readMaxLifeCount];
    }
    return _maxLifeCount;
}
#pragma mark-
+(BOOL)isLifeFull{
    return [self isLifeFull:[WLifeManager lifeCount]];
}
+(BOOL)isLifeFull:(int)lifeCount{
    return lifeCount >= [WLifeManager lifeCount];
}
+(int)lifeCountWithTotalLeftTimeSeconds:(long)totalLeftTimeSeconds{
    //如果生命已经满了，读取本地保存的生命数
    int maxLifeCount = [self readMaxLifeCount];
    if (totalLeftTimeSeconds<=0) {
        return maxLifeCount;
    }
    //否则计算出当前生命数量
    int lifePlusTimeInterval = [self readLifePlusTimeInterval];
    int weakLifeCount = ceil((double)totalLeftTimeSeconds/lifePlusTimeInterval);
    return maxLifeCount-weakLifeCount;
}

+(int)lifeCount{
    long totalLeftTimeSeconds = [self totalLeftTimeSeconds];
    return [self lifeCountWithTotalLeftTimeSeconds:totalLeftTimeSeconds];
}

+(long)totalLeftTimeSeconds{
    NSDate* finishDate = [self finishDate];
    if (finishDate==nil) {
        return 0;
    }
    long left = finishDate?[finishDate timeIntervalSinceNow]:0;
    if (left<=0) {
        left = 0;
        [self persistLifeCount:[self readMaxLifeCount]];
    }
    return (long)left;
}
#pragma mark- Time persist
static NSString* const kFinishDate = @"kFinishDate";//结束时间
+(NSDate*)finishDate{
    NSDate* finishDate = [[NSUserDefaults standardUserDefaults]valueForKey:kFinishDate];
    return finishDate;
}
+(void)clearFinishDate{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kFinishDate];
    [ud synchronize];
}
+(void)persistFinishDateWithTimeIntervalSinceNow:(NSTimeInterval)totalLeftTimeInterval{
    if (totalLeftTimeInterval<=0) {
        [self clearFinishDate];
        return;
    }
    NSDate* finishDate = [NSDate dateWithTimeIntervalSinceNow:totalLeftTimeInterval];
    //    NSLog(@"%f========%@",finishTimeInterval,finishDate);
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:finishDate forKey:kFinishDate];
    [ud synchronize];
}

#pragma mark- Time persist
static NSString* const kLifeBecomeWeakDate = @"kLifeBecomeWeakDate";//生命变为不满的时间
+(NSDate*)lifeBecomeWeakDate{
    NSDate* lifeBecomeWeakDate = [[NSUserDefaults standardUserDefaults]valueForKey:kLifeBecomeWeakDate];
    return lifeBecomeWeakDate;
}
+(void)clearLifeBecomeWeakDate{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kLifeBecomeWeakDate];
    [ud synchronize];
}

static NSString* const kMaxLifeCount = @"kMaxLifeCount";
+(void)persistMaxLifeCount:(int)count{
    if (count<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:count forKey:kMaxLifeCount];
    [ud synchronize];
}
+(int)readMaxLifeCount{
    return [[NSUserDefaults standardUserDefaults]integerForKey:kMaxLifeCount];
}
/*生命增加的一个要用的秒数*/
static NSString* const kLifePlusTimeInterval = @"kLifePlusTimeInterval";
+(void)persistLifePlusTimeInterval:(int)count{
    if (count<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:count forKey:kLifePlusTimeInterval];
    [ud synchronize];
}
+(int)readLifePlusTimeInterval{
    return [[NSUserDefaults standardUserDefaults]integerForKey:kLifePlusTimeInterval];
}

static NSString* const kLifeCount = @"kLifeCount";
+(void)persistLifeCount:(int)count{
    if (count<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:count forKey:kLifeCount];
    [ud synchronize];
}
+(int)readLifeCount{
    return [[NSUserDefaults standardUserDefaults]integerForKey:kLifeCount];
}

@end
