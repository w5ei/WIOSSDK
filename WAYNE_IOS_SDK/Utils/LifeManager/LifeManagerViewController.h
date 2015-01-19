//
//  LifeManagerViewController.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-25.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LifeManager.h"
#import "WLifeManager.h"
@interface LifeManagerViewController : UIViewController<LifeManagerDelegate,WLifeManagerDelegate,UIGestureRecognizerDelegate>{
    __weak IBOutlet UILabel *_label;
    __weak IBOutlet UILabel *_label2;
    __weak IBOutlet UILabel *_label3;
}

@end
