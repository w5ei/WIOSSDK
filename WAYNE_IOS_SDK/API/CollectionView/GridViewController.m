//
//  GridViewController.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-9-28.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "GridViewController.h"
#import "WGridLayout.h"
@implementation GridViewController{
    IBOutlet UICollectionView *_cv;
}
-(void)viewDidLoad{
    [super viewDidLoad];
    
    [_cv setCollectionViewLayout:[[WGridLayout alloc] initWithItemSize:(CGSize){self.view.frame.size.width/2,100}]];
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    return [collectionView dequeueReusableCellWithReuseIdentifier:@"CELL1" forIndexPath:indexPath];
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 32;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}
@end
