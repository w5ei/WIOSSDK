//
//  GameManager.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "GameManager.h"
#import "SoundEffect.h"
#import "UIButtonEx.h"
#import "GameData.h"
#define kCurrentGameLevelIndex @"CurrentGameLevelIndex"
@implementation GameManager{
    SoundEffect* _clickSoundEffect;
    SoundEffect* _tagItemEffect;
    SoundEffect* _correctEffect;
    SoundEffect* _correctMoveEffect;
    SoundEffect* _readyAlertEffect;
    SoundEffect* _lifeMinusEffect;
    SoundEffect* _lifeUsedupEffect;
    SoundEffect* _incorrectEffect;
    SoundEffect* _winEffect;
    SoundEffect* _noItemEffect;
    SoundEffect* _findItemEffect;
    SoundEffect* _deleteItemEffect;
    SoundEffect* _guessWordEffect;
    SoundEffect* _removeGuessWordEffect;
    SoundEffect* _levelupEffect;
    SoundEffect* _spinEffect;
    
    GameLevel* _currentGameLevel;
    NSDictionary* _colorsData;
    NSArray* _gameLevels;
}

+(id) sharedInstance{
    static dispatch_once_t pred;
    static GameManager *instance = nil;
    dispatch_once(&pred, ^{
        instance = [[GameManager alloc]init];
    });
    return instance;
}
-(NSArray *)gameLevels{
    if (_gameLevels==nil) {
        _gameLevels = [GameData gameLevels];
    }
    return _gameLevels;
}
-(NSDictionary *)gameData{
    if (_colorsData==nil) {
        _colorsData = [GameData gameData];
    }
    return _colorsData;
}
+(UIColor*)colorOfDifficultyLevel:(NSString*)difficultyLevelName{
    UIColor* color = [UIColor whiteColor];
    if ([difficultyLevelName isEqualToString:@"菜鸟级"]) {
        color = [UIColor color255WithRed:130 green:165 blue:48 alpha:255];//green
    }
    if ([difficultyLevelName isEqualToString:@"初学者"]) {
        color = [UIColor color255WithRed:97 green:178 blue:161 alpha:255];//cyan
    }
    if ([difficultyLevelName isEqualToString:@"入门级"]) {
        color = [UIColor color255WithRed:71 green:140 blue:170 alpha:255];//blue
    }
    if ([difficultyLevelName isEqualToString:@"专家级"]) {
        color = [UIColor color255WithRed:210 green:201 blue:40 alpha:255];//yellow
    }
    if ([difficultyLevelName isEqualToString:@"大师级"]) {
        color = [UIColor color255WithRed:216 green:65 blue:87 alpha:255];//red
    }
    return color;
}

+ (NSUInteger)currentGameLevelIndex{
    //TEST
//    return 41;
    //END TEST
    return [[NSUserDefaults standardUserDefaults]integerForKey:kCurrentGameLevelIndex];
}
-(GameLevel*)currentGameLevel{
    if (_currentGameLevel==nil) {
        _currentGameLevel = [GameLevel gameLevelWithIndex:[GameManager currentGameLevelIndex]];
    }
    return _currentGameLevel;
}
+(void)setGameLevelIndex:(NSInteger)index{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:index forKey:kCurrentGameLevelIndex];
    [ud synchronize];
}
+(GameLevel*)nextGameLevel{
    return [GameLevel gameLevelWithIndex:[GameManager currentGameLevelIndex]+1];
}
-(GameLevel*)gotoNextGameLevel{
    NSUInteger lastLevel = [GameManager currentGameLevelIndex];//如果默认的索引是从0开始
    NSUInteger newLevel =lastLevel +1;
    [GameManager setGameLevelIndex:newLevel];
    //TEST
//    newLevel = 41;
    //END TEST
    _currentGameLevel = [GameLevel gameLevelWithIndex:newLevel];
    return _currentGameLevel;
}
+(void)resetGame{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    //重置道具数量
//    [ud setValue:nil forKey:kIsItemCountInitialized];
//    [ud synchronize];
    //重置关卡
    [ud setInteger:0 forKey:kCurrentGameLevelIndex];
    [ud synchronize];
}
static NSString* const kIsItemCountInitialized = @"kIsItemCountInitialized";
static NSString* const kIsAdsRemoved = @"kIsAdsRemoved";
static NSString* const kShowAdsCount = @"kShowAdsCount";//第次通关累加这个KEY对应的数字，当加到一定大小，显示广告并清零
//#define kIsItemCountInitialized @"kIsItemCountInitialized"
#define kLifeCount @"kLifeCount"
#define kPassItemCount @"kPassItemCount"
#define kFindItemCount @"kFindItemCount"
#define kDeleteItemCount @"kDeleteItemCount"
+(BOOL)isAdsRemoved{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    return [ud boolForKey:kIsAdsRemoved];
}
+(void)setAdsRemoved{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:YES forKey:kIsAdsRemoved];
    [ud synchronize];
}
+(void)setShowAdsCount:(NSUInteger)count{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:count forKey:kShowAdsCount];
    [ud synchronize];
}
+(NSUInteger)showAdsCount{
    NSUInteger count = [[NSUserDefaults standardUserDefaults]integerForKey:kShowAdsCount];
    return count;
}
+(void)updateShowAdsCount{
    NSUInteger count = [self showAdsCount];
    [self setShowAdsCount:count+1];
}
+(BOOL)needShowAds{
    NSUInteger count = [self showAdsCount];;
    if (count>3) {
        [self setShowAdsCount:0];
        return YES;
    }
    return NO;
}
+(BOOL)isItemInitialized{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* isItemInitialized = [ud stringForKey:kIsItemCountInitialized];
    if (isItemInitialized==nil) {
        [ud setValue:@"TAG" forKey:kIsItemCountInitialized];
        [ud synchronize];
        return NO;
    }else{
        return YES;
    }
}
+(void)initializeItemCount{
    if (![GameManager isItemInitialized]) {
        NSUInteger lifeInitCount = 3000;
        NSUInteger findInitCount = 3000;
        NSUInteger deleteInitCount = 3000;
        NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
        [ud setInteger:lifeInitCount forKey:kLifeCount];
        [ud setInteger:findInitCount forKey:kFindItemCount];
        [ud setInteger:deleteInitCount forKey:kDeleteItemCount];
        [ud synchronize];
    }
}
+(void)setLifeCount:(NSInteger)count{
    if (count<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:count forKey:kLifeCount];
    [ud synchronize];
}
+(void)setPassItemCount:(NSInteger)itemCount{
    if (itemCount<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:itemCount forKey:kPassItemCount];
    [ud synchronize];
}
+(void)setFindItemCount:(NSInteger)itemCount{
    if (itemCount<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:itemCount forKey:kFindItemCount];
    [ud synchronize];
}
+(void)setDeleteItemCount:(NSInteger)itemCount{
    if (itemCount<0) {
        return;
    }
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setInteger:itemCount forKey:kDeleteItemCount];
    [ud synchronize];
}
+(NSInteger)lifeCount{
    [GameManager initializeItemCount];
    return [[NSUserDefaults standardUserDefaults]integerForKey:kLifeCount];
}
+(NSUInteger)passItemCount{
    [GameManager initializeItemCount];
    return [[NSUserDefaults standardUserDefaults]integerForKey:kPassItemCount];
}
+(NSUInteger)findItemCount{
    [GameManager initializeItemCount];
    return [[NSUserDefaults standardUserDefaults]integerForKey:kFindItemCount];
}
+(NSUInteger)deleteItemCount{
    [GameManager initializeItemCount];
    return [[NSUserDefaults standardUserDefaults]integerForKey:kDeleteItemCount];
}

#define kIsBackgroundMusicOn @"kIsBackgroundMusicOn_SettingLayer"
#define kIsSoundEffectOn @"kIsSoundEffectOn_SettingLayer"
#define kFirstSettingBgMusicTagStr @"kFirstSettingBackgroundMusicTagStr_SettingLayer"
#define kFirstSettingSoundEffectTagStr @"kFirstSettingSoundEffectTagStr_SettingLayer"
//TODO 如果有账号系统？maybe  initWithUser:
+(BOOL)isBackgroundMusicOn{
    return [self isFirstSettingBgMusic]||[[NSUserDefaults standardUserDefaults]boolForKey:kIsBackgroundMusicOn];
}
+(BOOL)isSoundEffectOn{
    return [self isFirstSettingEffect]||[[NSUserDefaults standardUserDefaults]boolForKey:kIsSoundEffectOn];
}
+(BOOL)isFirstSettingBgMusic{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* firstSettingTagValue = [ud stringForKey:kFirstSettingBgMusicTagStr];
    if (firstSettingTagValue==nil) {
        [ud setValue:@"TAG" forKey:kFirstSettingBgMusicTagStr];
        [ud synchronize];
        [self toggleBackgroundMusic];
        return YES;
    }else{
        return NO;
    }
}
+(BOOL)isFirstSettingEffect{
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    NSString* firstSettingTagValue = [ud stringForKey:kFirstSettingSoundEffectTagStr];
    if (firstSettingTagValue==nil) {
        [ud setValue:@"TAG" forKey:kFirstSettingSoundEffectTagStr];
        [ud synchronize];
        [self toggleSoundEffect];
        return YES;
    }else{
        return NO;
    }
}
+(void)toggleBackgroundMusic{
    BOOL newValue = ![self isBackgroundMusicOn];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:newValue forKey:kIsBackgroundMusicOn];
    [ud synchronize];
    if (newValue) {
        //to play bg music
    }else{
        //to stop bg music
    }
}
+(void)toggleSoundEffect{
    BOOL newValue = ![self isSoundEffectOn];
    NSUserDefaults* ud = [NSUserDefaults standardUserDefaults];
    [ud setBool:newValue forKey:kIsSoundEffectOn];
    [ud synchronize];
}

#pragma mark- SoundEffect
-(void)playClickEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_clickSoundEffect==nil)_clickSoundEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Click" ofType:@"wav"]];
    [_clickSoundEffect play];
}
-(void)playLifeUsedupEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_lifeUsedupEffect==nil)_lifeUsedupEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"time_out" ofType:@"caf"]];
    [_lifeUsedupEffect play];
}
-(void)playTagItemEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_tagItemEffect==nil)_tagItemEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shake_prompt" ofType:@"aif"]];
    [_tagItemEffect play];
}
-(void)playLifeMinusEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_lifeMinusEffect==nil)_lifeMinusEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color_woosh" ofType:@"caf"]];
    [_lifeMinusEffect play];
}
-(void)playReadyAlertEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_readyAlertEffect==nil)_readyAlertEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"alert" ofType:@"caf"]];
    [_readyAlertEffect play];
}
-(void)playCorrectEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    
    if (_correctMoveEffect==nil) {
        _correctMoveEffect = [[SoundEffect alloc]initWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"color_move" ofType:@"caf"]];
    }
    [_correctMoveEffect play];
    
    if(_correctEffect==nil)_correctEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color_right" ofType:@"caf"]];
    [_correctEffect play];
}
-(void)playIncorrectEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_incorrectEffect==nil)_incorrectEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"color_fail" ofType:@"caf"]];
    [_incorrectEffect play];
}
-(void)playWinEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_winEffect==nil)_winEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"win" ofType:@"aif"]];
    [_winEffect play];
}
-(void)playNoItemEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_noItemEffect==nil)_noItemEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"tienda_no" ofType:@"caf"]];
    [_noItemEffect play];
}
-(void)playFindItemEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_findItemEffect==nil)_findItemEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"reveal_letter" ofType:@"aif"]];
    [_findItemEffect play];
}
-(void)playDeleteItemEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }//martillo.caf
    if(_deleteItemEffect==nil)_deleteItemEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"martillo" ofType:@"caf"]];
    [_deleteItemEffect play];
}
-(void)playGuessWordEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_guessWordEffect==nil)_guessWordEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"click-up" ofType:@"aif"]];
    [_guessWordEffect play];
}
-(void)playRemoveGuessWordItemEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_removeGuessWordEffect==nil)_removeGuessWordEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"click-down" ofType:@"aif"]];
    [_removeGuessWordEffect play];
}
-(void)playLevelupEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_levelupEffect==nil)_levelupEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"level_up" ofType:@"caf"]];
    [_levelupEffect play];
}
-(void)playSpinEffect{
    if (![GameManager isSoundEffectOn]) {
        return;
    }
    if(_spinEffect==nil)_spinEffect = [[SoundEffect alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"spin" ofType:@"caf"]];
    [_spinEffect play];
}

@end
@implementation UIButton (ClikEffectEX)
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    if(![self isKindOfClass:[UIButtonEx class]])[[GameManager sharedInstance] playClickEffect];
//}
@end
@implementation UITableViewCell (ClikEffectEX)
//-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
//    [super touchesBegan:touches withEvent:event];
//    [[GameManager sharedInstance] playClickEffect];
//}
@end