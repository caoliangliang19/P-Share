//
//  FayCollectionViewHeadLayout.m
//  FayCollectionAddIndex
//
//  Created by fay on 16/7/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "FayCollectionViewHeadLayout.h"

@implementation FayCollectionViewHeadLayout

- (NSArray *) layoutAttributesForElementsInRect:(CGRect)rect
{
    NSMutableArray *answer = [[super layoutAttributesForElementsInRect:rect] mutableCopy];
    NSMutableIndexSet *missingSections = [NSMutableIndexSet indexSet];
    
    for (NSUInteger i=0; i<answer.count; i++) {
        UICollectionViewLayoutAttributes *layoutAttribute = answer[i];
        
        if (layoutAttribute.representedElementCategory == UICollectionElementCategoryCell) {
//            remember that we need to layout header for this section
            [missingSections addIndex:layoutAttribute.indexPath.section];
        }
        
        if ([layoutAttribute.representedElementKind isEqualToString:UICollectionElementKindSectionHeader]) {
//            remove layout of header done by our super, we will do it right later
            [answer removeObjectAtIndex:i];
            i --;
        }
    }
//    layout all headers needed for the rect using self code
    [missingSections enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL * _Nonnull stop) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:idx];
        UICollectionViewLayoutAttributes *layoutAttribute = [self layoutAttributesForSupplementaryViewOfKind:UICollectionElementKindSectionHeader atIndexPath:indexPath];
        [answer addObject:layoutAttribute];
        
    }];
    
    return answer;
    
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForSupplementaryViewOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewLayoutAttributes *attributes = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:indexPath];
    
    if ([elementKind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionView *const vc = self.collectionView;
        CGPoint const contentOffset = vc.contentOffset;
        CGPoint nextHeightOrigin = CGPointMake(INFINITY, INFINITY);
        
        if (indexPath.section+1 < [vc numberOfSections]) {
            UICollectionViewLayoutAttributes *nextHeadAttr = [super layoutAttributesForSupplementaryViewOfKind:elementKind atIndexPath:[NSIndexPath indexPathForItem:0 inSection:indexPath.section+1]];
            nextHeightOrigin = nextHeadAttr.frame.origin;
        }
        
        CGRect frame = attributes.frame;
        
        if (self.scrollDirection == UICollectionViewScrollDirectionVertical) {
            frame.origin.y  = MIN(MAX(contentOffset.y, frame.origin.y), nextHeightOrigin.y - CGRectGetHeight(frame));
        }else
        {
            frame.origin.x = MIN(MAX(contentOffset.x, frame.origin.x), nextHeightOrigin.x - CGRectGetWidth(frame));
        }
        
        attributes.zIndex = 1024;
        
        attributes.frame = frame;
    }
    
    return attributes;
}

- (UICollectionViewLayoutAttributes *)initialLayoutAttributesForAppearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    UICollectionViewLayoutAttributes *attributes = [super initialLayoutAttributesForAppearingSupplementaryElementOfKind:elementKind atIndexPath:elementIndexPath];
    return attributes;
}

- (UICollectionViewLayoutAttributes *)finalLayoutAttributesForDisappearingSupplementaryElementOfKind:(NSString *)elementKind atIndexPath:(NSIndexPath *)elementIndexPath
{
    UICollectionViewLayoutAttributes *attribute = [self layoutAttributesForDecorationViewOfKind:elementKind atIndexPath:elementIndexPath];
    return attribute;
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}
@end
