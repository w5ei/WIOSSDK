//
//  WStepper.h
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-7-15.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WStepper : UIControl
@property(nonatomic,getter=isContinuous) BOOL continuous; // if YES, value change events are sent any time the value changes during interaction. default = YES
@property(nonatomic) BOOL autorepeat;                     // if YES, press & hold repeatedly alters value. default = YES
@property(nonatomic) BOOL wraps;                          // if YES, value wraps from min <-> max. default = NO

@property(nonatomic) double value;                        // default is 0. sends UIControlEventValueChanged. clamped to min/max
@property(nonatomic) double minimumValue;                 // default 0. must be less than maximumValue
@property(nonatomic) double maximumValue;                 // default 100. must be greater than minimumValue
@property(nonatomic) double stepValue;

@property(nonatomic,strong,readonly)UIButton *minusButton;
@property(nonatomic,strong,readonly)UIButton *plusButton;
@property(nonatomic,strong,readonly)UILabel *valueLabel;
@end
