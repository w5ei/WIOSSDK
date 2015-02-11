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
+(NSString *)hmacmd5:(NSString *)data secret:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [data cStringUsingEncoding:NSASCIIStringEncoding];
    
    unsigned char cHMAC[CC_MD5_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgMD5, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    
    NSString *hash = [HMAC base64Encoding];
    
    return hash;
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

@implementation NSString (SubStringOneByOne)
+(NSMutableArray*)subStringOneByOne:(NSString*)str{
    return [str subStringOneByOne];
}
-(NSString*)i18n{
    return NSLocalizedString(self, nil);
}
-(NSMutableArray*)subStringOneByOne{
    NSMutableArray* array = [NSMutableArray arrayWithCapacity:self.length];
    for (NSUInteger i=0; i<self.length; i++) {
        [array addObject:
         [self substringWithRange:NSMakeRange(i, 1)]];
    }
    return array;
}

@end
@implementation NSString (RegularExpression)
-(BOOL)isValidEmailAdress{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [predicate evaluateWithObject:self];
}
-(BOOL)isValidPhoneNumber{
    NSString *phoneNumberRegex = @"[0-9]{11}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneNumberRegex];
    return [predicate evaluateWithObject:self];
}
-(NSUInteger)byteLength
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSData* da = [self dataUsingEncoding:enc];
    return [da length];
}
- (NSString *) md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5( cStr, (unsigned int) strlen(cStr), result);
    return [NSString stringWithFormat:
			@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
			result[0], result[1], result[2], result[3],
			result[4], result[5], result[6], result[7],
			result[8], result[9], result[10], result[11],
			result[12], result[13], result[14], result[15]
			];
}
-(BOOL)containsChineseCharacter{
    for (int i=0; i<self.length; i++) {
        unichar character = [self characterAtIndex:i];
        if (0x4e00 < character  && character < 0x9fff) {
            return true;
        }
    }
    return false;
}
@end
@implementation NSString (URL)
-(NSString *)urlDecodeFormat
{
    NSString *result = [(NSString *)self stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    result = [result stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    return result;
}
- (NSString*) urlEncodedString {
    
    CFStringRef encodedCFString = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                          (__bridge CFStringRef) self,
                                                                          nil,
                                                                          CFSTR("?!@#$^&%*+,:;='\"`<>()[]{}/\\| "),
                                                                          kCFStringEncodingUTF8);
    
    NSString *encodedString = [[NSString alloc] initWithString:(__bridge_transfer NSString*) encodedCFString];
    
    if(!encodedString)
        encodedString = @"";
    
    return encodedString;
}

@end