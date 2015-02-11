//
//  InAppPurchaserApple.h
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-9-26.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "InAppPurchaser.h"
/**
 *
 */
@interface InAppPurchaserApple : InAppPurchaser<SKPaymentTransactionObserver,SKProductsRequestDelegate>
- (void) requestProductsWithIds:(NSSet *)productIds;
@end
