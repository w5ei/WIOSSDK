//
//  StringUtil.h
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-5-8.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString(WEX)
//-----
+(NSString*)convertHanziToPinyin:(NSString*)hanzi;
+(NSString*)convertHanziToPinyinInitials:(NSString *)hanzi;
+(void)convertHanzi:(NSString*)hanzi toPinyin:(NSString**)pinyin andPinyinInitials:(NSString**)pinyinInitials;
+(NSString *)hmacmd5:(NSString *)data secret:(NSString *)key;
+(NSString *)hmacsha1:(NSString *)data secret:(NSString *)key;
+(NSString *)hmacsha256WithData:(NSString *)data key:(NSString *)key;
@end

@interface NSString (SubStringOneByOne)
-(NSMutableArray*)subStringOneByOne;
+(NSMutableArray*)subStringOneByOne:(NSString*)str;
-(NSString*)i18n;
@end
@interface NSString (RegularExpression)
-(NSUInteger)byteLength;
-(BOOL)isValidEmailAdress;
-(BOOL)isValidPhoneNumber;
-(NSString *) md5;
-(BOOL)containsChineseCharacter;
@end
@interface NSString (URL)
-(NSString *)urlDecodeFormat;
- (NSString*) urlEncodedString;
@end