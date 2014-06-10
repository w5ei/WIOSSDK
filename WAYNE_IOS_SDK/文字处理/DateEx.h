//
//  DateUtil.h
//  WAYNE_IOS_SDK
//
//  Created by Wayne on 14-6-10.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (WEX)
-(NSString*)iso8601Format;
+(id)dateWithISO8601String:(NSString*)str;
@end
