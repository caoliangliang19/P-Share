//
//  CollectionView.h
//  P-SHARE
//
//  Created by fay on 16/9/7.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "BaseView.h"

@interface CollectionView : BaseView
@property (nonatomic,copy)void (^CollectionViewBlock)(MapSearchModel *);
- (void)collectionViewShow;
- (void)collectionViewHidden;
@end
