//
//  PicUtil.m
//  WAYNE_IOS_SDK
//
//  Created by wayne green on 12-3-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "ImageUtil.h"
#import <QuartzCore/QuartzCore.h>
@implementation ImageUtil
//默认按宽适应,forceHeight==YES 先按宽适应再按高适应
+(UIImage*) scaleImage:(UIImage*)image width:(CGFloat)width height:(CGFloat) height forceHeight:(BOOL)forceHeight{
    CGFloat scale = width/image.size.width;
    CGFloat w = width;
    CGFloat h = image.size.height*scale;
    if (h<height&&forceHeight) {
        scale = height/h;
        w*=scale;
        h*=scale;
    }
    
    CGFloat y = -(h-height)/2;
    CGFloat x = -(w-width)/2;
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(CGSizeMake(width, height),NO, 2);
    else
        UIGraphicsBeginImageContext(CGSizeMake(width, height));
 
    [image drawInRect:CGRectMake(x, y, w, h)];
    UIImage* image_ = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image_;
}

+ (UIImage*)cutImage:(UIImage*)image withWidth:(CGFloat)width_ andHeight:(CGFloat)height_
{
    //创建背景IMAGE并设置
    UIView* frameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width_, height_)];
    UIImageView* imageView = [[UIImageView alloc]initWithImage:image];
    CGRect frame  = imageView.frame;
    //先按宽适应 
    CGFloat scale = width_/frame.size.width;
    frame.size.width*= scale;
    frame.size.height*=scale;
    //如果高小了再扩大
    if(frame.size.height<height_){
        scale = height_/frame.size.height;
        frame.size.width*= scale;
        frame.size.height*=scale;
        //因为宽大了,所以移动到中心
        frame.origin.x -= (frame.size.width-width_)/2;
    }else{
        //因为高大了,所以移动到中心
        frame.origin.y -= (frame.size.height-height_)/2;
    }
    imageView.frame = frame;
    [frameView addSubview:imageView];
    
    UIImage* img = [ImageUtil captureImageFromView:frameView withMinWidth:frameView.frame.size.width];

    return img;
}

+ (UIImage*)cutAndChangeImage:(UIImage*)image withWidth:(CGFloat)width_ andHeight:(CGFloat)height_
{
    //创建背景IMAGE并设置
    UIView* frameView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, width_,height_)];
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:frameView.frame];
    [imageView setImage:image];
    CGRect frame  = imageView.frame;
    //先按宽适应 
    CGFloat scale = width_/frame.size.width;
    frame.size.width*= scale;
    frame.size.height*=scale;
    //如果高小了再扩大
    if(frame.size.height<height_){
        scale = height_/frame.size.height;
        frame.size.width*= scale;
        frame.size.height*=scale;
        //因为宽大了,所以移动到中心
        frame.origin.x -= (frame.size.width-width_)/2;
    }else{
        //因为高大了,所以移动到中心
        frame.origin.y -= (frame.size.height-height_)/2;
    }
    imageView.frame = frame;
    [frameView addSubview:imageView];
    
    UIImage* img = [ImageUtil captureImageFromView:frameView withMinWidth:frameView.frame.size.width];
    
    return img;
}

+ (UIImage*)createThumbnail:(UIImage*)image
{
    CGFloat thumbnailSize = 74;
    return [ImageUtil cutImage:image withWidth:thumbnailSize andHeight:thumbnailSize];
}
+ (UIImage*)resizeImage:(UIImage*)image toWidth:(NSInteger)width height:(NSInteger)height
{
    // Create a graphics context with the target size
    // On iOS 4 and later, use UIGraphicsBeginImageContextWithOptions to take the scale into consideration
    // On iOS prior to 4, fall back to use UIGraphicsBeginImageContext
    CGSize size = CGSizeMake(width, height);
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
    else
        UIGraphicsBeginImageContext(size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context because UIKit coordinate system is upside down to Quartz coordinate system
    CGContextTranslateCTM(context, 0.0, height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Draw the original image to the context
    CGContextSetBlendMode(context, kCGBlendModeCopy);
    CGContextDrawImage(context, CGRectMake(0.0, 0.0, width, height), image.CGImage);
    
    // Retrieve the UIImage from the current context
    UIImage *imageOut = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return imageOut;
}
//通过VIEW生成图片
+(UIImage*)captureImageFromView: (UIView *)theView withMinWidth:(CGFloat)width{
    CGRect rect = theView.frame;
    CGFloat scale = width/2/rect.size.width;
    
    if (NULL != &UIGraphicsBeginImageContextWithOptions)
        UIGraphicsBeginImageContextWithOptions(rect.size,YES, 2);
    else
        UIGraphicsBeginImageContext(rect.size);

    CGContextRef context =UIGraphicsGetCurrentContext();
    
    [theView.layer renderInContext:context];
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    img = [self resizeImage:img toWidth:rect.size.width*scale height:rect.size.height*scale];
    //UIImageWriteToSavedPhotosAlbum(img, nil, nil, nil)
    //[UIImagePNGRepresentation(img) writeToFile:@"A PATH" atomically:YES];
    return img;
}
@end
@implementation UIImage (TintColor)

+ (UIImage *)imageNamed:(NSString*)name color:(UIColor *)color{
    UIImage *image = [UIImage imageNamed:name];
    image = [image imageTintedWithColor:color];
    return image;
}
+ (UIImage *)imageWithColor:(UIColor *)color andSize:(CGSize)size;
{
    UIImage *img = nil;
    
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context,
                                   color.CGColor);
    CGContextFillRect(context, rect);
    img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return img;
}
- (UIImage *)imageMultiplyWithColor:(UIColor *)color
{
	if (color) {
		// Construct new image the same size as this one.
		UIImage *image;
		UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
		CGRect rect = CGRectZero;
		rect.size = [self size];
        
		// tint the image
		[self drawInRect:rect];
		[color set];
		UIRectFillUsingBlendMode(rect, kCGBlendModeColorBurn);
        
		// restore alpha channel
		[self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
		return image;
	}
    
	return self;
    
}
- (UIImage *)imageTintedWithColor:(UIColor *)color
{
	if (color) {
		// Construct new image the same size as this one.
		UIImage *image;
		UIGraphicsBeginImageContextWithOptions([self size], NO, 0.0); // 0.0 for scale means "scale for device's main screen".
		CGRect rect = CGRectZero;
		rect.size = [self size];
        
		// tint the image
		[self drawInRect:rect];
		[color set];
		UIRectFillUsingBlendMode(rect, kCGBlendModeColor);
        
		// restore alpha channel
		[self drawInRect:rect blendMode:kCGBlendModeDestinationIn alpha:1.0f];
        
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
        
		return image;
	}
    
	return self;
    
}
@end