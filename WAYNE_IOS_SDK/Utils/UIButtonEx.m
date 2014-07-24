//
//  UIButtonEx.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 12-10-10.
//
//

#import "UIButtonEx.h"
#import "GameManager.h"
@implementation UIButtonEx
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    if (self.soundEnable) {
        [[GameManager sharedInstance] playClickEffect];
    }
}
@end
