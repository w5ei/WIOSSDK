//
//  StringUtil.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-5-8.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "StringEx.h"
#include <CommonCrypto/CommonDigest.h>
#include <CommonCrypto/CommonHMAC.h>
@implementation NSString(WEX)
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
+(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];
    
    return hash;
}
+(NSString *)hmacsha256WithData:(NSString *)data key:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];
    
    return hash;
}
@end
