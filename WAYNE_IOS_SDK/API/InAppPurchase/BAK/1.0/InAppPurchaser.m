//
//  InAppPurchaser.m
//  GuessWord
//
//  Created by green wayne on 13-8-16.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "InAppPurchaser.h"

@implementation InAppPurchaser

-(BOOL)canMakePayments{
    return NO;
}

-(void)retry{
}

-(void)purchaseProduct:(Product *)product{
    if (!product) {
        [self.delegate inAppPurchase:self failedWithError:nil];
        return;
    }
    if (product!=_currentProduct) {
        _currentProduct = product ;
    }
}

- (void)restoreCompletedTransactions{
    
}

-(void)transactionCompletedWithReceipt:(NSData*)receipt{
    if (receipt!=_currentReceipt) {
        _currentReceipt = receipt;
    }
}

-(void)inAppPurchaseStarted:(InAppPurchaser *)purchaser{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchaseStarted:)]) {
        [self.delegate inAppPurchaseStarted:purchaser];
    }
}

-(void)inAppPurchaseSuccess:(InAppPurchaser *)purchaser{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchaseSuccess:)]) {
        [self.delegate inAppPurchaseSuccess:purchaser];
    }
}

-(void)transactionRestored:(InAppPurchaser *)purchaser{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchaseSuccess:)]) {
        [self.delegate inAppPurchaseSuccess:purchaser];
    }
}

-(void)inAppPurchase:(InAppPurchaser *)purchaser failedWithError:(NSError*)error{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchase:failedWithError:)]) {
        [self.delegate inAppPurchase:purchaser failedWithError:error];
    }
}

@end
/////

/////
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

-(void)requestProductDataWithProductIds:(NSSet *)productIds{
    SKProductsRequest *request= [[SKProductsRequest alloc] initWithProductIdentifiers:productIds];
    request.delegate = self;
    [request start];
}

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    NSArray *products = response.products;
    NSLog(@"%@",products);
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
            case SKPaymentTransactionStateRestored:
                [self transactionRestored:self];
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
    SKPayment* payment=[SKPayment paymentWithProductIdentifier:product.identifier];
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
/////

/////
@implementation Product
- (id)init
{
    self = [super init];
    if (self) {
        self.quantity = 1;
    }
    return self;
}
-(void)setQuantity:(NSInteger)quantity{
    _quantity = quantity>=1?quantity:1;
}
@end
/////