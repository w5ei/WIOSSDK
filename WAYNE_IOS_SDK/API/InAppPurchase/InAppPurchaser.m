//
//  InAppPurchaser.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-8-16.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//
#import "InAppPurchaser.h"
@interface InAppPurchaser ()
-(void)transactionCompletedWithReceipt:(id)receipt;
@end
@implementation InAppPurchaser

-(BOOL)canMakePayments{
    return YES;
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

-(void)transactionCompletedWithReceipt:(id)receipt{
    if (receipt&&receipt!=_currentReceipt) {
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

-(void)inAppPurchaseRestored:(InAppPurchaser *)purchaser{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchaseRestored:)]) {
        [self.delegate inAppPurchaseRestored:purchaser];
    }
}

-(void)inAppPurchase:(InAppPurchaser *)purchaser failedWithError:(NSError*)error{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(inAppPurchase:failedWithError:)]) {
        [self.delegate inAppPurchase:purchaser failedWithError:error];
    }
}

+(NSString*)localeCurrencySymbol{
    NSLocale* locale = [NSLocale currentLocale];
    return [locale objectForKey:NSLocaleCurrencySymbol];
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
-(NSString *)priceLocaleString{
    if (_priceLocaleString==nil) {
        NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [numberFormatter setLocale:_priceLocale];
        NSString * formattedPrice = [numberFormatter stringFromNumber:_price];
//        NSLog(@"#######%@",formattedPrice);
        return formattedPrice;
    }
    return _priceLocaleString;
}
-(NSString *)description{
    return [NSString stringWithFormat:@"id:%@  priceLocale:%@  localizedTitle:%@",_identifier,_localizedTitle,_price];
}
@end
/////