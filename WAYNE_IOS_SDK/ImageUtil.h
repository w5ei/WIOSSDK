//
//  PicUtil.h
//  WAYNE_IOS_SDK
//
//  Created by wayne green on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface ImageUtil : NSObject
+(UIImage*)captureImageFromView: (UIView *)theView withMinWidth:(CGFloat)width;
+(UIImage*) scaleImage:(UIImage*)image width:(CGFloat)width height:(CGFloat) height forceHeight:(BOOL)forceHeight;
+(UIImage*)cutImage:(UIImage*)image withWidth:(CGFloat)width_ andHeight:(CGFloat)height_;
+(UIImage*)cutAndChangeImage:(UIImage*)image withWidth:(CGFloat)width_ andHeight:(CGFloat)height_;
+(UIImage*)createThumbnail:(UIImage*)image;
@end
@interface UIImage (TintColor)
+ (UIImage *)imageNamed:(NSString*)name color:(UIColor *)color;
- (UIImage *)imageTintedWithColor:(UIColor *)color;
- (UIImage *)imageMultiplyWithColor:(UIColor *)color;
@end