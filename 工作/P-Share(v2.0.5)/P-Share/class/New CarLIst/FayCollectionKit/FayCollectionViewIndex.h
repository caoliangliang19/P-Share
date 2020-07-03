//
//  FayCollectionViewIndex.h
//  FayCollectionAddIndex
//
//  Created by fay on 16/7/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FayCollectionViewIndex;

@protocol FayCollectionViewIndexDelegate <NSObject>
/**
 *  触摸到索引的反应
 *
 *  @param collectionView 触摸对象
 *  @param index          触摸索引的下标
 *  @param title          触摸索引的文字
 */
- (void)collectionViewIndex:(FayCollectionViewIndex *)collectionView didSelectionAtIndex:(NSInteger)index withTitle:(NSString *)title;
/**
 *  开始触摸索引
 *
 *  @param collectionViewIndex 触发collectionViewIndexTouchesBegan的对象
 */
- (void)collectionViewIndexTouchesBegan:(FayCollectionViewIndex *)collectionViewIndex;

/**
 *  触摸索引结束
 *
 *  @param collectionViewIndex tableViewIndex
 */
- (void)collectionViewIndexTouchesEnd:(FayCollectionViewIndex *)collectionViewIndex;


@end
@interface FayCollectionViewIndex : UIView
/**
 *  是否有边框线
 */
@property (nonatomic,assign)BOOL isFrameLayer;
/**
 *  索引数组
 */
@property (nonatomic,strong)NSArray *titleIndexs;

@property (nonatomic,weak)id<FayCollectionViewIndexDelegate> delegate;

@end
