//
//  StringUtil.h
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-5-8.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StringUtil : NSObject
//-----
+(NSString*)convertHanziToPinyin:(NSString*)hanzi;
+(NSString*)convertHanziToPinyinInitials:(NSString *)hanzi;
+(void)convertHanzi:(NSString*)hanzi toPinyin:(NSString**)pinyin andPinyinInitials:(NSString**)pinyinInitials;
@end
