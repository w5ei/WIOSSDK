//
//  LifeManager.m
//  Version 1.0
//
//  Created by green wayne on 13-10-23.
//  Copyright (c) 2013年 cubic. All rights reserved.
//

#import "LifeManager.h"
static NSUInteger const MAX_LIVES_COUNT = 5;
//static NSUInteger const DEFAULT_LIVES_COUNT = 5;
static NSUInteger const LIFE_PLUS_INTERVAL_SECONDS = 60*30;
@implementation LifeManager{
    NSTimer* _timer;//增加生命计时器
    NSInteger _lifeCount;//当前生命数
    NSInteger _totalLeftTimeInterval;//离结束一共剩余的时间
    NSDate* _finishPlusDate;//结束生命增加计时时间
}
@synthesize lifeCount = _lifeCount,lifePlusLeftTimeSeconds=_lifePlusLeftTimeSeconds;
-(void)dealloc{
    [self stop];
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}
-(NSString *)description{
    return [NSString stringWithFormat:@"[LifeCount:%d],[plusOneLeftTime:%d],[totalLeftTime:%d]",self.lifeCount,_lifePlusLeftTimeSeconds,_totalLeftTimeInterval];
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
    }
    return self;
}

-(void)start{
    [self correctTime];
    
    _totalLeftTimeInterval = [LifeManager finishTimeInterval];
    _lifeCount = [LifeManager lifeCount];
    
    if (_totalLeftTimeInterval>0) {
        if (_totalLeftTimeInterval>LIFE_PLUS_INTERVAL_SECONDS) {
            _lifePlusLeftTimeSeconds = _totalLeftTimeInterval%LIFE_PLUS_INTERVAL_SECONDS;
        }else{
            _lifePlusLeftTimeSeconds = _totalLeftTimeInterval;
        }
        if (![self isLifeFull]) {
            [self beLackLifeState];
        }
    }else{
        [self updateLifeCount:MAX_LIVES_COUNT];
        [self beFullLifeState];
    }
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(doTimeMinus) userInfo:nil repeats:YES];
}
-(void)stop{
    self.delegate = nil;
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    [LifeManager persistLeaveDate];
    [LifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeInterval];
}
-(void)correctTime{
    NSUInteger finishTimeInterval = (NSUInteger)[LifeManager finishTimeInterval];
    if (![LifeManager isLifeFull]&&finishTimeInterval<=0) {
        finishTimeInterval = (MAX_LIVES_COUNT-self.lifeCount)*LIFE_PLUS_INTERVAL_SECONDS;
        [LifeManager persistFinishDateWithTimeIntervalSinceNow:finishTimeInterval];
        
        _totalLeftTimeInterval = finishTimeInterval;
        if (_totalLeftTimeInterval>LIFE_PLUS_INTERVAL_SECONDS) {
            _lifePlusLeftTimeSeconds = _totalLeftTimeInterval%LIFE_PLUS_INTERVAL_SECONDS;
        }else{
            _lifePlusLeftTimeSeconds = _totalLeftTimeInterval;
        }
    }
}
-(BOOL)isLifeFull{
    return self.lifeCount >= MAX_LIVES_COUNT;
}
+(BOOL)isLifeFull{
//    NSLog(@"%d$$$$$$$$$$$$$$$$$$$$$$$$",[LifeManager lifeCount]);
    return [LifeManager lifeCount] >= MAX_LIVES_COUNT;
}
-(NSInteger)lifeCount{
    if (_timer) {
        return _lifeCount;
    }
    return [LifeManager lifeCount];
}
-(NSInteger)lifePlusLeftTimeSeconds{
    if (self.isLifeFull) {
        _lifePlusLeftTimeSeconds = 0;       
    }
    return _lifePlusLeftTimeSeconds;
}
#pragma mark-  Life and time reset
-(void)lifeMinusOne{
   
    _lifeCount = self.lifeCount;
    if (_totalLeftTimeInterval==0) {
        _totalLeftTimeInterval = [LifeManager finishTimeInterval];
    }
    
    if (_lifeCount==0) {
        return;
    }
    if ([self isLifeFull]) {
        _lifePlusLeftTimeSeconds = LIFE_PLUS_INTERVAL_SECONDS;
        [self beLackLifeState];
    }else{
        
    }
    _lifeCount-=1;
    [self updateLifeCount:_lifeCount];
    _totalLeftTimeInterval+= LIFE_PLUS_INTERVAL_SECONDS;
    [LifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeInterval];
}
-(void)lifePlusOne{
    _lifeCount = self.lifeCount;
    if (_totalLeftTimeInterval==0) {
        _totalLeftTimeInterval = [LifeManager finishTimeInterval];
    }
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
        [self beFullLifeState];
    }else{
        
    }
}
-(void)beFullLifeState{
    _lifePlusLeftTimeSeconds = 0;
    [LifeManager clearFinishDate];
    [LifeManager clearLeaveDate];
}
-(void)beLackLifeState{
    [LifeManager persistFinishDateWithTimeIntervalSinceNow:_totalLeftTimeInterval];
}
-(void)doTimeMinus{
//    NSLog(@"#####%@",self);
    if (_totalLeftTimeInterval<=0) {
        if (self.isLifeFull&&_totalLeftTimeInterval==0) {
            [self beFullLifeState];
        }else if(!self.isLifeFull&&_totalLeftTimeInterval==0){
            [self correctTime];
        }
        return;//-----
    }
    _totalLeftTimeInterval--;
    
    _lifePlusLeftTimeSeconds--;
    if (_lifePlusLeftTimeSeconds<=0) {
        _lifeCount+=1;
        [self updateLifeCount:_lifeCount];
        
        _lifePlusLeftTimeSeconds = [self isLifeFull]?0:LIFE_PLUS_INTERVAL_SECONDS;
    }
    
    if (_delegate&&[_delegate respondsToSelector:@selector(lifeManagerTimerIsWorking:)]) {
        [_delegate lifeManagerTimerIsWorking:_lifePlusLeftTimeSeconds];
    }
}
-(void)updateLifeCount:(NSInteger)count{
    [LifeManager setLifeCount:count];
    if (self.delegate&&[self.delegate respondsToSelector:@selector(lifeManagerLifeChanged:)]) {
        [self.delegate lifeManagerLifeChanged:count];
    }
}
#pragma mark- Persist Values
//
static NSString* const kIsDefaultValuesInitialized = @"kIsDefaultValuesInitialized";
//
static NSString* const kLifeCount = @"kLifeCount";
//
+(BOOL)isDefaultValuesInitialized{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    BOOL isDefaultValuesInitialized = [ud boolForKey:kIsDefaultValuesInitialized];
    if (!isDefaultValuesInitialized) {
        [ud setBool:YES forKey:kIsDefaultValuesInitialized];
        [ud synchronize];
        return NO;
    }else{
        return YES;
    }
}
+(void)initializeDefaultValues{
    NSArray* defaultValues = @[
                                @{kLifeCount:@5}
                                ];
    if (![self isDefaultValuesInitialized]) {

        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        for (NSDictionary* dic in defaultValues) {
            [ud setValue:dic.allValues.firstObject forKey:dic.allKeys.firstObject];
        }
        [ud synchronize];
    }
}
+(void)setLifeCount:(NSInteger)count{
//    NSLog(@"!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!setLifeCount:%d",count);
    if (count<0) {
        return;
    }
    if (count>MAX_LIVES_COUNT) {
        count = MAX_LIVES_COUNT;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:count forKey:kLifeCount];
    [ud synchronize];
}
+(NSUInteger)readLifeCount{
    [self initializeDefaultValues];
    return [[NSUserDefaults standardUserDefaults]integerForKey:kLifeCount];
}
+(NSUInteger)lifeCount{
    NSUInteger lifeCount = [self readLifeCount];//读取进入后台之前的值
    NSTimeInterval leaveTimeInterval = [self leaveTimeInterval];
    
//    NSLog(@"start======#$$#$$#=========life:%d leave:%f",lifeCount, leaveTimeInterval);
    
    if (leaveTimeInterval>LIFE_PLUS_INTERVAL_SECONDS) {
        lifeCount+=floor(leaveTimeInterval/LIFE_PLUS_INTERVAL_SECONDS);//设置增加的生命数
        [self setLifeCount:lifeCount];
        lifeCount = [self readLifeCount];//读取正确的值，因为前面的操作可能超过最大值
    }
    return lifeCount;
}
#pragma mark- Time persist
static NSString* const kFinishDate = @"kFinishDate";//结束时间
+(NSDate*)finishDate{
    NSDate* finishDate = [[NSUserDefaults standardUserDefaults]valueForKey:kFinishDate];
    return finishDate;
}
+(NSTimeInterval)finishTimeInterval{
    NSDate* finishDate = [self finishDate];
    NSTimeInterval left = finishDate?[finishDate timeIntervalSinceNow]:0;
    if (left<=0) {
        left = 0;
    }
    return left;
}
+(void)clearFinishDate{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kFinishDate];
    [ud synchronize];
}
+(void)persistFinishDateWithTimeIntervalSinceNow:(NSTimeInterval)finishTimeInterval{
    if (finishTimeInterval<=0) {
        [self clearFinishDate];
        return;
    }
    NSDate* finishDate = [NSDate dateWithTimeIntervalSinceNow:finishTimeInterval];
//    NSLog(@"%f========%@",finishTimeInterval,finishDate);
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:finishDate forKey:kFinishDate];
    [ud synchronize];
}

static NSString* const kLeaveDate = @"kLeaveDate";//后台时间
+(NSDate*)leaveDate{
    NSDate* date = [[NSUserDefaults standardUserDefaults]valueForKey:kLeaveDate];
    return date;
}
+(NSTimeInterval)leaveTimeInterval{
    NSDate* now = [NSDate date];
    NSDate* leaveDate = [self leaveDate];
    if (leaveDate) {
        [self clearLeaveDate];
        NSTimeInterval leaveTimeInterval = [now timeIntervalSinceDate:leaveDate];
        return leaveTimeInterval>0?leaveTimeInterval:0;
    }else{
        return 0;
    }
}
+(void)clearLeaveDate{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud removeObjectForKey:kLeaveDate];
    [ud synchronize];
}
+(void)persistLeaveDate{
    NSDate* date = [NSDate date];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setValue:date forKey:kLeaveDate];
    [ud synchronize];
}
@end
