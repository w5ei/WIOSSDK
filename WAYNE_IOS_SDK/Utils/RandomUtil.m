//
//  RandomUtil.m
//  YaoJiRewards
//
//  Created by Wayne on 14-6-5.
//  Copyright (c) 2014年 YaoJi. All rights reserved.
//

#import "RandomUtil.h"

@implementation RandomUtil
+(float)float0_1{
    return rand()/(float)RAND_MAX;;
}
+(BOOL)boolean{
    return [self float0_1]>0.5f;
}
@end
