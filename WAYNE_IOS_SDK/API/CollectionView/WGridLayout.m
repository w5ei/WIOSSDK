//
//  WGridLayout.m
//  WAYNE_IOS_SDK
//
//  Created by wayne on 14-9-29.
//  Copyright (c) 2014年 green wayne. All rights reserved.
//

#import "WGridLayout.h"

@implementation WGridLayout
- (instancetype)initWithItemSize:(CGSize)itemSize
{
    self = [super init];
    if (self) {
        self.minimumInteritemSpacing = 0;
        itemSize.width -= 20;
        self.itemSize = itemSize;
        self.minimumLineSpacing = 0;
        self.sectionInset = UIEdgeInsetsMake(4, 10, 4, 10);
    }
    return self;
}
- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // call super so flow layout can return default attributes for all cells, headers, and footers
    NSArray *array = [super layoutAttributesForElementsInRect:rect];
    
    // tweak the attributes slightly
    for (UICollectionViewLayoutAttributes *attributes in array)
    {
        int idx = [array indexOfObject:attributes];
        CGRect frame = attributes.frame;
        if (idx%2==0) {
            frame.origin.x+=4;
        }else{
            frame.origin.x-=4;
        }
        attributes.frame = frame;
    }
    return array;
}
@end
