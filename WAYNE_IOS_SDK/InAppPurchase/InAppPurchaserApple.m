//
//  InAppPurchaserApple.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-9-26.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "InAppPurchaserApple.h"

@implementation InAppPurchaserApple

- (void)dealloc{
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];
}

- (id)init{
    self = [super init];
    if (self) {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    }
    return self;
}

-(BOOL)canMakePayments{
    return [SKPaymentQueue canMakePayments];
}

-(void)retry{
    if (self.currentReceipt) {
        [self transactionCompletedWithReceipt:self.currentReceipt];
    }else if(self.currentProduct){
        [self purchaseProduct:self.currentProduct];
    }else{
        [self inAppPurchase:self failedWithError:nil];
    }
}

-(void)requestProductsWithIds:(NSSet *)productIds{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    request.delegate = self;
    [request start];
}
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchase:loadProductsFail:)]) {
        [self.delegate inAppPurchase:self loadProductsFail:error];
    }
}
-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
//    NSLog(@"%@",products);
    NSMutableArray* array = [NSMutableArray array];
    for (SKProduct* product in products) {
        Product* p = [[Product alloc]init];
        p.identifier = product.productIdentifier;
        p.localizedTitle = product.localizedTitle;
        p.priceLocale = product.priceLocale;
        p.price = product.price;
        [array addObject:p];
    }
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchase:productsLoaded:)]) {
        [self.delegate inAppPurchase:self productsLoaded:array];
    }
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for (SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchased:
                [self transactionCompletedWithReceipt:transaction.transactionReceipt];
                break;
            case SKPaymentTransactionStateFailed:
                if (transaction.error.code == SKErrorPaymentCancelled){
                    [self inAppPurchase:self failedWithError:nil];
                }else{
                    [self inAppPurchase:self failedWithError:transaction.error];
                }
                break;
            case SKPaymentTransactionStateRestored:{
                _currentProduct = [[Product alloc]init];
                _currentProduct.identifier = transaction.payment.productIdentifier;
                _currentProduct.quantity = transaction.payment.quantity;
                [self inAppPurchaseRestored:self];
            }
            case SKPaymentTransactionStatePurchasing:
                [self inAppPurchaseStarted:self];
                break;
        }
        if (transaction.transactionState!=SKPaymentTransactionStatePurchasing) {
            [self finishTransaction: transaction];
        }
    }
}

-(void)finishTransaction:(SKPaymentTransaction *)transaction{
    @try{
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    }@catch (NSException *exception){
        [self inAppPurchase:self failedWithError:nil];
    }
}

#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
-(void)purchaseProduct:(Product *)product{
    [super purchaseProduct:product];
    SKPayment* payment = [SKPayment paymentWithProductIdentifier:product.identifier];
    [[SKPaymentQueue defaultQueue]addPayment:payment];
}
#pragma GCC diagnostic warning "-Wdeprecated-declarations"

- (void)restoreCompletedTransactions{
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}

-(void)transactionCompletedWithReceipt:(NSData*)receipt{
    [super transactionCompletedWithReceipt:receipt];
    //交易成功,如果不是本地内购买还应该验证收据才能确定成功
    [self inAppPurchaseSuccess:self];
}

@end
