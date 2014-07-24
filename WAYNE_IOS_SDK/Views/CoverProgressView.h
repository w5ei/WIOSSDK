//
//  ProgressView.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-21.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum {
    CoverProgressColorDefault,
    CoverProgressColorYellow,
    CoverProgressColorGreen,
    CoverProgressColorBlue,
    CoverProgressColorCyan,
    CoverProgressColorMagenta
}CoverProgressColor;
@interface CoverProgressView : UIView
@property(nonatomic,assign)float progress;//0~1
@property(nonatomic,assign)CoverProgressColor color;
@property(nonatomic,strong)UIImage* coverImage;
@property(nonatomic,strong)UIImage* progressImage;
@property(nonatomic,readonly)UIImageView* progressImageView;
//-----
-(void)setProgress:(float)progress progressColor:(CoverProgressColor)color;
+(CoverProgressColor)colorOfDifficultyLevel:(NSString*)difficultyLevelName;
@end
