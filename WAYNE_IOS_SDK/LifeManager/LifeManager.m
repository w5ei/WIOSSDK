//
//  LifeManager.m
//  Version 2.0
//
//  Created by green wayne on 13-10-23.
//  Copyright (c) 2013年 wayne. All rights reserved.
//

#import "LifeManager.h"
static int const MAX_LIVES_COUNT = 5;
static int const LIFE_PLUS_INTERVAL_SECONDS = 60*30;
@implementation LifeManager{
    NSTimer* _timer;//增加生命计时器
    int _lifeCount;//当前生命数
    int _lifePlusLeftTimeSeconds;
    int _totalLeftTimeInterval;//离结束一共剩余的时间
}

-(void)dealloc{
    [self stop];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}
-(NSString *)description{
    return [NSString stringWithFormat:@"[LifeCount:%d],[plusOneLeftTime:%d],[totalLeftTime:%d]",_lifeCount,_lifePlusLeftTimeSeconds,_totalLeftTimeInterval];
}
+(id)sharedInstance
{
    static dispatch_once_t pred;
    static LifeManager *sharedInstance = nil;
    
    dispatch_once(&pred, ^{
        sharedInstance = [[[self class] alloc] init];
    });
    return sharedInstance;
}
+(id)lifeManager{
    id instance = [[self alloc]init];
#if !__has_feature(objc_arc)
    [instance autorelease];
#endif
    return instance;
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
    [self start];
}
- (void)appBackgrounded:(NSNotification *)noti{
    [self pause];
}
-(void)start{
    
    _totalLeftTimeInterval = [LifeManager totalLeftTimeInterval];
    _lifeCount = [LifeManager lifeCountWithTotalLeftTimeInterval:_totalLeftTimeInterval];
    [self updateLifeCount:_lifeCount];
    
    if (_totalLeftTimeInterval>0) {
        if (_totalLeftTimeInterval>LIFE_PLUS_INTERVAL_SECONDS) {
            _lifePlusLeftTimeSeconds = _totalLeftTimeInterval%LIFE_PLUS_INTERVAL_SECONDS;
        }else{
            _lifePlusLeftTimeSeconds = _totalLeftTimeInterval;
        }
    }
    //无论是否计时都开一个计时器。这样当生命减少时不用做额外设置
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTimeMinus) userInfo:nil repeats:YES];
}
-(void)pause{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [LifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeInterval];
}
-(void)stop{
    self.delegate = nil;
    [self pause];
}


-(NSInteger)lifePlusLeftTimeSeconds{
    return _lifePlusLeftTimeSeconds;
}
#pragma mark-  Life and time reset
-(void)lifeMinusOne{
    if (_lifeCount==0) {
        return;
    }
    if ([self isLifeFull]) {
        _lifePlusLeftTimeSeconds = LIFE_PLUS_INTERVAL_SECONDS;
    }else{
        
    }
    _lifeCount-=1;
    [self updateLifeCount:_lifeCount];
    _totalLeftTimeInterval+= LIFE_PLUS_INTERVAL_SECONDS;
    [LifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeInterval];
}
-(void)lifePlusOne{
    if ([self isLifeFull]) {
        return;
    }
    _lifeCount+=1;
    [self updateLifeCount:_lifeCount];
    _totalLeftTimeInterval-= LIFE_PLUS_INTERVAL_SECONDS;
    [LifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeInterval];
    //增加一次生命，并重新设置停止记时时间（把之前的时间改变为LIVF_PLUS_SECONDS之前）
    if ([self isLifeFull]) {
        _totalLeftTimeInterval = 0;
    }
}

-(void)doTimeMinus{
    
    if (_totalLeftTimeInterval>0) {
        
        _totalLeftTimeInterval--;
        _lifePlusLeftTimeSeconds--;
        
        if (_lifePlusLeftTimeSeconds<=0) {
            _lifeCount+=1;
            [self updateLifeCount:_lifeCount];
            
            _lifePlusLeftTimeSeconds = [self isLifeFull]?0:LIFE_PLUS_INTERVAL_SECONDS;
        }
        
        if (_delegate&&[_delegate respondsToSelector:@selector(lifeManager:timerIsWorking:)]) {
            
            [_delegate lifeManager:self timerIsWorking:_lifePlusLeftTimeSeconds];
        }
    }
//    NSLog(@"#####%@",self);
}


-(void)updateLifeCount:(int)count{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(lifeManager:lifeChanged:)]) {
        [self.delegate lifeManager:self lifeChanged:count];
    }
}

-(BOOL)isLifeFull{
    return self.lifeCount >= MAX_LIVES_COUNT;
}
-(int)lifeCount{
    if (_timer) {
        return _lifeCount;
    }
    return [LifeManager lifeCount];
}
-(int)totalLeftTimeSeconds{
    return _totalLeftTimeInterval;
}
#pragma mark-
+(BOOL)isLifeFull{
    return [self isLifeFull:[LifeManager lifeCount]];
}
+(BOOL)isLifeFull:(int)lifeCount{
    return lifeCount >= MAX_LIVES_COUNT;
}
+(int)lifeCountWithTotalLeftTimeInterval:(double)totalLeftTimeInterval{
    if (totalLeftTimeInterval==0) {
        return MAX_LIVES_COUNT;
    }
    int weakLifeCount = ceil(totalLeftTimeInterval/LIFE_PLUS_INTERVAL_SECONDS);
    return MAX_LIVES_COUNT-weakLifeCount;
}
+(int)lifeCount{
    double totalLeftTimeInterval = [self totalLeftTimeInterval];
    return [self lifeCountWithTotalLeftTimeInterval:totalLeftTimeInterval];
}

+(NSTimeInterval)totalLeftTimeInterval{
    NSDate* finishDate = [self finishDate];
    if (finishDate==nil) {
        return 0;
    }
    NSTimeInterval left = finishDate?[finishDate timeIntervalSinceNow]:0;
    if (left<=0) {
        left = 0;
    }
    return left;
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


//
//static NSString* const kIsDefaultValuesInitialized = @"kIsDefaultValuesInitialized";
//

//static NSString* const kLifeCount = @"kLifeCount";
//+(BOOL)isDefaultValuesInitialized{
//    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//    BOOL isDefaultValuesInitialized = [ud boolForKey:kIsDefaultValuesInitialized];
//    if (!isDefaultValuesInitialized) {
//        [ud setBool:YES forKey:kIsDefaultValuesInitialized];
//        [ud synchronize];
//        return NO;
//    }else{
//        return YES;
//    }
//}
//+(void)initializeDefaultValues{
//    NSArray* defaultValues = @[
//                               @{kLifeCount:@5}
//                               ];
//    if (![self isDefaultValuesInitialized]) {
//        
//        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
//        for (NSDictionary* dic in defaultValues) {
//            [ud setValue:dic.allValues.firstObject forKey:dic.allKeys.firstObject];
//        }
//        [ud synchronize];
//    }
//}
@end
