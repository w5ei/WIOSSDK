//
//  NumberView.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-26.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NumberView : UIView
@property(nonatomic,readonly)UILabel* numberLabel;
//-----
-(void)setNumber:(int)num;
-(void)setBackgroundImage:(UIImage*)img marginTop:(CGFloat)top marginLeft:(CGFloat)left;
@end
