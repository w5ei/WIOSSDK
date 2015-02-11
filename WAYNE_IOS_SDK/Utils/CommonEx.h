//
//  CommonEx.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-29.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//Update on 13-10-18

#import <Foundation/Foundation.h>

@interface CommonEx : NSObject
+(int)indexFromCurrentIndex:(int)currentIndex stepValue:(int)stepValue maxIndexValue:(int)maxIndexValue;
+(BOOL)isNewVersion;
@end

#pragma mark- NSArray
@interface NSArray (NSReallyContainArray)
-(BOOL)reallyContainsObject:(id)anObject;
-(NSUInteger)realIndexOfObject:(id)anObject;
-(NSMutableArray*)removeObjects:(NSArray *)otherArray;
@end
@interface NSMutableArray (NSReallyRemoveArray)
-(void)reallyRemoveObject:(id)anObject;
@end
@interface NSArray (RandomSubArray)
-(NSArray*)randomSubArrayWithCount:(NSUInteger)count;
-(NSArray*)randomSubArrayWithRangeLenght:(NSUInteger)lenght;
@end
@interface NSArray (RandomIndexArray)
-(NSMutableArray*)randomIndexArray;
@end
#pragma mark- UIView
@interface UIView (RemoveAllSubviews)
-(void)removeAllSubviews;
@end
#pragma mark- UIColor
@interface UIColor (GRB255)
+(UIColor *)color255WithRed:(unsigned char)red green:(unsigned char)green blue:(unsigned char)blue alpha:(unsigned char)alpha;
@end

@interface UIViewController (fitIOS6_7)
-(void)fitIOS6_7;
@end
@interface NSObject (WEX)
-(NSString*)simpleClassName;
@end