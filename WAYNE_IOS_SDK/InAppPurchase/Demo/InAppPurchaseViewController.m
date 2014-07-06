//
//  InAppPurchaseViewController.m
//  WAYNE_IOS_SDK
//
//  Created by green wayne on 13-10-16.
//  Copyright (c) 2013年 green wayne. All rights reserved.
//

#import "InAppPurchaseViewController.h"
#import "MBProgressHUD.h"
#import "CommonEx.h"
#import "StringEx.h"
@implementation ProductExtraInfo
@end
@interface InAppPurchaseViewController (){
    NSArray* _productIds;
    InAppPurchaserApple* _purchaser;
    MBProgressHUD* _progressAlert;
}
@end

@implementation InAppPurchaseViewController
#pragma mark- InAppPurchase
-(void)showProgressAlert{
    if (_progressAlert==nil) {
        _progressAlert = [[MBProgressHUD alloc] initWithView:self.view];
        _progressAlert.dimBackground = YES;
        [self.view addSubview:_progressAlert];
    }
    [_progressAlert.superview bringSubviewToFront:_progressAlert];
    [_progressAlert show:YES];
}
-(Product*)productWithIdentifier:(NSString*)identifier{
    Product* product = [[Product alloc]init];
    product.identifier = identifier;
    ProductExtraInfo* productInfo = [[ProductExtraInfo alloc]init];
    product.extraData = productInfo;
    _productIds = @[@"1",@"2"];
    NSUInteger i = 0;
    if ([identifier isEqualToString:[_productIds objectAtIndex:i]]) {
        product.localizedTitle = @"1";//@"10次生命,15次去掉一个选项,5次提示一个选项";
        productInfo.lifeAddCount = 10;
        productInfo.deleteItemAddCount = 15;
        productInfo.findItemAddCount = 5;
    }
    if ([identifier isEqualToString:[_productIds objectAtIndex:i++]]) {
        product.localizedTitle = @"Remove Ads";
        productInfo.isRemoveAds = YES;
        productInfo.isRestoreable = YES;
    }
    return product;
}
#pragma mark- InAppPurchase Delegate
-(void)loadProducts{
    [self showProgressAlert];
    NSMutableArray* array = [NSMutableArray array];
    for (NSUInteger i=1; i<=6; i++) {
        if (i==5) {
            continue;
        }
        [array addObject:[NSString stringWithFormat:@"carpoptw00%d",i]];
    }
    [_purchaser requestProductsWithIds:[NSSet setWithArray:array]];
}
-(void)inAppPurchase:(InAppPurchaser *)purchaser loadProductsFail:(NSError *)error{
    [_progressAlert hide:NO];
    NSString* msg = [error localizedDescription];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:nil message:msg  delegate:nil cancelButtonTitle:@"OK".i18n otherButtonTitles: nil];
    [alert show];
}
-(void)inAppPurchase:(InAppPurchaser *)purchaser productsLoaded:(NSArray *)products{
//    NSLog(@"%@",products);
    for (Product* product in products) {
        NSString*identifier = product.identifier;
        if ([identifier isEqualToString:[_productIds objectAtIndex:0]]) {
        }
    }
    [_progressAlert hide:YES];
}
-(void)setupPriceLabelWithCell:(UITableViewCell*)cell text:(NSString*)text{
    UILabel* priceLabel = (UILabel*)[cell viewWithTag:1000];
    priceLabel.text = text;
}
-(void)inAppPurchaseStarted:(InAppPurchaser *)purchaser{
    [self showProgressAlert];
}
-(void)inAppPurchaseSuccess:(InAppPurchaser*)purchaser{
    [_progressAlert hide:NO];
    NSString* msg = [NSString stringWithFormat:@"You have got\"%@\"",purchaser.currentProduct.localizedTitle];
    ProductExtraInfo* pInfo = purchaser.currentProduct.extraData;
    //DO STH
    NSLog(@"%@",pInfo);
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Purchase Success" message:msg  delegate:self cancelButtonTitle:@"OK".i18n otherButtonTitles: nil];
    alert.tag = 100;
    [alert show];
}
-(void)inAppPurchase:(InAppPurchaser*)purchaser failedWithError:(NSError*)error{
    [_progressAlert hide:YES];
    if (error) {
        NSString* msg = error.localizedDescription;
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Purchase failed" message:msg  delegate:nil cancelButtonTitle:@"OK".i18n otherButtonTitles: nil];
        [alert show];
    }
}
-(void)inAppPurchaseRestored:(InAppPurchaser *)purchaser{
    [_progressAlert hide:NO];
    NSString* identifier = purchaser.currentProduct.identifier;
    Product* product = [self productWithIdentifier:identifier];
    ProductExtraInfo* pInfo = product.extraData;
    if (pInfo.isRemoveAds) {
    }
    NSString* msg = @"You have successfully restored your purchases.";//[NSString stringWithFormat:@"You have successfully restored your purchases.\"%@\"",product.localizedTitle];
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"Restore Success" message:msg  delegate:self cancelButtonTitle:@"OK".i18n otherButtonTitles: nil];
    alert.tag = 100;
    [alert show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==100) {
#warning 为什么没做这个处理，会一直显示
        [_progressAlert hide:YES];
    }
}
#pragma mark- Life Cycle
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _purchaser = [[InAppPurchaserApple alloc]init];
#warning delegate
    _purchaser.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
