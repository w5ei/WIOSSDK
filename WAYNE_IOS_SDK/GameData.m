//
//  GameData.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-14.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "GameData.h"

@implementation GameData
+(NSArray*)gameLevels{
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"game_levels" ofType:@"json"]] options:kNilOptions error:nil];
    //TEST LEVELS
    return [[NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"game_data" ofType:@"json"] ] options:kNilOptions error:nil]valueForKey:@"testLevels"];
}
+(NSDictionary*)gameData{
    return [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:[[NSBundle mainBundle]pathForResource:@"game_data" ofType:@"json"]] options:kNilOptions error:nil];
}
@end
