//
//  InAppPurchaseViewController.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-16.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InAppPurchaserApple.h"
@interface InAppPurchaseViewController : UIViewController<InAppPurchaseDelegate>

@end
@interface ProductExtraInfo : NSObject
@property(nonatomic,assign)BOOL isRestoreable;
@property(nonatomic,assign)BOOL isRemoveAds;
@property(nonatomic,assign)BOOL isDoubleLife;
@property(nonatomic,assign)BOOL isReduceWaiting;
@property(nonatomic,assign)NSUInteger lifeAddCount;
@property(nonatomic,assign)NSUInteger deleteItemAddCount;
@property(nonatomic,assign)NSUInteger findItemAddCount;
@end