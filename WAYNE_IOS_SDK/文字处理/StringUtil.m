//
//  StringUtil.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-5-8.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "StringUtil.h"

@implementation StringUtil
+(void)convertHanzi:(NSString*)hanzi toPinyin:(NSString**)pinyin andPinyinInitials:(NSString**)pinyinInitials{
    NSMutableString* py = [NSMutableString string];
    NSMutableString* pyi = [NSMutableString string];
    for (NSUInteger i=0; i<hanzi.length; i++) {
        NSString* str = [hanzi substringWithRange:NSMakeRange(i, 1)];
        NSString* pyStr = [self convertHanziToPinyin:str];
        [pyi appendString:[pyStr substringToIndex:1]];
        [py appendString:pyStr];
    }
    *pinyin = py;
    *pinyinInitials = pyi;
}
+(NSString*)convertHanziToPinyin:(NSString*)hanzi{
    //其实日文韩文也是可以转化的
    NSMutableString * result = [NSMutableString stringWithString:hanzi];
    if (CFStringTransform((__bridge CFMutableStringRef)result, 0, kCFStringTransformMandarinLatin, NO)) {//先转化为带声调的拼音
        if (CFStringTransform((__bridge CFMutableStringRef)result, 0, kCFStringTransformStripDiacritics, NO)) {
        }
    }
    return result;
}
+(NSString*)convertHanziToPinyinInitials:(NSString *)hanzi{
    NSMutableString* result = [NSMutableString string];
    for (NSUInteger i=0; i<hanzi.length; i++) {
        NSString* str = [hanzi substringWithRange:NSMakeRange(i, 1)];
        NSString* pinyin = [self convertHanziToPinyin:str];
        [result appendString:[pinyin substringToIndex:1]];
    }
    return result;
}
@end
