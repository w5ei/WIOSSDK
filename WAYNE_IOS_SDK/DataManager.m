//
//  DataManager.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-21.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "DataManager.h"
/*
 Thonburi,
 "Snell Roundhand",
 "Academy Engraved LET",
 "Marker Felt",
 "Geeza Pro",
 "Arial Rounded MT Bold",
 "Trebuchet MS",
 Arial,
 Marion,
 "Gurmukhi MN",
 "Malayalam Sangam MN",
 "Bradley Hand",
 "Kannada Sangam MN",
 "Bodoni 72 Oldstyle",
 Cochin,
 "Sinhala Sangam MN",
 "Hiragino Kaku Gothic ProN",
 Papyrus,
 Verdana,
 "Zapf Dingbats",
 Courier,
 "Hoefler Text",
 "Euphemia UCAS",
 Helvetica,
 "Hiragino Mincho ProN",
 "Bodoni Ornaments",
 "Apple Color Emoji",
 Optima,
 "Gujarati Sangam MN",
 "Devanagari Sangam MN",
 "Times New Roman",
 Kailasa,
 "Telugu Sangam MN",
 "Heiti SC",
 "Apple SD Gothic Neo",
 Futura,
 "Bodoni 72",
 Baskerville,
 "Chalkboard SE",
 "Heiti TC",
 Copperplate,
 "Party LET",
 "American Typewriter",
 "Bangla Sangam MN",
 Noteworthy,
 Zapfino,
 "Tamil Sangam MN",
 "DB LCD Temp",
 "Arial Hebrew",
 Chalkduster,
 Georgia,
 "Helvetica Neue",
 "Gill Sans",
 Palatino,
 "Courier New",
 "Oriya Sangam MN",
 Didot,
 "Bodoni 72 Smallcaps"
 */
@implementation DataManager
#pragma Bundle Info.plist
+(NSString*)appVersion{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
    return version;
}
+(NSString*)appId{
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
    return version;
}
@end
