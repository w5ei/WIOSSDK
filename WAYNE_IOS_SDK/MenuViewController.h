//
//  MenuViewController.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-9.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MenuViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>{
    __weak IBOutlet UITableView *_tableView;
}
@end
