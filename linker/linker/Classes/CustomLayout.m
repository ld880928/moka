//
//  CustomLayout.m
//  TestCollectionView
//
//  Created by 李迪 on 14-7-5.
//  Copyright (c) 2014年 lidi. All rights reserved.
//

#import "CustomLayout.h"

#define DISTANCE 10.0f
#define BORDER_DISTANCE (320.0f - 190.0f) / 2

@implementation CustomLayout

- (void)prepareLayout
{
    
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *theLayoutAttributes = [[NSMutableArray alloc] init];

    for( int i = 0; i < self.mokaDatasArray.count; i++ ){
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        UICollectionViewLayoutAttributes *theAttributes = [self layoutAttributesForItemAtIndexPath:indexPath];
        [theLayoutAttributes addObject:theAttributes];
    }
    
    return [theLayoutAttributes copy];
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
    attributes.frame = CGRectMake(BORDER_DISTANCE + 190.0f * indexPath.item + DISTANCE * indexPath.item,0,190.0f , 340.0f);
    return attributes;
    
}

- (CGSize)collectionViewContentSize
{
    return CGSizeMake(BORDER_DISTANCE + 190.0f * self.mokaDatasArray.count + DISTANCE * self.mokaDatasArray.count - 1 + BORDER_DISTANCE, 340.0f);
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


@end
