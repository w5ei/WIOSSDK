//
//  GameLevel.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "GameLevel.h"
#import "GameManager.h"
#import "GameData.h"
@implementation GameLevel{
    id _gameLevelDic;
    NSMutableArray* _tagImageNames;
}
@synthesize tagStrings = _tagStrings;
//@synthesize userLevel = _userLevel;
- (id)initWithIndex:(NSUInteger)levelIndex
{
    self = [super init];
    if (self) {
        NSArray* allLevels = [[GameManager sharedInstance] gameLevels];
        
        if ([NSJSONSerialization isValidJSONObject:allLevels]) {
            if (levelIndex+1>allLevels.count) {
                return nil;
            }
            _gameLevelDic = [allLevels objectAtIndex:levelIndex];
        }else{
            return nil;
        }
        
        _brandName = [_gameLevelDic valueForKey:@"brand"];
        _modelName = [_gameLevelDic valueForKey:@"model"];
        _imageName = [NSString stringWithFormat:@"%@_%@.png",_brandName,_modelName];
        _answerStrings = @[_brandName,_modelName];
        _mixBrandNames = [[_gameLevelDic valueForKey:@"brandoption"]componentsSeparatedByString:@","];
        _mixBrandNames=[_mixBrandNames removeObjects:@[@""]];
        
        _mixModelNames = [[_gameLevelDic valueForKey:@"modeloption"]componentsSeparatedByString:@","];
        _mixModelNames=[_mixModelNames removeObjects:@[@""]];
//        NSLog(@"%@------%@",_mixBrandNames,_mixModelNames);
        _userLevel = [[_gameLevelDic valueForKey:@"userLevel"]integerValue];
        _userLevelProgress = [[_gameLevelDic valueForKey:@"userLevelProgress"] floatValue];
        _difficultyLevel = [_gameLevelDic valueForKey:@"difficultyLevel"];
//        _findItemCount = [[_gameLevelJsonObj valueForKey:@"hit"]integerValue];
//        _deleteItemCount = [[_gameLevelJsonObj valueForKey:@"delete"]integerValue];
    }
    return self;
}
-(NSUInteger)levelIndex{
    return [GameManager currentGameLevelIndex];
}
-(NSArray *)tagStrings{
    if (_tagStrings) {
        [_tagStrings removeAllObjects];
    }else{
        _tagStrings = [NSMutableArray array];
    }
    
    NSUInteger maxBrandCount = 7;
    NSUInteger maxModelCount = 7;
    
    //读取所有数据（因为型号数据过大，所以随机取子组）
    NSArray* mixBrands = [[[GameManager sharedInstance] gameData] valueForKey:@"brands"];
    NSArray* mixModels = [[[[GameManager sharedInstance] gameData] valueForKey:@"models"]randomSubArrayWithRangeLenght:50];
    
    //从数据中除去答案数据并取正确大小的子组
    mixBrands = [mixBrands removeObjects:self.answerStrings];
    mixBrands = [mixBrands removeObjects:self.mixBrandNames];
    mixBrands = [mixBrands randomSubArrayWithCount:(maxBrandCount-self.mixBrandNames.count)];
    
    mixModels = [mixModels removeObjects:self.mixModelNames];
    mixModels = [mixModels removeObjects:self.answerStrings];
    mixModels = [mixModels randomSubArrayWithCount:(maxModelCount-self.mixModelNames.count)];
    
    //将答案数据与之混合并乱序
    [_tagStrings addObjectsFromArray:mixBrands];
    [_tagStrings addObjectsFromArray:mixModels];
    [_tagStrings addObjectsFromArray:self.mixModelNames];
    [_tagStrings addObjectsFromArray:self.mixBrandNames];
    [_tagStrings addObjectsFromArray:self.answerStrings];
    _tagStrings = [_tagStrings randomIndexArray];
    
    return _tagStrings;
}
/*5s
 10s
 30s
 60s
 300s
 900s*/
-(NSTimeInterval)waitingTimeSecs{
    NSTimeInterval time = 0;
    NSUInteger level = self.levelIndex+1;
    if (level<=20) {
        time = 5;
    }
    if (level>20&&level<=49) {
        time = 10;
    }
    if (level>49&&level<=99) {
        time = 30;
    }
    if (level>99&&level<=199) {
        time = 60;
    }
    if (level>199&&level<=299) {
        time = 300;
    }
    if (level>299) {
        time = 900;
    }
//    NSString*difficultyLevelName = self.difficultyLevel;
//    if ([difficultyLevelName isEqualToString:@"小菜鸟"]) {
//        time = 5;
//    }
//    if ([difficultyLevelName isEqualToString:@"初学者"]) {
//        time = 30;
//    }
//    if ([difficultyLevelName isEqualToString:@"入门级"]) {
//        time = 60;
//    }
//    if ([difficultyLevelName isEqualToString:@"专家级"]) {
//        time = 300;
//    }
//    if ([difficultyLevelName isEqualToString:@"大师级"]) {
//        time = 900;
//    }
    return time;
}

+(GameLevel*)gameLevelWithIndex:(NSUInteger)levelIndex{
    return [[GameLevel alloc]initWithIndex:levelIndex];
}
@end