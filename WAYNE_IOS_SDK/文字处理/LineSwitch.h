//
//  LineSwitch.h
//
//
//  Created by wayne on 14-5-7.
//  Copyright (c) 2014年 wayne. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LineSwitchDelegate;
@interface LineSwitch : UIView
@property (strong, nonatomic) IBOutlet UIView *mainView;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (nonatomic, assign) BOOL isOn;
@property (nonatomic, assign)id<LineSwitchDelegate>delegate;
@end
@protocol LineSwitchDelegate <NSObject>
-(void)YJSwitchDidSwitch:(LineSwitch*)yjSwitch;
@end