//
//  ViewCommonComputer.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-31.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "ViewCommonComputer.h"

@implementation ViewCommonComputer
#pragma mark- main methods
-(void)converLocation{
    
}
-(void)degreeOfView{
    UIView* view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 200, 200)];
    //change a random value of rotation
    view.transform = CGAffineTransformRotate(view.transform, M_PI/12);
    NSUInteger randNum = arc4random()%6+1;
    view.transform = CGAffineTransformRotate(view.transform, M_PI/randNum);
    randNum = arc4random()%6+1;
    view.transform = CGAffineTransformRotate(view.transform, M_PI/randNum);
    //compute the degree from view.transform
    CGFloat radians = atan2f(view.transform.b, view.transform.a);
    CGFloat degrees = radians * (180 / M_PI);
    //use degree to get target value
    NSUInteger value = [self getValueByDegree:degrees];
    
    NSLog(@"degrees:%f###### value:%d",degrees,value);
}

#pragma mark- util mehtods
-(NSUInteger)getValueByDegree:(CGFloat)degree{
    if (degree>=0&&degree<30) {
        return 2;
    }
    if (degree>=30&&degree<60) {
        return 1;
    }
    if (degree>=60&&degree<90) {
        return 2;
    }
    if (degree>=90&&degree<120) {
        return 3;
    }
    if (degree>=120&&degree<150) {
        return 1;
    }
    if (degree>=150&&degree<180) {
        return 1;
    }
    if (degree>=-180&&degree<-150) {
        return 2;
    }
    if (degree>=-150&&degree<-120) {
        return 3;
    }
    if (degree>=-120&&degree<-90) {
        return 4;
    }
    if (degree>=-90&&degree<-60) {
        return 1;
    }
    if (degree>=-60&&degree<-30) {
        return 2;
    }
    return 3;
}
@end
