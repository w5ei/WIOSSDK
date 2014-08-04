//
//  CommonEx.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-29.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "CommonEx.h"
#import <CommonCrypto/CommonDigest.h>
NSString *const kLastVersionString = @"kLastVersionString";
@implementation CommonEx
+(int)indexFromCurrentIndex:(int)currentIndex stepValue:(int)stepValue maxIndexValue:(int)maxIndexValue{
    int nextIndex = currentIndex+stepValue;
    if (nextIndex > maxIndexValue) {
        nextIndex = nextIndex - (maxIndexValue+1);
    }else if(nextIndex < 0){
        nextIndex = (maxIndexValue+1) - abs(nextIndex);
    }
    return nextIndex;
}
+(BOOL)isNewVersion{
    NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
    BOOL isNewVersion = YES;
    NSString *value = [ud stringForKey:kLastVersionString];
    NSString *currentVersionString = [[[NSBundle mainBundle] infoDictionary] objectForKey:(__bridge NSString*)kCFBundleVersionKey];
    if (value==nil) {
        [ud setObject:currentVersionString forKey:kLastVersionString];
        [ud synchronize];
    }else{
        if ([currentVersionString isEqual:value]) {
            isNewVersion = NO;
        }else{
            isNewVersion = YES;
            [ud setObject:currentVersionString forKey:kLastVersionString];
            [ud synchronize];
        }
    }
    return isNewVersion;
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
@implementation UIViewController(fitIOS6_7)
-(void)fitIOS6_7{
    if([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0){
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}
@end