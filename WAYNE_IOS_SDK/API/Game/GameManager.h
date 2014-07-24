//
//  GameManager.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>
#define isPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#import "GameLevel.h"
#import "CommonEx.h"
@interface GameManager : NSObject
+(id) sharedInstance;
-(void)playClickEffect;
-(void)playLifeUsedupEffect;
-(void)playReadyAlertEffect;
-(void)playLifeMinusEffect;
-(void)playTagItemEffect;
-(void)playCorrectEffect;
-(void)playIncorrectEffect;
-(void)playWinEffect;
-(void)playNoItemEffect;
-(void)playFindItemEffect;
-(void)playDeleteItemEffect;
-(void)playGuessWordEffect;
-(void)playRemoveGuessWordItemEffect;
-(void)playLevelupEffect;
-(void)playSpinEffect;

-(NSArray*)gameLevels;
-(NSDictionary*)gameData;
+(UIColor*)colorOfDifficultyLevel:(NSString*)difficultyLevelName;

+(NSUInteger)currentGameLevelIndex;//取得当前关卡索引
+(void)setGameLevelIndex:(NSInteger)index;
+(GameLevel*)nextGameLevel;//取得下一关卡
-(GameLevel*)currentGameLevel;
-(GameLevel*)gotoNextGameLevel;//设置关卡进度到下一关
+(void)resetGame;
#pragma mark- setting 
+(BOOL)isAdsRemoved;
+(void)setAdsRemoved;
+(void)updateShowAdsCount;
+(BOOL)needShowAds;

+(BOOL)isSoundEffectOn;
+(void)toggleSoundEffect;
#pragma mark- life and item count
+(void)setLifeCount:(NSInteger)count;
+(void)setPassItemCount:(NSInteger)itemCount;
+(void)setFindItemCount:(NSInteger)itemCount;
+(void)setDeleteItemCount:(NSInteger)itemCount;
+(NSInteger)lifeCount;
+(NSUInteger)passItemCount;
+(NSUInteger)findItemCount;
+(NSUInteger)deleteItemCount;

@end
