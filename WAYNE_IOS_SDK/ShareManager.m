//
//  ShareManager.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-31.
//  Copyright (c) 2013年 cubic. All rights reserved.
//

#import "ShareManager.h"
#import "UMSocial.h"

@implementation ShareManager
+(void)shareToWechatTimelineWithImage:(UIImage*)image{
    [[UMSocialDataService defaultDataService]
     postSNSWithTypes:@[UMShareToWechatTimeline]
     content:nil
     image:image location:nil
     urlResource:nil
     presentedController:[[UIApplication sharedApplication]keyWindow].rootViewController completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
//            NSLog(@"分享成功！");
        }
    }];
}
@end
