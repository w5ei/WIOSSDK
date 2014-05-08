//
//  CommonEx.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-29.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "CommonEx.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CommonEx

@end
#pragma mark- NSString
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
#pragma mark- NSArray
@implementation NSArray(NSReallyContainArray)
-(BOOL)reallyContainsObject:(id)anObject{
    for (id mObj in self) {
        if (mObj == anObject) {
            return YES;
        }
    }
    return NO;
}
-(NSUInteger)realIndexOfObject:(id)anObject{
    NSUInteger index = 0;
    for (id child in self) {
        if (child==anObject) {
            return index;
        }else{
            index++;
        }
    }
    return index+1;//if(index>self.count) means do not contain but should do contain check first
}
/**用系统提供的方法也可以实现
 - (NSArray *)arrayByAddingObject:(id)anObject;
 - (NSArray *)arrayByAddingObjectsFromArray:(NSArray *)otherArray;
 */
-(NSMutableArray*)removeObjects:(NSArray *)otherArray{
    NSMutableArray* array = [NSMutableArray arrayWithArray:self];
    if (otherArray==nil||otherArray.count==0) {
        return array;
    }
    [array removeObjectsInArray:otherArray];
    return array;
}
@end

@implementation NSMutableArray (NSReallyRemoveArray)
-(void)reallyRemoveObject:(id)anObject{
    NSMutableArray* newArray = [NSMutableArray array];
    for (id child in self) {
        if (child!=anObject) {
            [newArray addObject:child];
        }
    }
    [self removeAllObjects];
    [self addObjectsFromArray:newArray];
}
@end

@implementation NSArray (RandomIndexArray)
-(NSMutableArray*)randomIndexArray{
    NSMutableArray* randomArray = [NSMutableArray arrayWithArray:self];
    if (self.count<=1) {
        return randomArray;
    }
    
    for(NSUInteger i=0;i<self.count/2;i++){
        int rand = arc4random() % (self.count);
        NSString* reindexOne = [randomArray objectAtIndex:rand];
        [randomArray removeObjectAtIndex:rand];
        [randomArray addObject:reindexOne];
    }
    return randomArray;
}
@end
@implementation NSArray (RandomSubArray)
-(NSArray*)randomSubArrayWithCount:(NSUInteger)count{//先乱序再取子组(重点在乱序)
    if (self.count<=1) return self;
    NSMutableArray* subArray = [self randomIndexArray];
    if (count>=self.count) {
        return subArray;
    }
    if (count<=1) {
        return self.lastObject;
    }
    return [subArray subarrayWithRange:NSMakeRange(0, count)];
}
-(NSArray*)randomSubArrayWithRangeLenght:(NSUInteger)lenght{//随机取子组（重点在速度，所不做乱序）
    if (self.count<=1) return self;
    if (lenght>=self.count) {
        return self;
    }
    if (lenght<=1) {
        return self.lastObject;
    }
    NSUInteger randomLoc = arc4random()%(self.count-lenght);
    return [self subarrayWithRange:NSMakeRange(randomLoc, lenght)];
}
@end

#pragma mark- UIView
@implementation UIView(RemoveAllSubviews)
-(void)removeAllSubviews{
    for (id subview in self.subviews) {
        [subview removeFromSuperview];
    }
}
@end

#pragma mark- UIColor
@implementation UIColor (GRB255)
+(UIColor *)color255WithRed:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue alpha:(unsigned char)alpha{
    return [UIColor colorWithRed:red/255.0f green:green/255.0f  blue:blue/255.0f  alpha:alpha/255.0f ];
}
@end
