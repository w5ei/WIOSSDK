//
//  GameLevel.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GameLevel : NSObject
@property(nonatomic,assign,readonly)NSUInteger levelIndex;//关卡索引
@property(nonatomic,assign,readonly)NSUInteger userLevel;//用户等级
@property(nonatomic,strong,readonly)NSString* difficultyLevel;//难度等级
@property(nonatomic,assign,readonly)CGFloat userLevelProgress;//用户等级当前进度
@property(nonatomic,readonly)NSString* brandName;//品牌名称
@property(nonatomic,readonly)NSString* modelName;//型号名称
@property(nonatomic,readonly)NSString* imageName;//答案图片的名称（brandName_modelName.png）
@property(nonatomic,strong,readonly)NSArray* answerStrings;//@[brandName,modelName]
@property(nonatomic,strong,readonly)NSArray* mixBrandNames;//参与提示品牌用的（由程序生成）
@property(nonatomic,strong,readonly)NSArray* mixModelNames;//参与提示型号用的（由程序生成）
@property(nonatomic,strong,readonly)NSMutableArray* tagStrings;//所有提示文字们（其中包含答案）

@property(nonatomic,assign)NSUInteger findItemCount;
@property(nonatomic,assign)NSUInteger deleteItemCount;

@property(nonatomic,assign,readonly)NSTimeInterval waitingTimeSecs;
//-----
+(GameLevel*)gameLevelWithIndex:(NSUInteger)levelIndex;
@end