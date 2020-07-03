//
//  FayCollectionView.h
//  FayCollectionAddIndex
//
//  Created by fay on 16/7/27.
//  Copyright © 2016年 fay. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FayCollectionView;
@protocol FayCollectionViewDelegate <NSObject,UICollectionViewDelegate,UICollectionViewDataSource>

- (NSArray *)sectionIndexTitlesForFayCollectionView:(FayCollectionView *)tableView;

@end

@interface FayCollectionView : UIView

@property (nonatomic,weak)id<FayCollectionViewDelegate>delegate;
@property (nonatomic,strong)UICollectionView *collectionView;

- (void)reloadData;


@end
